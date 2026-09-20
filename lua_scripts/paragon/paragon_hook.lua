--[[
    Paragon Hook System

    Manages all server-side event hooks and client-server communication for the
    paragon system. Handles player login/logout, experience gains, and statistic
    updates through event handlers and addon communication.

    Responsibilities:
    - Player login/logout lifecycle management
    - Experience gain distribution from various sources
    - Statistic point allocation and reallocation
    - Client-server addon communication
    - Event registration for ALE/Eluna

    Architecture:
    - Event-driven design with Mediator pattern
    - Server events trigger paragon state updates
    - Client packets processed through addon functions
    - Statistics applied/removed atomically

    @module paragon_hook
    @author iThorgrim
    @license AGL v3
]]

local Paragon = require("paragon_class")
local Config = require("paragon_config")
local Repository = require("paragon_repository")
local Constant = require("paragon_constant")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local Hook = {
    Addon = {
        Prefix = "ParagonAnniversary",
        Functions = {
            [1] = "OnParagonClientLoadRequest",
            [2] = "OnParagonClientSendStatistics"
        }
    }
}

-- Experience source type enumeration
local EXPERIENCE_SOURCE = {
    CREATURE = 1,
    ACHIEVEMENT = 2,
    SKILL = 3,
    QUEST = 4
}

-- ============================================================================
-- PRIVATE FUNCTIONS
-- ============================================================================

---
--- Retrieves a player object from their GUID low value.
---
--- @param guid_low The low part of the player's GUID
--- @return The player object, or false if not found
---
local function GetPlayerIfExist(guid_low)
    local guid = GetPlayerGUID(guid_low)
    if not guid then
        return false
    end

    local player = GetPlayerByGUID(guid)
    if not player then
        return false
    end

    return player
end

-- ============================================================================
-- INDIVIDUAL PROGRESSION GATE
-- ============================================================================

-- mod-individual-progression stores a character's progression stage as hidden
-- rewarded quests (66000 + ProgressionState). That stage is what decides the
-- level the core stops granting XP at: 60 until PROGRESSION_PRE_TBC is passed,
-- 70 until PROGRESSION_TBC_TIER_5 is passed, then the server max level.
-- Paragon stays locked until the character actually sits at that cap.
local IP_QUEST_BASE = 66000
local IP_PROGRESSION_PRE_TBC = 8
local IP_PROGRESSION_TBC_TIER_5 = 13
local IP_PROGRESSION_MAX_STATE = 18
local IP_VANILLA_MAX_LEVEL = 60
local IP_TBC_MAX_LEVEL = 70
local QUEST_STATUS_REWARDED = 6

---
--- Reads a numeric worldserver/module config option.
---
--- GetConfigValue returns a number, a boolean (for "true"/"false") or an empty
--- string when the key is missing, so normalise all of those to a number.
---
--- @param key The config option name
--- @param default Value returned when the option is missing or unreadable
--- @return number The config value
---
local function GetServerConfigNumber(key, default)
    if type(GetConfigValue) ~= "function" then
        return default
    end

    local value = GetConfigValue(key)
    if value == nil or value == "" then
        return default
    end

    if type(value) == "boolean" then
        return value and 1 or 0
    end

    return tonumber(value) or default
end

---
--- Returns the highest individual progression stage the character has cleared.
---
--- Mirrors IndividualProgression::GetPlayerProgressionFromQuests: the stage is
--- the highest hidden progression quest that has been rewarded.
---
--- @param player The player object
--- @return number The progression stage (0 = nothing cleared)
---
local function GetProgressionState(player)
    local state = 0

    for i = 1, IP_PROGRESSION_MAX_STATE do
        if player:GetQuestStatus(IP_QUEST_BASE + i) == QUEST_STATUS_REWARDED then
            state = i
        end
    end

    return state
end

---
--- Returns the level cap individual progression currently enforces for a player.
---
--- Falls back to the server max level when the module is disabled, and honours
--- IndividualProgression.ProgressionLimit the same way the module does (a stage
--- above the limit counts as not passed).
---
--- @param player The player object
--- @return number The current max level for that character
---
local function GetIndividualProgressionMaxLevel(player)
    local server_max_level = GetServerConfigNumber("MaxPlayerLevel", 80)

    if GetServerConfigNumber("IndividualProgression.Enable", 0) ~= 1 then
        return server_max_level
    end

    local limit = GetServerConfigNumber("IndividualProgression.ProgressionLimit", 0)
    local state = GetProgressionState(player)

    local function has_passed(required_state)
        if limit > 0 and required_state > limit then
            return false
        end

        return state >= required_state
    end

    if not has_passed(IP_PROGRESSION_PRE_TBC) then
        return IP_VANILLA_MAX_LEVEL
    end

    if not has_passed(IP_PROGRESSION_TBC_TIER_5) then
        return IP_TBC_MAX_LEVEL
    end

    return server_max_level
end

---
--- Checks whether paragon is unlocked for a player.
---
--- Paragon points only become spendable on the combat categories once the
--- character has reached the level cap of its current progression stage. The
--- utility category stays open while levelling, and already invested bonuses
--- stay applied either way.
---
--- Set REQUIRE_PROGRESSION_MAX_LEVEL_FOR_PARAGON to 0 in `paragon_config` to
--- disable this gate.
---
--- @param player The player object
--- @return boolean True when every category is spendable
--- @return number The level required to unlock the gated categories
---
local function IsParagonUnlocked(player)
    local required_level = GetIndividualProgressionMaxLevel(player)

    if tonumber(Config:GetByField("REQUIRE_PROGRESSION_MAX_LEVEL_FOR_PARAGON") or 1) ~= 1 then
        return true, required_level
    end

    return player:GetLevel() >= required_level, required_level
end

