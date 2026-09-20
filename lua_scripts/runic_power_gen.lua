--[[
Backfills Runic Power for classless characters who have picked up Death Knight
abilities, the same way rage_gen.lua backfills Rage for borrowed Warrior/Druid
abilities.

Every player already has a live Runic Power field: Player::UpdateAllStats sets
SetMaxPower for every Powers index (0..MAX_POWERS-1) regardless of getClass(),
so MaxPower(RUNIC_POWER) is 1000 on a Druid exactly like it is on a real Death
Knight. And a spell's cost/energize check reads the power field its own
PowerType names -- not the caster's active/displayed power type. So a Druid
never sees a red Runic Power bar, but ModifyPower(x, POWER_RUNIC_POWER) still
lets Runic-Power-costing Death Knight spells resolve.

This only grants Runic Power on the "generator" side (the rune abilities that
build it on a real Death Knight). The "spender" side (Death Coil, Frost
Strike, Rune Strike, ...) needs no help: Spell::CalculatePowerCost already
checks GetPower(POWER_RUNIC_POWER) directly.
]]

local PLAYER_EVENT_ON_SPELL_CAST = 5
local POWER_RUNIC_POWER = 6

-- spellId -> Runic Power generated on cast (rune-spender abilities that
-- energize Runic Power on a real Death Knight). Approximate, single-rank
-- 3.3.5 values -- same "close enough" spirit as rage_gen.lua's table.
local generators = {
    [45477] = 10, -- Icy Touch
    [45462] = 10, -- Plague Strike
    [45902] = 10, -- Blood Strike
    [49020] = 15, -- Obliterate
    [48721] = 10, -- Blood Boil
    [50842] = 10, -- Pestilence
    [55090] = 15, -- Scourge Strike
    [49998] = 10, -- Death Strike
    [47568] = 25, -- Empower Rune Weapon
}

local function OnCast(event, player, spell, skipCheck)
    if player:IsBot() then
        return
    end

    local amount = generators[spell:GetEntry()]
    if not amount then
        return
    end

    player:ModifyPower(amount, POWER_RUNIC_POWER)
end

RegisterPlayerEvent(PLAYER_EVENT_ON_SPELL_CAST, OnCast)
