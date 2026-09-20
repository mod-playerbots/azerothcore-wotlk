--[[
    Paragon Level-Up Animation Module

    Provides visual feedback when players gain Paragon levels by performing
    a one-shot Roar emote on the player.

    Registered mediator events:
    - OnParagonLevelChanged: React to level-up events

    @module paragon_levelup_animation
    @author Paragon Team
    @license AGL v3
]]

-- Emote ID: 15, EMOTE_ONESHOT_ROAR. A simple one-shot animation played
-- directly on the player via PerformEmote, with no aura or spell visual involved.
local EMOTE_ONESHOT_ROAR = 15

-- ============================================================================
-- ANIMATION HANDLERS
-- ============================================================================

---
--- Handles Paragon level changes and triggers level-up animation.
---
--- When a player gains a Paragon level (new_level > old_level), performs a
--- one-shot Roar emote on the player.
---
--- Mediator Event: OnParagonLevelChanged
---
--- @param player Player The player object that leveled up
--- @param _ Paragon The paragon instance (unused)
--- @param old_level number The player's previous Paragon level
--- @param new_level number The player's new Paragon level
---
local function OnParagonLevelChanged(player, _, old_level, new_level)
    if new_level > old_level then
        player:PerformEmote(EMOTE_ONESHOT_ROAR)
    end
end

-- Register for level change events
RegisterMediatorEvent("OnParagonLevelChanged", OnParagonLevelChanged)

-- ============================================================================
-- MODULE INITIALIZATION
-- ============================================================================

print("[Paragon] Paragon Anniversary Level Animation module loaded")