---
--- Returns the categories that can be spent in before the level cap is reached.
---
--- Defaults to the last category (the utility line - experience, reputation,
--- gold, movement speed, loot), which is what helps a character level in the
--- first place. Override with a comma separated list of category ids in the
--- CATEGORIES_ALWAYS_UNLOCKED field of `paragon_config`.
---
--- @return table Set of category_id -> true
---
local function GetAlwaysUnlockedCategories()
    local categories = Config:GetCategories() or {}
    local configured = Config:GetByField("CATEGORIES_ALWAYS_UNLOCKED")
    local unlocked = {}

    if configured then
        for id in tostring(configured):gmatch("%d+") do
            unlocked[tonumber(id)] = true
        end

        return unlocked
    end

    -- No override: the highest category id is the utility line
    local last_category = nil
    for category_id in pairs(categories) do
        if not last_category or category_id > last_category then
            last_category = category_id
        end
    end

    if last_category then
        unlocked[last_category] = true
    end

    return unlocked
end

---
--- Checks whether a single category can be spent in right now.
---
--- @param player The player object
--- @param category_id The category ID to test
--- @return boolean True when points may be assigned in that category
--- @return number The level required to unlock it
---
local function IsCategoryUnlocked(player, category_id)
    local unlocked, required_level = IsParagonUnlocked(player)
    if unlocked then
        return true, required_level
    end

    return GetAlwaysUnlockedCategories()[category_id] == true, required_level
end

-- ============================================================================
-- MOVEMENT SPEED STATISTIC
-- ============================================================================

-- The AURA statistics are seeded against spell ids 1900000-1900002, which exist
-- in neither the server's Spell.dbc nor the spell_dbc table, so AddAura is a no
-- op for them. MOVE_SPEED is not even mapped to an id. Apply it as a speed rate
-- instead, and re-assert it periodically: the core recomputes speed rates from
-- scratch whenever a mount, snare or speed aura changes, which drops the bonus.
local MOVE_RUN = 1
local MOVE_SWIM = 3
local MOVE_FLIGHT = 6
local SPEED_MOVE_TYPES = { MOVE_RUN, MOVE_SWIM, MOVE_FLIGHT }
local UPKEEP_INTERVAL = 3000
local SPEED_EPSILON = 0.001

-- guid_low -> { bonus, rates = { [move_type] = rate } }: what we last applied,
-- so the bonus can be taken back out and the core's own rate recovered
local speed_state = {}

-- Payout per invested point and the ceiling on the total, in percent. Both are
-- overridable per statistic with <NAME>_PERCENT_PER_POINT / <NAME>_MAX_PERCENT
-- rows in `paragon_config`.
local AURA_STAT_DEFAULTS = {
    MOVE_SPEED    = { per_point = 0.5, max_percent = 25 },
    MOUNT_SPEED   = { per_point = 0.5, max_percent = 25 },
    GOLD          = { per_point = 0.5, max_percent = 25 },
    REPUTATION    = { per_point = 0.5, max_percent = 25 },
    CRAFTSMANSHIP = { per_point = 0.5, max_percent = 25 },
    SCAVENGER     = { per_point = 0.5, max_percent = 25 }
}

-- value name -> statistic id, or false when the config has no such statistic
local aura_stat_ids = {}

---
--- Finds the statistic id configured for an AURA statistic by its enum name.
---
--- Cached after the first lookup; the config is static for the Lua state.
---
--- @param value_name The type_value name, e.g. "MOVE_SPEED"
--- @return number|nil The statistic id, or nil when none is configured
---
local function GetAuraStatId(value_name)
    local cached = aura_stat_ids[value_name]
    if cached ~= nil then
        return cached or nil
    end

    for _, category_data in pairs(Config:GetCategories() or {}) do
        for stat_id, stat_data in pairs(category_data.statistics or {}) do
            if stat_data.type == "AURA" and stat_data.value == value_name then
                aura_stat_ids[value_name] = stat_id
                return stat_id
            end
        end
    end

    aura_stat_ids[value_name] = false
    return nil
end

---
--- Returns the bonus a paragon has invested in an AURA statistic, as a fraction.
---
--- @param paragon The paragon instance
--- @param value_name The type_value name, e.g. "GOLD"
--- @return number The bonus as a fraction (0.12 for +12%)
---
local function GetAuraStatBonus(paragon, value_name)
    local stat_id = paragon and GetAuraStatId(value_name)
    if not stat_id then
        return 0
    end

    local points = paragon:GetStatValue(stat_id)
    if not points or points <= 0 then
        return 0
    end

    local defaults = AURA_STAT_DEFAULTS[value_name]
    if not defaults then
        return 0
    end

    local per_point = tonumber(Config:GetByField(value_name .. "_PERCENT_PER_POINT")) or defaults.per_point
    local max_percent = tonumber(Config:GetByField(value_name .. "_MAX_PERCENT")) or defaults.max_percent

    return math.min(points * per_point, max_percent) / 100
end

---
--- Returns the speed bonus a paragon should have right now, as a fraction.
---
--- MOVE_SPEED applies always, MOUNT_SPEED only while mounted, and the two add up
--- so a mounted player gets both.
---
--- @param player The player object
--- @param paragon The paragon instance
--- @return number The bonus as a fraction (0.12 for +12%)
---
local function GetMoveSpeedBonus(player, paragon)
    local bonus = GetAuraStatBonus(paragon, "MOVE_SPEED")

    if player:IsMounted() then
        bonus = bonus + GetAuraStatBonus(paragon, "MOUNT_SPEED")
    end

    return bonus
end

---
--- Sets the movement speed bonus on a player.
---
--- Multiplies whatever rate the core last computed rather than overwriting it,
--- so mounts and snares keep working. Our own previous contribution is divided
--- back out first when the rate still matches what we set.
---
--- Uses SetSpeed(.., forced) and not SetSpeedRate: the latter is a bare
--- `m_speed_rate[mtype] = rate` in the core, so it neither propagates nor tells
--- the client, and the player keeps moving at the old speed.
---
--- @param player The player object
--- @param bonus The bonus fraction to apply (0 removes it)
---
local function SetMoveSpeedBonus(player, bonus)
    local guid_low = player:GetGUIDLow()
    local state = speed_state[guid_low]
    local rates = {}

    for _, move_type in ipairs(SPEED_MOVE_TYPES) do
        local rate = player:GetSpeedRate(move_type)

        -- Recover the core's rate. If it no longer matches what we set, the core
        -- has recomputed since and the current value is already bonus free.
        if state and math.abs(rate - (state.rates[move_type] or 0)) < SPEED_EPSILON then
            rate = rate / (1 + state.bonus)
        end

        rates[move_type] = rate
    end

    speed_state[guid_low] = nil

    if not bonus or bonus <= 0 then
        for _, move_type in ipairs(SPEED_MOVE_TYPES) do
            player:SetSpeed(move_type, rates[move_type], true)
        end

        return
    end

    local applied = {}
    for _, move_type in ipairs(SPEED_MOVE_TYPES) do
        applied[move_type] = rates[move_type] * (1 + bonus)
        player:SetSpeed(move_type, applied[move_type], true)
    end

    speed_state[guid_low] = { bonus = bonus, rates = applied }
end

---
--- Applies or removes all paragon statistic modifiers to a player.
---
--- Iterates through all invested statistics and applies/removes bonuses based on
--- the statistic type (UNIT_MODS, COMBAT_RATING, or AURA).
---
--- Mediator Events:
--- - OnBeforeUpdatePlayerStatistics: (player, paragon, apply) - allows modification before applying
--- - OnAfterUpdatePlayerStatistics: (player, paragon, apply) - allows cleanup after applying
---
--- @param player The player object to update
--- @param paragon The paragon instance containing stat data
--- @param apply Boolean indicating whether to apply (true) or remove (false) the bonuses
---
local function UpdatePlayerStatistics(player, paragon, apply)
    if not apply then
        apply = false
    end

    -- Allow modules to hook before statistics are applied/removed
    player, paragon, apply = Mediator.On("OnBeforeUpdatePlayerStatistics", {
        arguments = { player, paragon, apply },
        defaults = { player, paragon, apply },
    })

    -- Movement speed is handled outside the loop below: it is a speed rate, not
    -- an aura, and has to be taken back out before it can be reapplied
    SetMoveSpeedBonus(player, apply and GetMoveSpeedBonus(player, paragon) or 0)

    local statistics = paragon:GetStatistics()
    if not statistics then
        return
    end

    for stat_id, stat_value in pairs(statistics) do
        if not stat_value or stat_value <= 0 then
            goto continue
        end

        local stat_data = Config:GetByStatId(stat_id)
        if not stat_data then
            goto continue
        end

        local constant_stat_type = Constant.STATISTICS[stat_data.type]
        if not constant_stat_type then
            goto continue
        end

        -- Resolve the enum name (stat_data.value, e.g. "STAT_STRENGTH", "LOOT") to
        -- its numeric constant. Seed data can reference names that are not defined
        -- in paragon_constant.lua (e.g. AURA "MOVE_SPEED"/"GOLD"); skip those rather
        -- than pass nil into the core methods.
        local resolved_value = constant_stat_type[stat_data.value]
        if resolved_value == nil then
            goto continue
        end

        -- Apply bonus based on statistic type
        if stat_data.type == "UNIT_MODS" then
            player:HandleStatFlatModifier(resolved_value, stat_data.application, stat_value, apply)
        elseif stat_data.type == "COMBAT_RATING" then
            player:ApplyRatingMod(resolved_value, stat_value, apply)
        elseif stat_data.type == "AURA" then
            if apply then
                for _ = 1, stat_value do
                    player:AddAura(resolved_value, player)
                end
            else
                player:RemoveAura(resolved_value)
            end
        end

        ::continue::
    end

    -- Allow modules to hook after statistics are applied/removed
    Mediator.On("OnAfterUpdatePlayerStatistics", {
        arguments = { player, paragon, apply },
    })
end

-- ============================================================================
-- PLAYER EXPERIENCE MANAGEMENT
-- ============================================================================

---
--- Updates player paragon experience based on activity source.
---
--- Calculates experience reward for the given source type and entry, then
--- processes experience gain through the Mediator system which handles
--- level-ups and point allocation.
---
--- Mediator Events:
--- - OnBeforeUpdatePlayerExperience: (player, paragon, source_type, entry) - allows modification before award
--- - OnExperienceCalculated: (player, paragon, source_type, specific_experience) - after calculation
--- - OnUpdatePlayerExperience: (player, paragon, specific_experience) - delegates level-up handling
--- - OnAfterUpdatePlayerExperience: (player, paragon) - cleanup after processing
--- - OnParagonStateSync: (player, paragon) - allows custom sync logic before sending to client
---
--- @param player The player object
--- @param paragon The paragon instance to update
--- @param source_type The source type (EXPERIENCE_SOURCE enum)
--- @param entry The source entry ID (creature ID, achievement ID, skill ID, or quest ID)
--- @return boolean True if experience was awarded, false otherwise
---
local function UpdatePlayerExperience(player, paragon, source_type, entry)
    if not player or not paragon or not source_type or not entry then
        return false
    end

    -- Check minimum level requirement
    local min_level = tonumber(Config:GetByField("MINIMUM_LEVEL_FOR_PARAGON_XP")) or 0
    if player:GetLevel() < min_level then
        return false
    end

    paragon, source_type, entry = Mediator.On("OnBeforeUpdatePlayerExperience", {
        arguments = { player, paragon, source_type, entry },
        defaults = { paragon, source_type, entry },
    })

    -- Map source type to config key
    local source_config_map = {
        [EXPERIENCE_SOURCE.CREATURE] = "UNIVERSAL_CREATURE_EXPERIENCE",
        [EXPERIENCE_SOURCE.ACHIEVEMENT] = "UNIVERSAL_ACHIEVEVEMENT_EXPERIENCE",
        [EXPERIENCE_SOURCE.SKILL] = "UNIVERSAL_SKILL_EXPERIENCE",
        [EXPERIENCE_SOURCE.QUEST] = "UNIVERSAL_QUEST_EXPERIENCE"
    }

    local config_key = source_config_map[source_type] or "UNIVERSAL_CREATURE_EXPERIENCE"
    local universal_value = tonumber(Config:GetByField(config_key)) or 0

    if universal_value <= 0 then
        return false
    end

    -- Get source-specific experience value (falls back to universal value)
    local source_experience_map = {
        ["UNIVERSAL_CREATURE_EXPERIENCE"] = Config:GetCreatureExperience(entry),
        ["UNIVERSAL_ACHIEVEVEMENT_EXPERIENCE"] = Config:GetAchievementExperience(entry),
        ["UNIVERSAL_SKILL_EXPERIENCE"] = Config:GetSkillExperience(entry),
        ["UNIVERSAL_QUEST_EXPERIENCE"] = Config:GetQuestExperience(entry)
    }

    local specific_experience = source_experience_map[config_key] or universal_value
    if not specific_experience then
        return false
    end

    -- Allow modules to see the calculated experience before processing
    specific_experience = Mediator.On("OnExperienceCalculated", {
        arguments = { player, paragon, source_type, specific_experience },
        defaults = { specific_experience },
    })

    -- Process experience gain through Mediator (triggers level-ups)
    paragon = Mediator.On("OnUpdatePlayerExperience", {
        arguments = { player, paragon, specific_experience },
        defaults = { paragon }
    })

    -- Allow modules to customize how paragon state is synced to client
    Mediator.On("OnParagonStateSync", {
        arguments = { player, paragon },
    })

    -- Update client with new paragon state
    player:SendServerResponse(Hook.Addon.Prefix, 1, paragon:GetLevel())
    player:SendServerResponse(Hook.Addon.Prefix, 4, paragon:GetPoints())
    player:SendServerResponse(Hook.Addon.Prefix, 2, paragon:GetExperience(), paragon:GetExperienceForNextLevel())

    player:SetData("Paragon", paragon)

    Mediator.On("OnAfterUpdatePlayerExperience", {
        arguments = { player, paragon },
    })

    return true
end

-- ============================================================================
-- PLAYER POINTS MANAGEMENT
-- ============================================================================

---
--- Updates a character's paragon statistic investment and available points.
---
--- Validates point availability and stat limits before applying changes.
--- Recursively handles point reallocation if negative points result from change.
---
--- @param player The player object
--- @param paragon The paragon instance to update
--- @param stat_id The statistic ID to modify
--- @param stat_value The new value to set for the statistic
--- @return boolean True if points were updated, false otherwise
---
local function UpdateParagonPoints(player, paragon, stat_id, stat_value)
    if not player or not paragon or not stat_id or not stat_value then
        return false
    end

    paragon, stat_id, stat_value = Mediator.On("OnBeforeUpdateParagonPoints", {
        arguments = { player, paragon, stat_id, stat_value },
        defaults = { paragon, stat_id, stat_value },
    })

    local actual_stat_value = paragon:GetStatValue(stat_id)
    local available_points = paragon:GetPoints()

    -- Recalculate available points based on change in stat value
    if actual_stat_value > stat_value then
        available_points = available_points + (actual_stat_value - stat_value)
    elseif actual_stat_value < stat_value then
        available_points = available_points - (stat_value - actual_stat_value)
    end

    paragon, stat_id, actual_stat_value, available_points = Mediator.On("OnUpdateParagonPoints", {
        arguments = { player, paragon, stat_id, actual_stat_value, available_points },
        defaults = { paragon, stat_id, actual_stat_value, available_points },
    })

    -- If negative points, recursively deallocate and revert
    if available_points < 0 then
        UpdateParagonPoints(player, paragon, stat_id, actual_stat_value)
        return false
    end

    -- Apply the stat change
    paragon:SetPoints(available_points)
    paragon:SetStatValue(stat_id, stat_value)

    -- Send updated stat to client
    player:SendServerResponse(Hook.Addon.Prefix, 5, {
        id = stat_id,
        value = stat_value,
        category = Config:GetCategoryByStatId(stat_id)
    })

    Mediator.On("OnAfterUpdateParagonPoints", {
        arguments = { player, paragon, stat_id, stat_value }
    })

    return true
end

-- ============================================================================
-- ADDON COMMAND HANDLERS
-- ============================================================================

---
--- Handles client request to load and display all paragon data.
---
--- Sends the player's level, experience, categories, and statistics to the
--- client addon for UI display and interaction.
---
--- Mediator Events:
--- - OnBeforeClientLoadRequest: (player, paragon) - allows modification before loading
--- - OnAfterClientLoadRequest: (player, paragon, categories) - allows modification of sent data
---
--- Each category carries a `locked` field holding the level it unlocks at, or
--- nil when it is spendable. The client greys those lines out and refuses input
--- on them; the server enforces the same rule in OnParagonClientSendStatistics.
---
--- @param player The player object making the request
--- @param _ Unused parameter (always nil for addon requests)
---
function OnParagonClientLoadRequest(player, _)
    if not player then
        return false
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        -- The asynchronous load started by OnPlayerLogin has not finished yet.
        -- Do NOT start another one here: that would race a second Paragon instance
        -- against the first and apply every stat bonus twice. Just record that the
        -- client is waiting; OnPlayerStatLoad pushes the data once the load lands.
        player:SetData("ParagonClientWaiting", true)
        return false
    end

    -- Trigger Mediator event before loading
    paragon = Mediator.On("OnBeforeClientLoadRequest", {
        arguments = { player, paragon },
        defaults = { paragon },
    })

    -- Build category/statistic data with player's current assignments
    local categories = Config:GetCategories()
    if not categories then
        return false
    end

    for category_id, category_data in pairs(categories) do
        -- Always assign, never leave a stale value behind: the category table is
        -- shared between every player, so a nil here would keep the previous
        -- player's flag
        local category_unlocked, required_level = IsCategoryUnlocked(player, category_id)
        category_data.locked = (not category_unlocked) and required_level or nil

        local statistics = category_data.statistics
        if statistics then
            for stat_id, stat_data in pairs(statistics) do
                stat_data.assigned = paragon:GetStatValue(stat_id)
            end
        end
    end

    -- Allow modules to modify the data sent to client
    categories = Mediator.On("OnAfterClientLoadRequest", {
        arguments = { player, paragon, categories },
        defaults = { categories },
    })

    -- Send complete paragon state to client
    player:SendServerResponse(Hook.Addon.Prefix, 1, paragon:GetLevel())
    player:SendServerResponse(Hook.Addon.Prefix, 2, paragon:GetExperience(), paragon:GetExperienceForNextLevel())
    player:SendServerResponse(Hook.Addon.Prefix, 3, categories)
    player:SendServerResponse(Hook.Addon.Prefix, 4, paragon:GetPoints())

    return true
end

---
--- Handles client request to update paragon statistics.
---
--- Validates all statistic changes, recalculates available points, and
--- updates statistic bonuses. Processes changes atomically to prevent
--- invalid state transitions.
---
--- Mediator Events:
--- - OnBeforeClientStatisticsUpdate: (player, paragon, data) - allows modification before processing
--- - OnBeforeStatisticChange: (player, paragon, stat_id, value) - per-stat hook before validation
--- - OnAfterStatisticChange: (player, paragon, stat_id, value) - per-stat hook after application
--- - OnAfterClientStatisticsUpdate: (player, paragon) - allows cleanup after all updates
---
--- @param player The player object making the request
--- @param arg_table Table containing {statistics_array} with categoryId, statId, and value
--- @return boolean True if all updates succeeded, false if validation failed
---
function OnParagonClientSendStatistics(player, arg_table)
    if not player or not arg_table then
        return false
    end

    local data = arg_table[1]
    if not data then
        player:SendNotification("ERROR.")
        return false
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return false
    end

    -- Trigger Mediator event before processing any statistics
    paragon, data = Mediator.On("OnBeforeClientStatisticsUpdate", {
        arguments = { player, paragon, data },
        defaults = { paragon, data },
    })

    -- Temporarily remove all stat bonuses during processing
    UpdatePlayerStatistics(player, paragon, false)

    -- Process each statistic update
    for _, updated_data in pairs(data) do
        -- Validate category
        local category_id = updated_data.categoryId
        if not category_id then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        local categories = Config:GetCategories()
        local category_data = categories[category_id]
        if not category_data then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        -- Categories other than the utility line stay locked until the character
        -- reaches the level cap of its individual progression stage
        local category_unlocked, required_level = IsCategoryUnlocked(player, category_id)
        if not category_unlocked then
            player:SendNotification("This paragon line unlocks at level " .. required_level .. ".")
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        -- Validate statistic
        local statistic_id = updated_data.statId
        if not statistic_id then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        local statistic_data = category_data.statistics[statistic_id]
        if not statistic_data then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        -- Validate value and limit
        local statistic_value = updated_data.value
        if not statistic_value or statistic_value < 0 then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        if statistic_data.limit > 0 and statistic_value > statistic_data.limit then
            UpdatePlayerStatistics(player, paragon, true)
            return false
        end

        -- Allow modules to intercept before stat change (for additional validation/modification)
        paragon, statistic_id, statistic_value = Mediator.On("OnBeforeStatisticChange", {
            arguments = { player, paragon, statistic_id, statistic_value },
            defaults = { paragon, statistic_id, statistic_value },
        })

        -- Apply the stat change
        UpdateParagonPoints(player, paragon, statistic_id, statistic_value)

        -- Allow modules to hook after stat change (for side effects, logging, etc.)
        Mediator.On("OnAfterStatisticChange", {
            arguments = { player, paragon, statistic_id, statistic_value },
        })
    end

    player:SetData("Paragon", paragon)

    -- Reapply all stat bonuses after processing
    UpdatePlayerStatistics(player, paragon, true)
    player:SendServerResponse(Hook.Addon.Prefix, 4, paragon:GetPoints())

    -- Trigger Mediator event after all statistics have been updated
    Mediator.On("OnAfterClientStatisticsUpdate", {
        arguments = { player, paragon },
    })

    return true
end

-- ============================================================================
-- PLAYER LIFECYCLE MANAGEMENT
-- ============================================================================

---
--- Callback executed after paragon data has been loaded from the database.
---
--- Applies all stat bonuses and syncs UI with loaded paragon state.
---
--- @param guid_low The low part of the player's GUID
--- @param paragon The loaded paragon instance
--- @return boolean True if successful, false if player not found
---
function Hook.OnPlayerStatLoad(guid_low, paragon)
    if not guid_low or not paragon then
        return false
    end

    local player = GetPlayerIfExist(guid_low)
    if not player then
        return false
    end

    -- Trigger Mediator event for post-load processing
    paragon = Mediator.On("OnPlayerStatLoad", {
        arguments = { player, paragon },
        defaults = { paragon }
    })

    player:SetData("Paragon", paragon)

    -- Load finished: allow a future login/reload to load again, and clear the
    -- "client asked before we were ready" marker.
    player:SetData("ParagonLoading", false)
    player:SetData("ParagonClientWaiting", false)

    -- Apply all loaded statistics bonuses to the character
    UpdatePlayerStatistics(player, paragon, true)

    -- Sync UI with loaded paragon state
    OnParagonClientLoadRequest(player)

    return true
end

---
--- Handles player login event.
---
--- Creates new paragon instance and asynchronously loads character-specific
--- data from the database. Handles player initialization on first login.
---
--- @param event The event ID (3 = PLAYER_EVENT_ON_LOGIN)
--- @param player The player object that logged in
--- @return boolean Always returns nil for event handlers
---
function Hook.OnPlayerLogin(event, player)
    if not player then
        return
    end

    -- Check if paragon system is enabled
    local system_enabled = tonumber(Config:GetByField("ENABLE_PARAGON_SYSTEM")) or 1
    if system_enabled == 0 then
        return
    end

    -- Get paragon configuration and player info
    local account_id = player:GetAccountId()
    local character_guid = player:GetGUIDLow()

    -- Guard against a second concurrent load for the same player. Without this,
    -- an early client load request (or a repeated login event) would start another
    -- asynchronous Paragon load, and both callbacks would call
    -- UpdatePlayerStatistics(player, paragon, true) - applying every bonus twice.
    if player:GetData("ParagonLoading") then
        return
    end
    player:SetData("ParagonLoading", true)

    -- Create new paragon instance with account_id
    local paragon = Paragon(character_guid, account_id)

    -- Trigger Mediator event before loading
    paragon, callback = Mediator.On("OnBeforePlayerStatLoad", {
        arguments = { player, paragon },
        defaults = { paragon, Hook.OnPlayerStatLoad }
    })

    -- Asynchronously load paragon data from database
    paragon:Load(callback)

    Mediator.On("OnAfterPlayerStatLoad", {
        arguments = { player, paragon },
    })
end

---
--- Handles player logout event.
---
--- Removes all stat bonuses and saves paragon progress to the database.
--- Called when a player disconnects or logs out.
---
--- @param event The event ID (4 = PLAYER_EVENT_ON_LOGOUT)
--- @param player The player object that logged out
--- @return boolean Always returns nil for event handlers
---
function Hook.OnPlayerLogout(event, player)
    if not player then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    -- Trigger Mediator event before saving
    paragon = Mediator.On("OnBeforePlayerStatSave", {
        arguments = { player, paragon },
        defaults = { paragon }
    })

    -- Remove all stat bonuses from character
    UpdatePlayerStatistics(player, paragon, false)

    -- Save paragon progress to database
    paragon:Save()

    Mediator.On("OnAfterPlayerStatSave", {
        arguments = { player, paragon },
    })
end

---
--- Handles character deletion event.
---
--- Cleans up paragon data when a character is deleted from the account.
--- Only deletes data if LEVEL_LINKED_TO_ACCOUNT is disabled (character-level paragon).
--- When account-level paragon is enabled, data persists for other characters on the account.
---
--- @param event The event ID (2 = PLAYER_EVENT_ON_CHARACTER_DELETE)
--- @param player_guid The GUID of the character being deleted
---
function Hook.OnCharacterDelete(event, player_guid)
    -- Delete paragon data (method will check account_linked and handle appropriately)
    -- If account-linked: preserves data (other characters on account still use it)
    -- If character-linked: deletes data for this character
    if player_guid then
        Repository:DeleteParagonData(player_guid)
    end
end

-- ============================================================================
-- PLAYER EXPERIENCE EVENTS
-- ============================================================================

---
--- Handles creature kill event.
---
--- Awards paragon experience when a player kills a creature that has been
--- configured with experience rewards.
---
--- Mediator Events:
--- - OnBeforeCreatureExperience: (player, creature, paragon) - allows modification before award
---
--- @param event The event ID (7 = PLAYER_EVENT_ON_KILL_CREATURE)
--- @param player The player object that killed the creature
--- @param creature The creature object that was killed
---
function Hook.OnPlayerKillCreature(event, player, creature)
    if not player or not creature then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    -- Allow modules to intercept creature experience gain
    paragon = Mediator.On("OnBeforeCreatureExperience", {
        arguments = { player, creature, paragon },
        defaults = { paragon },
    })

    UpdatePlayerExperience(player, paragon, EXPERIENCE_SOURCE.CREATURE, creature:GetEntry())
end

---
--- Handles achievement complete event.
---
--- Awards paragon experience when a player completes an achievement that has
--- been configured with experience rewards.
---
--- Mediator Events:
--- - OnBeforeAchievementExperience: (player, achievement, paragon) - allows modification before award
---
--- @param event The event ID (45 = PLAYER_EVENT_ON_ACHIEVEMENT_COMPLETE)
--- @param player The player object that completed the achievement
--- @param achievement The achievement object that was completed
---
function Hook.OnPlayerAchievementComplete(event, player, achievement)
    if not player or not achievement then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    -- Allow modules to intercept achievement experience gain
    paragon = Mediator.On("OnBeforeAchievementExperience", {
        arguments = { player, achievement, paragon },
        defaults = { paragon },
    })

    UpdatePlayerExperience(player, paragon, EXPERIENCE_SOURCE.ACHIEVEMENT, achievement:GetId())
end

---
--- Handles quest complete event.
---
--- Awards paragon experience when a player completes a quest that has been
--- configured with experience rewards.
---
--- Mediator Events:
--- - OnBeforeQuestExperience: (player, quest, paragon) - allows modification before award
---
--- @param event The event ID (54 = PLAYER_EVENT_ON_QUEST_COMPLETE)
--- @param player The player object that completed the quest
--- @param quest The quest object that was completed
---
function Hook.OnPlayerQuestComplete(event, player, quest)
    if not player or not quest then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    -- Allow modules to intercept quest experience gain
    paragon = Mediator.On("OnBeforeQuestExperience", {
        arguments = { player, quest, paragon },
        defaults = { paragon },
    })

    UpdatePlayerExperience(player, paragon, EXPERIENCE_SOURCE.QUEST, quest:GetId())
end

---
--- Handles skill update event.
---
--- Awards paragon experience when a player increases a skill that has been
--- configured with experience rewards.
---
--- Mediator Events:
--- - OnBeforeSkillExperience: (player, skill_id, paragon) - allows modification before award
---
--- @param event The event ID (62 = PLAYER_EVENT_ON_SKILL_UPDATE)
--- @param player The player object whose skill was updated
--- @param skill_id The skill ID that was updated
--- @param value Current skill value (unused)
--- @param max Maximum skill value (unused)
--- @param step Skill step increase (unused)
--- @param new_value New skill value (unused)
---
function Hook.OnPlayerSkillUpdate(event, player, skill_id, value, max, step, new_value)
    if not player or not skill_id then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    -- Allow modules to intercept skill experience gain
    paragon = Mediator.On("OnBeforeSkillExperience", {
        arguments = { player, skill_id, paragon },
        defaults = { paragon },
    })

    UpdatePlayerExperience(player, paragon, EXPERIENCE_SOURCE.SKILL, skill_id)
end

-- ============================================================================
-- AURA STATISTIC PAYOUTS
-- ============================================================================

---
--- Pays out the GOLD statistic on looted money.
---
--- Deliberately hooks loot rather than PLAYER_EVENT_ON_MONEY_CHANGE: that fires
--- for every money movement, including gold received in a trade or the mail, so
--- boosting it would let two players pass the same gold back and forth and mint
--- the bonus out of nothing.
---
--- @param event The event ID (37 = PLAYER_EVENT_ON_LOOT_MONEY)
--- @param player The player looting
--- @param amount The copper looted
---
function Hook.OnPlayerLootMoney(event, player, amount)
    if not player or not amount or amount <= 0 then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    local bonus = GetAuraStatBonus(paragon, "GOLD")
    if bonus <= 0 then
        return
    end

    -- The hook cannot rewrite the looted amount, so hand over the extra
    local extra = math.floor(amount * bonus)
    if extra > 0 then
        player:ModifyMoney(extra)
    end
end

---
--- Boosts reputation gains by the REPUTATION statistic.
---
--- The core hands the hook the absolute new standing, not the gain: incremental
--- amounts are already folded in and clamped by ReputationMgr before any script
--- sees them. The gain is recovered by diffing against the current standing, so
--- only that difference is boosted - multiplying `standing` itself would inflate
--- the player's entire reputation with the faction on every tick.
---
--- @param event The event ID (15 = PLAYER_EVENT_ON_REPUTATION_CHANGE)
--- @param player The player gaining reputation
--- @param faction_id The faction being changed
--- @param standing The new absolute standing
--- @param incremental True when this is a gain rather than a set
--- @return number|nil The boosted standing, or nil to leave it alone
---
function Hook.OnPlayerReputationChange(event, player, faction_id, standing, incremental)
    if not player or not incremental or not standing then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    local bonus = GetAuraStatBonus(paragon, "REPUTATION")
    if bonus <= 0 then
        return
    end

    local gained = standing - (player:GetReputation(faction_id) or 0)
    if gained <= 0 then
        return
    end

    local boosted = standing + math.floor(gained * bonus)

    -- A standing of exactly -1 is the hook's "cancel this change" signal
    if boosted == -1 then
        return
    end

    return boosted
end

-- Skills CRAFTSMANSHIP applies to. Deliberately not every skill: the hook also
-- fires for weapon and defense skill ups, which have nothing to do with a trade.
local CRAFTSMANSHIP_SKILLS = {
    [129] = true,  -- First Aid
    [164] = true,  -- Blacksmithing
    [165] = true,  -- Leatherworking
    [171] = true,  -- Alchemy
    [182] = true,  -- Herbalism
    [185] = true,  -- Cooking
    [186] = true,  -- Mining
    [197] = true,  -- Tailoring
    [202] = true,  -- Engineering
    [333] = true,  -- Enchanting
    [356] = true,  -- Fishing
    [393] = true,  -- Skinning
    [755] = true,  -- Jewelcrafting
    [773] = true   -- Inscription
}

-- Item classes SCAVENGER refuses to duplicate
local ITEM_CLASS_QUEST = 12
local ITEM_CLASS_KEY = 13

---
--- Grants an extra skill point on trade skill ups for CRAFTSMANSHIP.
---
--- The hook hands over the character's *current* skill value, and the core adds
--- `step` to whatever this returns - so returning value + 1 lands two points
--- instead of one. The bump is skipped when it would reach the cap, because the
--- core bails out entirely on `value >= max` and the player would lose the gain
--- altogether.
---
--- @param event The event ID (61 = PLAYER_EVENT_ON_BEFORE_UPDATE_SKILL)
--- @param player The player gaining the skill point
--- @param skill_id The skill being raised
--- @param value The character's current skill value
--- @param max The character's maximum for that skill
--- @param step The amount the core is about to add
--- @return number|nil The adjusted current value, or nil to leave it alone
---
function Hook.OnPlayerBeforeUpdateSkill(event, player, skill_id, value, max, step)
    if not player or not skill_id or not value or not max then
        return
    end

    if not CRAFTSMANSHIP_SKILLS[skill_id] then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    local chance = GetAuraStatBonus(paragon, "CRAFTSMANSHIP")
    if chance <= 0 or math.random() >= chance then
        return
    end

    local extra = 1
    if value + extra + (step or 1) > max then
        return
    end

    return value + extra
end

---
--- Duplicates a looted item for SCAVENGER.
---
--- The hook cannot change what dropped, so the extra copy is handed over
--- separately. Quest items and keys are excluded: duplicates of those are either
--- rejected outright or actively confusing.
---
--- @param event The event ID (32 = PLAYER_EVENT_ON_LOOT_ITEM)
--- @param player The player looting
--- @param item The item looted
--- @param count How many were looted
---
function Hook.OnPlayerLootItem(event, player, item, count)
    if not player or not item then
        return
    end

    local paragon = player:GetData("Paragon")
    if not paragon then
        return
    end

    local chance = GetAuraStatBonus(paragon, "SCAVENGER")
    if chance <= 0 or math.random() >= chance then
        return
    end

    local item_class = item:GetClass()
    if item_class == ITEM_CLASS_QUEST or item_class == ITEM_CLASS_KEY then
        return
    end

    -- Item has no GetEntry of its own in ALE; go through its template
    local template = item.GetItemTemplate and item:GetItemTemplate()
    local entry = template and template:GetItemId()
    if not entry then
        return
    end

    player:AddItem(entry, count or 1)
end

-- ============================================================================
-- SERVER EVENTS
-- ============================================================================

---
--- Handles Lua state open event.
---
--- Called when the server is initialized or Lua scripts are reloaded.
--- Reloads paragon data for all players currently in the world.
---
--- @param event The event ID (33 = SERVER_EVENT_ON_LUA_STATE_OPEN)
---
function Hook.OnLuaStateOpen(event)
    local players = GetPlayersInWorld()
    if not players then
        return
    end

    for _, player in pairs(players) do
        Hook.OnPlayerLogin(3, player)
    end
end

---
--- Re-asserts the speed bonus on a player when it has drifted.
---
--- The core recomputes speed rates from its own auras whenever a player mounts,
--- dismounts, is snared or gains a speed buff, which silently drops the paragon
--- bonus. Nothing hooks that recompute, so poll for it instead - the work is a
--- float compare per player. Mounting also changes the target bonus itself,
--- because MOUNT_SPEED only counts while mounted.
---
--- @param player The player object
--- @param paragon The paragon instance
---
local function UpkeepMoveSpeed(player, paragon)
    local bonus = GetMoveSpeedBonus(player, paragon)
    local state = speed_state[player:GetGUIDLow()]

    if bonus <= 0 then
        -- Nothing to grant: only act if a bonus of ours is still applied
        if state then
            SetMoveSpeedBonus(player, 0)
        end

        return
    end

    local drifted = not state
        or math.abs(state.bonus - bonus) > SPEED_EPSILON
        or math.abs(player:GetSpeedRate(MOVE_RUN) - (state.rates[MOVE_RUN] or 0)) > SPEED_EPSILON

    if drifted then
        SetMoveSpeedBonus(player, bonus)
    end
end

---
--- Periodic upkeep for the statistics the core cannot maintain on its own.
---
--- Runs every UPKEEP_INTERVAL for players who have paragon data loaded.
---
local function ParagonUpkeep()
    local players = GetPlayersInWorld()
    if not players then
        return
    end

    for _, player in pairs(players) do
        local paragon = player:GetData("Paragon")
        if paragon then
            UpkeepMoveSpeed(player, paragon)
        end
    end
end

---
--- Handles Lua state close event.
---
--- Called when the Lua scripts are being unloaded or the server is shutting down.
--- Saves paragon data for all players currently in the world.
---
--- @param event The event ID (16 = SERVER_EVENT_ON_LUA_STATE_CLOSE)
---
function Hook.OnLuaStateClose(event)
    local players = GetPlayersInWorld()
    if not players then
        return
    end

    for _, player in pairs(players) do
        Hook.OnPlayerLogout(4, player)
    end
end

---
--- Handles player command event.
---
--- Currently supports a "test" command for debugging paragon system functionality.
--- Can be extended to support additional admin commands.
---
--- @param event The event ID (42 = PLAYER_EVENT_ON_COMMAND)
--- @param player The player object executing the command
--- @param command The command string entered by the player (without leading slash)
--- @return boolean False to allow other command handlers to process the command
---
function Hook.OnPlayerCommand(event, player, command)
    if not player or not command then
        return
    end

    if command == "test" then
        local paragon = player:GetData("Paragon")
        if not paragon then
            return false
        end

        -- Remove existing bonuses
        UpdatePlayerStatistics(player, paragon, false)

        -- Add test stat value
        paragon:AddStatValue(1, 150)
        player:SetData("Paragon", paragon)

        -- Reapply bonuses
        UpdatePlayerStatistics(player, paragon, true)

        return false
    end
end

-- ============================================================================
-- EVENT REGISTRATION
-- ============================================================================

-- Player Events
RegisterPlayerEvent(2, Hook.OnCharacterDelete)
RegisterPlayerEvent(3, Hook.OnPlayerLogin)
RegisterPlayerEvent(4, Hook.OnPlayerLogout)
RegisterPlayerEvent(7, Hook.OnPlayerKillCreature)
RegisterPlayerEvent(15, Hook.OnPlayerReputationChange)
RegisterPlayerEvent(32, Hook.OnPlayerLootItem)
RegisterPlayerEvent(37, Hook.OnPlayerLootMoney)
RegisterPlayerEvent(61, Hook.OnPlayerBeforeUpdateSkill)
RegisterPlayerEvent(42, Hook.OnPlayerCommand)
RegisterPlayerEvent(45, Hook.OnPlayerAchievementComplete)
RegisterPlayerEvent(54, Hook.OnPlayerQuestComplete)
RegisterPlayerEvent(62, Hook.OnPlayerSkillUpdate)

-- Server Events
RegisterServerEvent(16, Hook.OnLuaStateClose)
RegisterServerEvent(33, Hook.OnLuaStateOpen)

-- Speed and recovery upkeep (0 repeats = forever)
CreateLuaEvent(ParagonUpkeep, UPKEEP_INTERVAL, 0)

-- Addon Communication Events
RegisterClientRequests(Hook.Addon)

return Hook