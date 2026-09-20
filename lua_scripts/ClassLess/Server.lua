--  ___ ___ _ __      _____   ___  ___    ___ ___ ___  _   ___ _  __
-- | __| __| |\ \    / / _ \ / _ \|   \  | _ \ __| _ \/_\ / __| |/ /
-- | _|| _|| |_\ \/\/ / (_) | (_) | |) | |   / _||  _/ _ \ (__| ' <
-- |_| |___|____\_/\_/ \___/ \___/|___/  |_|_\___|_|/_/ \_\___|_|\_\
--
-- A character has no class abilities. Everything it can do is FOUND: one tome item per
-- ability RANK, dropped by a creature or handed over by a quest, and reading it teaches
-- that rank outright. That is the whole system -- there is no selection step, no point
-- budget, and no panel.
--
-- Removed on 2026-08-13, and worth knowing about because half the comments in the git
-- history refer to them:
--   * Ability Points. An active ability is self-limiting (there are only so many buttons),
--     so pricing one bought nothing, and the always-on stuff a price was really holding
--     back is now gated on ACQUISITION instead -- the rare pre-cast buffs are boss-only
--     and bind on pickup.
--   * Talent Points. Only the panel could ever spend them, so once the panel went they
--     defended nothing. Passive stacking is now limited by acquisition alone, same as
--     everything else.
--   * The ability-picker panel and the Tome Journal, and with them the LearnSpell /
--     LearnTalent / WipeAll handlers, the shared-secret check that authenticated those
--     handlers, and the spells/tpells/talents/stats/resets columns they wrote to.
--
-- What survives is acquisition and persistence: what you have found (`pool`), what you may
-- wield and wear (`profs`), and the hooks that hand those out.

-- Eluna's Lua state does not seed math.random, and Lua 5.1 without a seed hands back the
-- SAME sequence on every run -- which for this file would mean every server restart giving
-- out the same starter spell and the same bounty draws in the same order. This used to happen by
-- accident: A_encryption.lua called math.randomseed() as a side effect of generating the
-- panel's shared secret. That file is gone with the panel, so seed it deliberately.
math.randomseed(os.time())

-- mod-individual-progression stamps quest (66000 + progression stage) REWARDED as a player
-- crosses each stage (IndividualProgression.cpp, GetPlayerProgressionFromQuests /
-- UpdateProgressionState). 13 is PROGRESSION_TBC_TIER_5, the stage individualProgression.
-- conf.dist itself uses as the WotLK boundary (DeathKnightUnlockProgression default, and
-- every Northrend/Naxxramas access check in IndividualProgressionPlayer.cpp). Runic Power is
-- a Death Knight resource, so the client-side bar for it should stay hidden until a
-- character has actually crossed into that content, same as the Death Knight class itself.
local WOTLK_PROGRESSION_QUEST = 66013
-- PROGRESSION_PRE_TBC = 8 (Karazhan/Gruul/Magtheridon), the stage individualProgression.conf
-- itself uses as the point Outland opens (TbcRacesUnlockProgression default). Used below to
-- keep bounties from pointing a still-vanilla character at an Outland/Northrend zone.
local TBC_PROGRESSION_QUEST = 66008

-- Zone/instance names (bounties.data's "place" field) that belong to content gated by
-- individual progression. A bounty whose target lives here must not be handed to a player
-- who has not yet crossed the matching boundary -- otherwise a fresh vanilla character can
-- be sent at a mob in a locked expansion zone (e.g. "Bounty: Vale Moth" on Azuremyst Isle
-- landing in a level-1 Undead character's questlog).
local TBC_ZONES = {
    ["Auchindoun: Auchenai Crypts"] = true, ["Auchindoun: Mana-Tombs"] = true,
    ["Mana-Tombs"] = true, ["Azuremyst Isle"] = true, ["Blade's Edge Mountains"] = true,
    ["Bloodmyst Isle"] = true, ["Coilfang: The Slave Pens"] = true, ["Slave Pens"] = true,
    ["Underbog"] = true, ["The Underbog"] = true, ["Hellfire Citadel: The Blood Furnace"] = true,
    ["Hellfire Peninsula"] = true, ["Isle of Quel'Danas"] = true, ["Magister's Terrace"] = true,
    ["Magisters' Terrace"] = true, ["Nagrand"] = true, ["Netherstorm"] = true,
    ["Sethekk Halls"] = true, ["Shadow Labyrinth"] = true, ["Shadowmoon Valley"] = true,
    ["Shattered Halls"] = true, ["The Shattered Halls"] = true, ["Terokkar Forest"] = true,
    ["The Arcatraz"] = true, ["The Botanica"] = true, ["The Mechanar"] = true,
    ["The Steamvault"] = true, ["Zangarmarsh"] = true, ["The Black Morass"] = true,
    ["The Escape From Durnholde"] = true,
}
local WOTLK_ZONES = {
    ["Ahn'kahet: The Old Kingdom"] = true, ["Azjol-Nerub"] = true, ["Borean Tundra"] = true,
    ["Crystalsong Forest"] = true, ["Dragonblight"] = true, ["Drak'Tharon Keep"] = true,
    ["Grizzly Hills"] = true, ["Gundrak"] = true, ["Halls of Lightning"] = true,
    ["Halls of Reflection"] = true, ["Halls of Stone"] = true, ["Howling Fjord"] = true,
    ["Icecrown"] = true, ["Pit of Saron"] = true, ["Sholazar Basin"] = true,
    ["The Nexus"] = true, ["The Oculus"] = true, ["The Forge of Souls"] = true,
    ["The Storm Peaks"] = true, ["Utgarde Pinnacle"] = true, ["Violet Hold"] = true,
    ["The Violet Hold"] = true, ["Wintergrasp"] = true, ["Zul'Drak"] = true,
    ["The Culling of Stratholme"] = true,
}

local handlerName = "yQ4CiWjHET"

--Functions
local function toTable(string)
    local t = {}
    if string ~= "" then
        for i in string.gmatch(string, "([^,]+)") do
            table.insert(t, tonumber(i))
        end
    end
    return t
end

local function toString(tbl)
    local string = ""
    if #tbl > 1 then
        string = table.concat(tbl, ",")
    elseif #tbl == 1 then
        string = tbl[1]
    end
    return string
end

-- Put one item in a player's bags and say honestly whether it landed.
--
-- Player:AddItem cannot be trusted directly: on success it returns the new Item, but when
-- there is no room it returns WITHOUT pushing anything, so the call yields whatever argument
-- was left on the stack -- the count, a truthy 1. Counting the item before and after is the
-- only test that distinguishes "in the bag" from "dropped on the floor of the universe".
--
-- It matters for exactly the grants that have no second chance: a bounty payout, a
-- quest-sourced tome. A silent loss there is a rank the player can never get from that source
-- again.
local function GiveItem(player, itemId)
    local before = player:GetItemCount(itemId, false)
    player:AddItem(itemId, 1)
    return player:GetItemCount(itemId, false) > before
end

--Init
local AIO = AIO or require("AIO")
-- Kept rather than discarded: the collection panel answers client requests, and
-- AIO.AddHandlers registers a dispatcher that closes over THIS table, so adding functions to
-- it later is enough -- there is no second registration call.
local Handlers = AIO.AddHandlers(handlerName, {})

-- =====================================================================================
-- Ability pool -- which ability RANKS a character has found.
--
-- Held twice on purpose: `pools[guid]` is an array, because that is what gets serialised to
-- the DB column and insertion order keeps the stored string stable; `poolSet[guid]` is the
-- same ids as a set, because every read is a membership test. The array alone meant a linear
-- scan per test, and GrantRandomHint did one of those per candidate across ~4000 candidates
-- on 2% of every kill in the world -- millions of comparisons on Eluna's single blocking
-- Lua state. Anything that inserts must write to both; PoolAdd() below is the only place
-- that does, so there is exactly one function to keep honest.
-- =====================================================================================
local pools, poolSet = {}, {}

-- guid -> { [request kind] = { n = served so far this window, at = when it opened } }. Declared
-- up here with the other per-player state because OnDelete and OnLogout clear it, and both of
-- those are defined above the panel's own section.
local throttleAt = {}

-- At most `limit` requests of a kind per player per `window` seconds. Says whether this one may
-- be served.
--
-- Everything the panel can ask for runs on the single Lua state the whole world shares, and the
-- cheapest of these is not cheap: CollSuggest walks all 1,180 lines and sorts them, CollLine asks
-- the quest system for a status per rank. Only the full index was limited once, so a modified
-- client -- or a keybind held down -- could hold the realm still through any of the others.
--
-- An ALLOWANCE and not a gap between requests, which is what this was first written as. A hard
-- one-per-second is slower than reading: opening the collection means clicking line after line,
-- and the gate silently dropped every click after the first. verify.py's panel round-trip caught
-- it by opening two lines in a row and getting one answer.
--
-- A fixed window rather than a sliding one, so a burst straddling the boundary can be twice the
-- allowance. That is fine: the allowances are set for comfortable use, not to the edge of what
-- the server can bear.
local function Throttle(guid, kind, limit, window)
    local t = throttleAt[guid]
    if t == nil then
        t = {}
        throttleAt[guid] = t
    end
    local slot = t[kind]
    local now = os.time()
    if slot == nil or now - slot.at >= window then
        t[kind] = { n = 1, at = now }
        return true
    end
    if slot.n >= limit then
        return false
    end
    slot.n = slot.n + 1
    return true
end

-- Forward declaration. ForgetPlayer drops every per-guid table this file keeps and is defined
-- with the logout hook at the bottom -- but OnDelete needs it too, and OnDelete is defined up
-- here with the rest of the early hooks. It used to carry its own hand-written copy of the list,
-- which is precisely the drift ForgetPlayer was written to end: that copy was already seven
-- tables behind, missing every practice table.
local ForgetPlayer

-- guid -> { [lineId] = how many ranks of that line the character has found }. Kept by
-- PoolInsert, which is the only door into the pool, so it cannot drift from poolSet. The panel
-- asks this 1180 times per request; counting it there meant walking every rank chain in the
-- game twice per keypress, on the one thread the world runs on.
local lineOwned = {}

-- rankSpellId -> { itemId, kind, srcEntry, srcName, place, level, srcLevel }
-- Keyed by RANK, not by line: acquisition is one tome per rank, so Fireball rank 4 is a
-- different book from rank 3 with its own source.
local tomeOf = {}
-- The ALT SOURCES table is gone with the per-row placement it patched (2026-09-13). An alt was a
-- SECOND creature carrying a tome, added where a zone had too few for anyone levelling there to
-- find abilities without leaving. Under the group rule an ability is carried by a kind of
-- creature -- a median of 229 of them -- so there is no single source left to put a net under.
-- CLDB.altsources is written empty and nothing reads it.
-- tome item id -> rankSpellId, for the item-use handler
local rankOfItem = {}
-- lineId -> { every rank spell id in the chain }, used by the pool migration, which still
-- talks in whole chains
local ranksOfLine = {}
-- any rank spell id -> the line it belongs to, and that rank's own required level
local lineOfSpell, rankLevel = {}, {}
-- The browsable catalogue, built from the same walk of spells.data/talents.data that fills
-- the tables above. One entry per SPEC:
--   { cls = "WARRIOR", kind = "s"|"t", spec = "Arms", icon = "...", lines = { lineId, ... } }
-- Only the collection panel reads it. It exists because the client no longer carries the
-- spell trees (see Client.lua's header) and so has nothing to page through on its own.
local catalog = {}
-- lineId -> "CLASS|Spec". The catalogue splits a spec in two pages -- spells and talents get
-- their own -- but PRACTICE treats them as one thing: fighting with an Arms ability is what
-- earns the Arms talents. spells.data and talents.data name the specs identically, so the
-- class and the spec name are enough to join them.
local treeOfLine = {}
-- spellLine -> { talentLine, ... } from bind.data, and the set of talent lines that appear in
-- one. A talent bound to a spell is offered against that spell's next rank; the 204 that are
-- bound to nothing are bought from their tree instead, and this is how the two are told apart.
local bindOf = {}
-- Ranks at or below these levels are granted at character creation. BOTH ARE 0, which means
-- nothing at all is granted: a new character starts with an empty spellbook and every single
-- ability, including Fireball rank 1, has to be found in the world.
--
-- 0 works because no rank's required level is below 1, so `level <= 0` is never true.
-- Raising either constant re-seeds -- and REQUIRES regenerating tomes.data, because the
-- generator reads these to decide which ranks get a world source and a loot row. A rank that
-- is seeded AND droppable is a wasted drop; one that is neither is unobtainable.
--
-- At 0 the generator emits no "s" rows at all, so starterPool below is empty and its backfill
-- is a no-op. Both are kept because this is the knob that changes that.
local STARTER_LEVEL = 0
local STARTER_TALENT_LEVEL = 0
local starterPool = {}
-- Which lines came from talents.data. Only used to keep talents out of the random starter
-- grant below -- they have their own starter tier via STARTER_TALENT_LEVEL.
local isTalentLine = {}

local function LoadLua(path)
    local chunk, err = loadfile(path)
    if not chunk then
        print("[ClassLess] could not load " .. path .. ": " .. tostring(err))
        return false
    end
    local ok, cerr = pcall(chunk)
    if not ok then
        print("[ClassLess] error running " .. path .. ": " .. tostring(cerr))
        return false
    end
    return true
end

-- The data files are plain Lua that fill CLDB. Nothing is shipped to the client any more
-- (see Client.lua's header); these are read off disk and stay here.
local function LoadTomes()
    LoadLua("lua_scripts/ClassLess/data/spells.data")
    LoadLua("lua_scripts/ClassLess/data/talents.data")
    -- Which talents each spell improves (bindgen.py, off Spell.dbc). Optional: without it the
    -- practice mechanic simply never offers a talent instead of a rank.
    LoadLua("lua_scripts/ClassLess/data/bind.data")
    -- How many times a fight each ability is expected to be pressed (practicegen.py, off
    -- Spell.dbc). Optional: without it every ability falls back to PRACTICE_CASTS, which makes
    -- a damage-over-time and a spam button advance at the same rate per PRESS instead of per
    -- fight -- playable, but the wrong shape.
    LoadLua("lua_scripts/ClassLess/data/practice.data")
    -- Needed so the random level-1 starter grant can tell a "buff"/"raid_buff" line from one
    -- that gives a new character something to actually fight with.
    LoadLua("lua_scripts/ClassLess/data/roles.data")
    -- Which lines rank up on LEVEL instead of on practice (autorank.py, off roles.data and
    -- Spell.dbc). Optional: without it every line is practised, which is what buffs, stances and
    -- teleports could never actually pay for.
    LoadLua("lua_scripts/ClassLess/data/autorank.data")
    -- Which KIND of creature carries which abilities. An ability is no longer placed on one
    -- creature: it belongs to a group (who fights like that, which five levels) and every
    -- creature of that group can drop it. Two small tables say it -- CLDB.groupmembers and
    -- CLDB.groupof -- and the world's loot tables are generated from the same two.
    LoadLua("lua_scripts/ClassLess/data/groups.data")
    if not LoadLua("lua_scripts/ClassLess/data/tomes.data") then
        print("[ClassLess] no tome data -- abilities cannot be unlocked")
        return
    end

    -- Walk both spell trees to learn, for every rank, which line it belongs to and what level
    -- it needs. The pool is keyed by rank, but the migration and the BoP test talk in lines.
    --
    -- Entry shape is { {rank ids}, {levels}, "", signatureFlag }; the flag is per ENTRY, so
    -- it covers the whole chain, which is exactly how bonding is assigned in
    -- classless_rank_items.sql.
    local function indexTree(tree, isTalent)
        if tree == nil then return end
        for clsName, specs in pairs(tree) do
            for specOrder, spec in ipairs(specs) do
                local entries = spec[4]
                if type(entries) == "table" then
                    -- Spec block shape is { name, icon, tag, entries }; the first two are
                    -- what the panel's left column shows.
                    local page = { cls = clsName, kind = isTalent and "t" or "s",
                                   spec = spec[1] or "?", icon = spec[2] or "",
                                   ord = specOrder, lines = {} }
                    local treeKey = clsName .. "|" .. (spec[1] or "?")
                    for _, e in ipairs(entries) do
                        local ids, lvls = e[1], e[2]
                        if type(ids) == "table" and ids[1] then
                            ranksOfLine[ids[1]] = ids
                            treeOfLine[ids[1]] = treeKey
                            table.insert(page.lines, ids[1])
                            for i = 1, #ids do
                                lineOfSpell[ids[i]] = ids[1]
                                rankLevel[ids[i]] = (lvls and lvls[i]) or 1
                                if isTalent then isTalentLine[ids[i]] = true end
                            end
                        end
                    end
                    if #page.lines > 0 then
                        table.insert(catalog, page)
                    end
                end
            end
        end
    end
    if CLDB and CLDB.data then
        indexTree(CLDB.data.spells, false)
        indexTree(CLDB.data.talents, true)
    end
    for spellLine, talentLines in pairs((CLDB and CLDB.bind) or {}) do
        local kept = {}
        for _, talentLine in ipairs(talentLines) do
            -- bind.data is generated against Spell.dbc, which knows spells this module does
            -- not carry; anything without a rank chain here is dropped rather than offered.
            if ranksOfLine[talentLine] then
                kept[#kept + 1] = talentLine
            end
        end
        if #kept > 0 and ranksOfLine[spellLine] then
            bindOf[spellLine] = kept
        end
    end
    -- pairs() over the class tables hands back a different order on every run, so without
    -- this the panel's left column would be shuffled after each restart and a catalogue
    -- index handed to one client would mean something else to the next. Spells before
    -- talents within a class ("s" < "t"), and each spec in the order its data file lists it.
    table.sort(catalog, function(a, b)
        if a.cls ~= b.cls then return a.cls < b.cls end
        if a.kind ~= b.kind then return a.kind < b.kind end
        return a.ord < b.ord
    end)
    local n, starterTalents = 0, 0
    for rankId, t in pairs(CLDB.tomes or {}) do
        tomeOf[rankId] = t
        rankOfItem[t[1]] = rankId
        -- The generator has already applied the starter rule and marked those ranks "s" (no
        -- source, never drops). Trusting its answer rather than recomputing the same rule
        -- from t[6] keeps the two from drifting apart -- one of them being wrong is how a
        -- tome ends up dropping for something every character already owns.
        if t[2] == "s" then
            table.insert(starterPool, rankId)
            if isTalentLine[rankId] then
                starterTalents = starterTalents + 1
            end
        end
        n = n + 1
    end
    local rare = 0
    for _ in pairs(CLDB.rarebuffs or {}) do rare = rare + 1 end
    print("[ClassLess] loaded " .. n .. " tomes, indexed "
        .. (function() local c = 0 for _ in pairs(lineOfSpell) do c = c + 1 end return c end)()
        .. " ranks (" .. #starterPool .. " lines unlocked at creation of which "
        .. starterTalents .. " talents, "
        .. rare .. " rare buffs boss-only)")
end
LoadTomes()

-- Every creature entry that already carries at least one tome (kind "b"/"c" -- "q" points
-- srcEntry at a QUEST id, not a creature, and "s" has no source at all). Read off the
-- now-fully-loaded tomeOf rather than re-parsing tomes.data, so this can never drift from
-- what actually loaded. Used to keep bounty items (below) from dropping off a creature that
-- already gives players a reason to fight it.
-- What a given creature can drop, answered from the GROUP tables rather than from a list built
-- per creature. Under the per-row placement 2649 creatures carried a tome each and the index was
-- small; the group rule gives all 9150 killable creatures something, a dozen abilities apiece, so
-- writing it out would be 120000 entries held for the life of the process to answer a question
-- that is asked once per bounty kill. It is computed on demand instead.
local function TomesOfCreature(entry)
    local gs = CLDB.groupof and CLDB.groupof[entry]
    if gs == nil then
        return nil
    end
    local out = {}
    for i = 1, #gs do
        local members = CLDB.groupmembers and CLDB.groupmembers[gs[i]]
        if members then
            for j = 1, #members do
                local t = tomeOf[members[j]]
                if t then
                    out[#out + 1] = { t[1], members[j] }
                end
            end
        end
    end
    if #out == 0 then
        return nil
    end
    return out
end

-- creature entry -> {itemId, questId, "name", "place", level}, one per tome-carrying creature
-- (data/ClassLess/data/bounties.data, generated by scratchpad/bounty_quests.py from
-- tomes.data). Keyed by the TARGET creature's entry, because that's what a kill event hands
-- the kill hook when it's time to check for a completed bounty.
local bountyOf = {}
local function LoadBounties()
    if not LoadLua("lua_scripts/ClassLess/data/bounties.data") then
        print("[ClassLess] no bounty data -- bounty quests are disabled")
        return
    end
    local n = 0
    for entry, b in pairs(CLDB.bounties or {}) do
        bountyOf[entry] = b
        n = n + 1
    end
    print("[ClassLess] loaded " .. n .. " bounty quests")
end
LoadBounties()

-- Which named target a given ability can be hunted on.
--
-- The old answer was one lookup -- the tome named its creature, and the creature either had a
-- bounty or did not. Under the group rule an ability has hundreds of carriers and the bounties
-- are only on the named ones (the rares and the dungeon bosses), so the question is asked through
-- the group instead: which group is this rank in, and which bounty targets answer for that group.
--
-- Both tables are built once, here, because they are inversions of data that does not change:
-- groupmembers gives rank -> group, and groupof gives creature -> groups.
local groupOfRank = {}
local bountyByGroup = {}
for g, members in pairs(CLDB.groupmembers or {}) do
    for i = 1, #members do
        local list = groupOfRank[members[i]]
        if list == nil then
            list = {}
            groupOfRank[members[i]] = list
        end
        list[#list + 1] = g
    end
end
for entry in pairs(bountyOf) do
    local gs = (CLDB.groupof or {})[entry]
    if gs then
        for i = 1, #gs do
            local list = bountyByGroup[gs[i]]
            if list == nil then
                list = {}
                bountyByGroup[gs[i]] = list
            end
            list[#list + 1] = entry
        end
    end
end
-- Lowest level first, so the bounty offered for an ability is the earliest place it can be hunted
-- rather than whichever target pairs() happened to hand back first -- and so the answer is the
-- same on every restart.
for g, list in pairs(bountyByGroup) do
    table.sort(list, function(a, b)
        local ba, bb = bountyOf[a], bountyOf[b]
        if ba[5] ~= bb[5] then return ba[5] < bb[5] end
        return a < b
    end)
end

local function BountyForRank(rankId)
    local gs = groupOfRank[rankId]
    if gs == nil then
        return nil
    end
    for i = 1, #gs do
        local targets = bountyByGroup[gs[i]]
        if targets and targets[1] then
            return bountyOf[targets[1]]
        end
    end
    return nil
end

-- Candidates for the one random spell a brand new character is seeded with (see the "Seed on
-- first sight" block in LoadPlayerData). Any rank whose own required level is 1, excluding
-- talent lines -- talents have their own starter tier via STARTER_TALENT_LEVEL and are not
-- what "start with a spell" means here. Also excludes "buff"/"raid_buff" lines (Frost Armor,
-- Battle Shout, ...): those give a new character nothing to actually fight with, defeating
-- the point of the seed -- "one thing to press instead of an empty action bar" means an
-- active, usable ability.
--
-- Deliberately separate from starterPool/STARTER_LEVEL, which stay 0 so nothing else is
-- auto-granted: a classless character otherwise starts with a genuinely empty spellbook.
-- Roles a starter spell may not come from. The seed exists to put ONE thing on an empty action
-- bar that a brand new character can FIGHT with, so anything that cannot be aimed at the boar in
-- front of it defeats the whole point of the grant.
--
--   buff / raid_buff   Frost Armor, Battle Shout -- real abilities, but they leave the action bar
--                      as empty as it was for anything you actually have to kill.
--   heal / aoe_heal    the same objection, and worse: a level 1 character seeded with Lesser Heal
--                      has no way at all to damage anything, and no second grant is coming. Four
--                      of the seventeen candidates were heals (Healing Wave, Holy Light, Lesser
--                      Heal, Healing Touch), so roughly one new character in four started unable
--                      to fight.
--   control / utility  the same objection again, and it took a real character to notice: the two
--                      survivors of the first filter were Stealth and Track Beasts. A brand new
--                      Adventurer that draws Stealth has one button, it cannot be pointed at
--                      anything, and the seed has spent itself. Twelve candidates, two of them
--                      like this, so one new character in six.
--
-- What is left is ten: Heroic Strike, Raptor Strike, Eviscerate, Sinister Strike, Smite,
-- Lightning Bolt, Fireball, Shadow Bolt, Immolate, Wrath. Every one of them can be aimed at the
-- first thing the character meets, which is the entire point of the grant. Two of the ten are then
-- removed by name below and one buff is put back by name, leaving nine.
local STARTER_EXCLUDED_ROLES = {
    buff = true, raid_buff = true,
    heal = true, aoe_heal = true,
    control = true, utility = true,
}
-- And by NAME, for the ones a role cannot catch.
--
-- Eviscerate is tagged "damage" and is damage, but it spends COMBO POINTS -- so a character whose
-- one seeded ability is Eviscerate cannot press it at all until it has auto-attacked something
-- into giving it a point, with a weapon it was not given. It is the only draw in the list that
-- does not work on its own, and the seed exists precisely so that the first thing a new character
-- meets can be fought.
--
-- Immolate is the other one. It is aimable and it works on its own, so neither the role filter nor
-- the Eviscerate objection catches it, but it is the only draw whose damage arrives over time: a
-- cast, then fifteen seconds of ticks. Every other draw resolves the moment it lands. On a level 1
-- character with one ability and no second grant coming, that turns the first fight into a wait,
-- and a wait is what the seed exists to prevent.
--
-- Listed here rather than retagged in roles.data: that file feeds the FOCUS TAX as well, and its
-- own header says a retag moves the ability into another role's budget and changes what builds are
-- affordable. A starter rule has no business doing that.
local STARTER_EXCLUDED_LINES = {
    [2098] = true,   -- Eviscerate: needs a combo point, and a weapon to earn one with
    [348]  = true,   -- Immolate: damage over fifteen seconds, not on cast
}

-- And back IN by name, past the role filter, for the ones the role filter is wrong about.
--
-- Seal of Righteousness is tagged "buff" and the tag is correct -- it is cast on the character,
-- not at anything -- which is why the role filter threw it out with Frost Armor and Battle Shout.
-- The objection to those does not hold here: a seal does not leave the action bar empty for the
-- thing you have to kill, it makes every swing at that thing hit harder. Paired with the melee
-- weapon the seed hands over, a character that draws it can fight from the first minute, which is
-- the only test the seed cares about. Included at the user's request (2026-09-18).
--
-- This overrides STARTER_EXCLUDED_ROLES only. Level 1 and "not a talent line" still apply, and
-- STARTER_EXCLUDED_LINES still wins over this table.
local STARTER_INCLUDED_LINES = {
    [21084] = true,  -- Seal of Righteousness: tagged buff, but it arms the auto-attack
}
local level1Spells = {}
for rankId, lvl in pairs(rankLevel) do
    local role = CLDB.roles and CLDB.roles[rankId]
    local roleOk = STARTER_INCLUDED_LINES[rankId] or not STARTER_EXCLUDED_ROLES[role or ""]
    if lvl == 1 and not isTalentLine[rankId] and roleOk
        and not STARTER_EXCLUDED_LINES[rankId] then
        table.insert(level1Spells, rankId)
    end
end
print("[ClassLess] " .. #level1Spells .. " level-1 spells eligible for the random starter grant")

-- EVERY draw now names a weapon type, and the pairing is chosen to fit the ability rather than
-- merely to satisfy it (2026-09-18, the user's call). Two different reasons to be in this table:
--
--   The melee draws would be DEAD without one. A brand new character owns no weapon at all, and
--   Heroic Strike or Sinister Strike with an empty main hand is a button that cannot be pressed.
--   These were already here; what changed is which type each one asks for, so the weapon looks
--   like the ability it came with instead of every melee character opening with the same sword.
--
--   The caster draws do not NEED one -- Fireball does not care what is in hand -- but a character
--   that draws one used to start with nothing to hold, and its auto-attack, which is most of what
--   it does between casts at level 1, had to be thrown with bare fists. A staff costs the design
--   nothing and fixes both.
--
-- Curated by hand against the skill ids/names in proficiencies.data; only needs to name ONE
-- acceptable type; the seed block below grants it alongside the spell.
local level1WeaponReq = {
    -- Melee draws
    [78] = 172,    -- Heroic Strike: two-handed
    [1752] = 173,  -- Sinister Strike: dagger
    [2973] = 43,   -- Raptor Strike: one-handed
    [21084] = 54,  -- Seal of Righteousness: one-handed, and a mace for the paladin it came from
    -- Caster draws: a staff to hold and auto-attack with between casts
    [133] = 136,   -- Fireball
    [403] = 136,   -- Lightning Bolt
    [585] = 136,   -- Smite
    [686] = 136,   -- Shadow Bolt
    [5176] = 136,  -- Wrath
    -- Eviscerate asked for Swords here. It is in STARTER_EXCLUDED_LINES now and can never be
    -- drawn, so its row would never be read; kept out rather than kept dead.
    -- Auto Shot was here too, needing Bows. It is baseline now (BASE_ABILITIES) and out of the
    -- collection, so it can never be the seeded spell and has nothing to ask for.
}

-- Permission to equip a weapon type doesn't put one in hand -- the collectible weapons
-- themselves are earned separately, same as the proficiencies. Hand over one actual item of
-- the granted type too, so the seeded ability has something to swing/shoot on arrival rather
-- than waiting on a drop. Both are unrestricted (AllowableClass/Race = -1) and equippable at
-- level 1.
-- All verified against item_template: AllowableClass and AllowableRace both -1, RequiredLevel 1,
-- ItemLevel 2 -- the starter grade, so the handout arms the seed without arming it well.
local weaponItemOfSkill = {
    [43] = 25,     -- Swords: Worn Shortsword
    [54] = 36,     -- Maces: Worn Mace
    [136] = 35,    -- Staves: Bent Staff
    [172] = 12282, -- Two-Handed Axes: Worn Battleaxe (no two-handed SWORD exists at this grade --
                   -- the cheapest is Tarnished Bastard Sword at ItemLevel 3)
    [173] = 2092,  -- Daggers: Worn Dagger
    [45] = 5346,   -- Bows: Orcish Battle Bow. Unreachable since Auto Shot went baseline; kept
                   -- because the entry costs nothing and the mapping is still true.
}

-- guid -> skill id, set by the seed block in LoadPlayerData (no player object there to check
-- HasSkill against or to hand the item to) and consumed once by OnLogin right after.
local pendingWeaponReq = {}

-- =====================================================================================
-- Weapon and armour proficiencies
--
-- EVERY character has all of them, from level one (2026-09-11, the user's call). They are the
-- FLOOR of the game rather than a reward in it: with no armour proficiency a character cannot
-- equip anything at all, and asking a level 5 character to find a manual before it may hold a
-- mace was gating the game on its own prerequisite. The 21 collectible manuals, their 183 loot
-- rows and profspread.py are retired with this -- see data/sql/custom for the removal.
--
-- Two facts drive the implementation, both learned from mod-learn-spells, and both are why this
-- is not simply a row in playercreateinfo_spell_custom:
--
--   1. Proficiency is NOT persisted. Player::m_WeaponProficiency / m_ArmorProficiency are
--      written only by Spell::EffectProficiency, which runs on spell HIT. Knowing the spell
--      does nothing -- it has to be genuinely CAST, every session.
--   2. Player::_LoadSkills deletes any skill failing GetSkillRaceClassInfo() for the
--      character's race/class, unconditionally. On a classless server that strips Mail and
--      Plate from most classes on the way in.
--
-- Between them: re-apply the whole set on every login. There is no "grant once", and there is
-- nothing per-character left to store.
-- =====================================================================================
local profOf = {}                 -- skillId -> { itemId, spellId, name, kind, entry, srcName, place, level }
-- guid -> { [instanceId] = bounty letters granted inside that instance }. Declared up here
-- because OnDelete clears it, and a local only exists for code that comes after it.
--
-- One counter PER instance id rather than a single current-instance slot: with a single slot,
-- stepping into a second dungeon (or back out and into another group's instance) dropped the
-- first one's count, so alternating between two instances handed out letters without limit.
-- The player keeps a count for every instance they have entered this session.
--
-- A reset does produce a fresh instance id and therefore a fresh allowance. That is on
-- purpose: a reset instance has to be cleared again from the door, which is the time cost the
-- cap is really pricing.
local bountyPerInstance = {}

local function LoadProfs()
    if not LoadLua("lua_scripts/ClassLess/data/proficiencies.data") then
        print("[ClassLess] no proficiency data -- weapon/armour unlocks are disabled")
        return
    end
    local n = 0
    for skillId, p in pairs((CLDB or {}).profs or {}) do
        profOf[skillId] = p
        n = n + 1
    end
    print("[ClassLess] loaded " .. n .. " proficiencies, granted to every character")
end
LoadProfs()

-- Eluna's Player:SetSkill PERMUTES its arguments before calling the core. It reads
-- (id, step, currVal, maxVal) from Lua and then calls the core's
-- SetSkill(id, step, currVal, maxVal) as SetSkill(id, currVal, maxVal, step) -- so the Lua
-- "currVal" lands in step, "maxVal" lands in currVal and "step" lands in maxVal. Wrapped once
-- here using the CORE's parameter names, because a bare player:SetSkill(id, 5, 5, 1) at a
-- call site reads like a mistake.
local function SetSkillCore(player, id, step, currVal, maxVal)
    player:SetSkill(id, maxVal, step, currVal)
end

-- Apply the whole set. Safe to call on every login and cheap: 21 skills, and each of the three
-- calls below is a no-op when the character already has it from the last time round.
--
-- The skill itself is opened at 1 with a ceiling of 75 rather than mod-learn-spells' 1/5. Weapon
-- skill stopped being a real stat in WotLK -- nothing reads the number -- so the range is the
-- honest shape of the thing (a skill you start at the bottom of) rather than a number that
-- matters. Step stays 1: a step of 5 with a cap of 75 draws a bar in fifteenths.
local PROF_SKILL_START, PROF_SKILL_MAX = 1, 75

local function ApplyProficiencies(player)
    for skillId, p in pairs(profOf) do
        if not player:HasSkill(skillId) then
            SetSkillCore(player, skillId, 1, PROF_SKILL_START, PROF_SKILL_MAX)
        end
        if not player:HasSpell(p[2]) then
            player:LearnSpell(p[2])
        end
        -- The cast is the part that actually sets the proficiency mask. Triggered so it is
        -- instant, free and cannot be interrupted on a loading screen.
        player:CastSpell(player, p[2], true)
    end
end

-- What a weapon DOES when you swing, shoot or fire it. Floor, not content -- the same argument as
-- the proficiencies above, and the same fix, because permission to hold a bow is not the ability
-- to use one.
--
-- The realm treated the four differently and nobody had noticed, because until 2026-09-11 you
-- could not hold the weapon either:
--
--     6603  Attack      melee     87 of 87 race/class rows at creation   (everyone)
--     5019  Shoot       wand      29 of 87                                (casters only)
--       75  Auto Shot   ranged     0 of 87, AND a collectible tome        (nobody)
--     2764  Throw       thrown    10 of 87                                (a few)
--
-- So on the day every character got all 21 proficiencies, everyone could equip a bow, a wand and
-- a thrown weapon, and two of the three did nothing at all -- with the third gated behind finding
-- one specific book, which no melee weapon has ever been.
--
-- Granted here rather than in playercreateinfo_spell_custom on purpose: this reaches characters
-- that already exist as well as new ones, and it is four ids instead of an 87-row race/class
-- matrix to keep in step. Unlike a proficiency these do persist once learned, so the HasSpell
-- test means this costs nothing after the first login.
--
-- Auto Shot is out of the collection as of the same day (tools/classless-web/basecut.py). A rank
-- that is granted AND droppable is a wasted drop -- the generator's own rule, stated at
-- STARTER_LEVEL.
local BASE_ABILITIES = {
    6603,   -- Attack, melee auto-attack
    5019,   -- Shoot, wand auto-attack
    75,     -- Auto Shot, ranged auto-attack
    2764,   -- Throw, thrown auto-attack
}

local function GrantBaseAbilities(player)
    for i = 1, #BASE_ABILITIES do
        if not player:HasSpell(BASE_ABILITIES[i]) then
            player:LearnSpell(BASE_ABILITIES[i])
        end
    end
end

-- Bump to re-seed proficiencies.
--
-- Characters that predate proficiency collecting are already WEARING gear that depends on
-- proficiencies mod-learn-spells used to hand out for free. Taking those away would grey out
-- their equipped items, so every existing character is seeded with the full set and only new
-- characters have to earn them.
-- Stamped on every row this file creates, and read by nothing. Both migrations they existed
-- for -- a LINE-keyed pool from before acquisition was per rank, and the free proficiency set
-- for characters that predate proficiencies being found -- were deleted once the live table had
-- no row left at either version. They stay because they are the mechanism for the next format
-- change: bump the constant, and the load path can tell an old row from a new one.
local PROF_VER = 1
local POOL_VER = 1

-- ---------------------------------------------------------------------------------------
-- PRACTICE: ranks past the first are earned by fighting with the tree they belong to.
--
-- The problem this answers is arithmetic. One tome per rank means 3963 unique placements, and
-- the world only offers about 1452 creatures that may legally carry one -- so most ranks can
-- never get a carrier of their own, and the ones that do are scattered: Sword Specialization
-- ranks 1-5 sit in Duskwood, Duskwood, Arathi, Stranglethorn and Swamp of Sorrows, all to be
-- collected between level 30 and 34.
--
-- So only the FIRST rank of a line is found in the world -- that is the discovery, and it stays
-- a hunt -- and the rest are earned by using that line's tree. Fight with Frost and your Frost
-- talents advance. It is the classic weapon-skill loop, and in a classless game it is also the
-- build: you get better at what you actually do.
--
-- Progress is measured in PRESSES, held against the enemy they were aimed at and paid out
-- when that enemy dies. A rare that took forty casts to bring down pays for forty; a trash mob
-- that took three pays for three. Nothing is capped, because nothing needs to be: a press
-- aimed at something that never dies is never cashed.
--
-- This is the ONLY route to any rank past the first -- the world carries the discovery and
-- nothing else (tools/classless-web/rank1cut.py cut tomes.data to 1412 rows to make that
-- true). With the flag down a character can never learn a second rank of anything, so it is
-- not a switch to flip idly.
local PRACTICE = true
-- What a FIGHT'S WORTH of an ability is worth. ONE number, and it is the same for every rank of
-- every line -- the sixteenth rank of Fireball costs exactly what its second did.
--
-- The chance is NOT what spreads a line across a career: every rank carries its own required
-- level and no amount of practice reaches one early. All it decides is how many fights after
-- becoming eligible a rank takes to arrive.
--
-- Divided by the ability's expected presses (practice.data) to get the chance of ONE press, so
-- the figure quoted anywhere in the UI is in PRESSES and differs per ability -- about 267 of
-- Frostbolt against 45 of Corruption, which is the same amount of fighting either way.
--
-- PRACTICE_DECAY IS GONE (2026-09-07, the user's call), and the reasoning is worth keeping
-- because it will be re-asked. It multiplied the chance by 0.75 for every rank of the line
-- already held, so a deep chain got dearer as it went: Fireball's second rank was ~99 presses
-- and its sixteenth ~7,400, and nearly the whole 9-10 hours of that chain sat in its last three
-- ranks. The intent was "generous first advance, the tail is earned".
--
-- What killed it was not the shape but WHERE the price landed. An advance buys the line's own
-- next rank OR one of the talents bound to it, and the roll is priced by the line you PRESSED --
-- so the same talent rank cost 8 presses off a one-rank line (299 of those have talents bound,
-- and a one-rank line never decays) against 7,421 off a maxed Fireball. A 928:1 gradient, and
-- what it taught a player was: do not press your main, press something cheap. Exactly backwards.
--
-- Flat pricing removes the gradient outright rather than patching it -- there is nothing left to
-- arbitrage when every advance everywhere costs the same. The bill for that is the tail: without
-- a decay one number has to serve the first rank and the last, so 0.121 was cut to 0.045 to keep
-- the whole collection near where it was. Measured, at a five-ability rotation:
--
--                        every rank    Fireball 1-16    whole collection
--     was  0.121 + 0.75    99 / 7421       9.5 h              62 h
--     now  0.045 flat        267           1.7 h              48 h
--
-- So a deep chain is much cheaper than it was and an early rank is dearer -- that IS the trade,
-- and it was made knowingly. The level requirements still do the spreading.
local PRACTICE_CHANCE = 0.045
-- A rank is a hundred per cent, and the per cent is the step the reader sees.
--
-- The chance above is the chance of a RANK, and a rank is about twenty-two fights: a number that
-- large can only ever be felt as a surprise, because nothing between the last rank and the next
-- one is observable. So a rank is broken into a hundred parts and the reader is told when the
-- number moves. It runs 0 to 100 and starts over at every rank -- the user's call, and the right
-- one: "your skill in Fireball has increased to 340" was the first shape, and a running total
-- has no unit, no destination the reader can name, and a different meaning on a two-rank talent
-- than on sixteen ranks of Frostbolt.
local PRACTICE_STEPS = 100
-- How much dearer the LAST per cent of a rank is than the first.
--
-- FLAT since 2026-09-19. It was 5 for the reason below, and the reason did not survive contact:
--
--   "Flat would be the obvious thing and it is the wrong one: the first few per cent of a rank
--   are what tells a reader the mechanic exists at all, and they should arrive while they are
--   still looking. The last few are the ones worth having. Five to one is steep enough to feel
--   the rank tightening and shallow enough that its second half is not a wait."
--
-- What it actually felt like, reported by the user: "a practice % minel kozelebb van a 100%-hoz
-- annal lassabban gyulik". Which is exactly what a 5:1 weighting does -- the last ten per cent
-- cost 4.08x the first ten, and 50% shown was only 33% of the work done. The second half WAS the
-- wait, and a bar that decelerates as it approaches its goal reads as broken rather than as
-- tightening.
--
-- Free to change, and this is worth being precise about because it looks like a balance number
-- and is not one. A press earns CastChance * RANK_STORED / RANK_COST units and a rank is
-- RANK_STORED units, so presses per rank is RANK_COST / CastChance -- the curve cancels out
-- entirely. Flattening moves where the bar sits during a rank and changes nothing about how long
-- the rank takes.
--
-- It also makes the client honest: PracticePredictPress draws (100 - shown) / presses-left per
-- press, which assumes an even scale. Against a 5:1 server curve that model was wrong by
-- construction; against a flat one it is right.
--
-- WHAT THIS NUMBER STILL DOES, now that the bar is flat: it sets the internal unit scale and
-- nothing else. PRACTICE_RANK_UNITS is 300 at 5, and every stored figure, every test constant and
-- the 30000 hundredths a rank is worth are stated against that. Lowering it would rescale all of
-- them for no gain, so it stays where it is and SkillPercent stops reading it. If the curve is
-- ever wanted back, that is one line in SkillPercent, not here.
local PRACTICE_END_COST = 5
-- The weight of the p-th per cent is 1 + (END_COST - 1) * (p - 1) / (STEPS - 1), so the cost of
-- reaching p is the sum of that: U(p) = A*p^2 + (1-A)*p, with A below. A rank is U(STEPS).
local PRACTICE_CURVE = (PRACTICE_END_COST - 1) / (2 * (PRACTICE_STEPS - 1))
local PRACTICE_RANK_UNITS = PRACTICE_CURVE * PRACTICE_STEPS * PRACTICE_STEPS
    + (1 - PRACTICE_CURVE) * PRACTICE_STEPS
-- Units are stored in hundredths, because the trees column holds digits and nothing else, and a
-- press of a rarely-cast ability is worth a fraction of a unit.
local PRACTICE_UNIT_SCALE = 100
local PRACTICE_RANK_STORED = PRACTICE_RANK_UNITS * PRACTICE_UNIT_SCALE
-- What a rank costs, against the twenty-two fights PRACTICE_CHANCE alone would charge for one.
--
-- Half, on the user's call of 2026-09-16: "induljunk a felevel, tehat 150 egyseg legyen 1 rank".
-- A rank was worth PRACTICE_RANK_UNITS of practice and a press was worth its share of that; the
-- press keeps its value and the rank is now bought with 150 units of it, so everything about the
-- mechanic doubles in speed -- about eleven fights a rank instead of twenty-two, 134 presses of
-- Frostbolt instead of 267.
--
-- The one number to turn if that is too fast or too slow. Nothing else in the file assumes it:
-- the curve, the share cap, the rotation bonus and the instance bonus are all shapes, and this
-- is the only thing that says how much fighting the shape is worth. The measured claims in
-- test_practice_scenarios.py are stated against it and move with it.
local PRACTICE_RANK_COST = 0.5
-- How many casts a fight is assumed to contain for an ability practice.data has no number for
-- -- one the DBC does not know, or a passive that is normally earned through the spell it
-- modifies rather than by being pressed.
local PRACTICE_CASTS = 4
-- A fight's press budget: how many presses one second of it is worth. Everything above the
-- budget is discarded, so hammering a macro earns what pressing once a second earns -- and a
-- long fight legitimately earns more, which is the point of measuring the length at all.
-- Measured with the core's millisecond clock (GetCurrTime / GetTimeDiff, which is getMSTime
-- and handles its 49-day wrap), not with os.time. A one-second clock cannot tell a three-second
-- fight from a one-second one, and short fights are most of them -- at that resolution the
-- measurement error, not the play, would decide what a pull was worth.
local PRACTICE_PRESSES_PER_SEC = 1
-- The most of a fight's budget any ONE ability may claim.
--
-- This is the rule that makes a rotation the right way to play. Spamming one button used to be
-- the FASTEST way to max that button -- a fight is only so long, so twenty Fireballs beat eight
-- Fireballs and twelve of something else -- and it worked out at 10 hours of one-button play
-- for a maxed Fireball against 14 of a real rotation. Under the cap both earn Fireball the
-- same, and the rotation banked three other lines while doing it.
--
-- Deliberately a cap and not a bonus for breadth. A bonus punishes a character that owns two
-- abilities and cannot do anything about it; a cap takes nothing from anyone, it only stops one
-- button from filling a whole fight. And it cannot be gamed by weaving a token press, because
-- it does not measure breadth at all: forty Fireballs and one Scorch is worth forty Fireballs.
--
-- 0.4 asks for about three abilities to use a fight up. 0.25 would ask for four, 0.2 for five.
local PRACTICE_SHARE_CAP = 0.40
-- A fight this short is exempt from the budget and the cap both. A creature that dies in two
-- presses is not bad play, and reading it as one-button spam would make ordinary levelling
-- worse for no reason.
local PRACTICE_SHORT_FIGHT = 3
-- What a WIDE rotation is worth, on top of everything else: this much per extra ability in the
-- fight, to a ceiling.
--
-- +25% each, doubling at five. The share cap alone left spam and a real rotation earning your
-- main spell exactly the same -- spam was pointless but not worse, and playing more of your kit
-- was not actually better for the thing you were chasing. This is what makes it better, and it
-- is the reward for the one thing a classless character can do that no single class could: a
-- classic mage had a one-button rotation because that was all it had.
--
-- A bonus and NEVER a penalty. One ability is x1.00, so a level 8 character with two spells to
-- its name loses nothing for having two spells. That is exactly what sank the first version of
-- this idea, which scored breadth INSTEAD of capping the share: it priced that character worst,
-- and spam still won anyway because twenty presses at 0.75x beat eight at 1.5x. With the cap
-- doing the anti-spam work there is no press advantage left for this to have to out-fight, so
-- it can be pure reward.
--
-- Measured in EFFECTIVE abilities, not distinct ones -- see CreditPractice. A token press is
-- worth a token amount.
local PRACTICE_ROTATION_STEP = 0.25
-- 2.5 rather than 2.0 because 2.0 BOUND: an eight-ability rotation reaches 5.14 effective and
-- landed exactly on it, so the player the bonus was written for -- the one whose kit is not one
-- button -- was told their extra three abilities were worth nothing. Reaching 2.5 would want a
-- dead-even seven-way split, so in real play the step decides throughout and this is only a
-- guard against something pathological.
local PRACTICE_ROTATION_MAX = 2.5
-- What a fight inside a dungeon or a raid is worth on top: 15% more per press.
--
-- This has moved three times and the reasoning matters more than the number. It was x1.4, then
-- removed entirely on the argument that what makes an instance worth more is that its fights are
-- longer and its rotations wider -- and the budget and the share cap already pay for both, so a
-- flat multiplier rewarded the flag rather than the fighting.
--
-- Removing it turned out to leave instances nearly LEVEL with open-world play: measured over a
-- whole sixteen-rank chain, boss fighting came out 12% ahead, or about one evening in ten. So a
-- small bonus is back, at a value that says something a tooltip could carry -- a fight in here
-- is worth 15% more -- rather than at a value tuned to hit a career-level target, which the
-- measurement cannot resolve anyway (a 40-career mean of a right-skewed distribution carries
-- about +/-8%, so 12% and 15% are the same reading).
--
-- Bosses still get nothing of their own. A boss fight is long and forces a wide rotation, so it
-- already wins twice over before this applies.
--
-- 2026-09-14: groups.py's DUNGEON_BONUS moved to 2.0 and this did NOT follow, on purpose. That
-- one pays for organising a five-man run, because the tome it governs was being split five ways
-- by group loot until ITEM_FLAG_MULTI_DROP. Practice is never split -- a player earns from their
-- own presses -- and the two sentences above are the reason a flat multiplier here has to stay
-- small: the instance advantage is already in the press budget and the rotation bonus.
local PRACTICE_INSTANCE_BONUS = 1.15
-- How long a press keeps counting, in milliseconds -- measured from the last press at the same
-- target, so any longer gap starts a fresh fight.
--
-- Three minutes, because 45 seconds cut real boss fights in half. A scenario earned NOTHING from
-- twenty ten-minute raid bosses, and while the immediate cause was the scenario pressing too
-- sparsely, the rule it tripped is real: Thaddius's polarity shifts, Sartharion's adds, the Four
-- Horsemen rotation, a kiting phase, a burn phase spent running -- 45 seconds without pressing
-- the ability being practised is an ordinary minute of raiding, and everything before the gap
-- was discarded.
--
-- Safe to raise only because a press is held against the TARGET it was aimed at. This used to be
-- the one thing stopping a press from two pulls ago paying for a kill now; a press can only ever
-- pay for that creature's death today, so all the window still does is bound the tally table and
-- stop somebody pressing at a creature, leaving, and coming back tomorrow to collect.
--
-- The shared bucket (heals, self-buffs) is bounded by the BUDGET instead: 100 presses across
-- three minutes credit 72, which is 0.4 a second -- exactly what an ordinary twenty-second fight
-- pays, at a worse rotation bonus.
local PRACTICE_WINDOW = 180000
-- QUESTING TEACHES NOTHING (2026-09-11, the user's call: "reset everything related to getting a
-- spell from quests"). Both halves of the quest route are gone and neither should come back
-- without the whole argument being re-made:
--
--   * The 39 tome rows of kind "q" -- a quest handing over a book on completion. Those 39 ranks
--     were re-sourced onto creatures by the picker rather than deleted, because each was the
--     only source its line had.
--   * The STUDY TOKEN, one per 35 completed one-time quests, spendable on the first rank of any
--     line the world had not dropped. It was the anti-RNG route, and its real load-bearing job
--     had quietly become something else: it was the ONLY way into 621 of the 622 talent lines,
--     because PracticeOptions still demanded a talent line be owned before it would offer one.
--     That gate is fixed above, so practice now reaches every talent, and the token is not
--     holding anything up any more.
--
-- What replaces it as the brake on bad luck: nothing, deliberately. Every line's rank 1 is in
-- the world, every rank above it is practice, and the variance is the system (the user's
-- standing position -- "not everybody will be lucky on the same spell").

-- guid -> { [lineId] = experience earned casting it } and { ["CLASS|Spec"] = ... } for the
-- talents no single spell improves, plus when each line was last cast.
-- guid -> { [lineId] = advances earned and not yet spent }. Almost always nought or one: an
-- advance that has only one thing to buy is spent the moment it lands, and one with a choice
-- waits for an answer.
local lineUp = {}
-- Presses, and what they were aimed at.
--
-- guid -> { [creatureGuidLow] = { first = when it started, at = when it was last touched,
-- [lineId] = presses } }. Everything aimed at an
-- enemy is held under THAT enemy and cashed only when it dies. Two things fall out of it. A
-- long fight pays more than a short one, because a rare takes more presses to bring down and
-- every one of them counts -- which is the whole reason the count is not capped. And presses
-- aimed at a training dummy, or at anything else that never dies, are never cashed at all: a
-- hundred casts at a dummy followed by killing one critter used to be worth 63% where the
-- fight itself was worth 11%.
local lineAt = {}
-- The same shape for everything with no enemy to attach to: a heal, a self-buff, a spell cast
-- at nothing. One window per player rather than one per target, because there is no target to
-- key it by; any credited kill inside the window cashes it.
--
-- These used to be capped at the ability's own expected press count, which meant a healer in a
-- five-minute boss fight earned roughly what one trash pull was worth. They share the fight's
-- budget and the same 40% cap now, which is what makes a healer work in the content this whole
-- mechanic is pointed at. The window's own length is what bounds it, so spam-healing a wall
-- still buys nothing -- nothing dies.
local lineHit = {}
-- guid -> what a fight has lately been worth to this reader, as a multiple of the bare
-- one-ability open-world chance. 1.0 is someone pressing a single button outside an instance; a
-- five-ability rotation in a dungeon is about 2.4.
--
-- Kept for the PANEL, not for the payout. The panel quotes a distance in presses, and that
-- figure knew about none of the share cap, the rotation bonus or the instance bonus -- so the
-- one piece of feedback the mechanic gives about itself told a rotating dungeon runner a number
-- 2.4 times too long. Dividing by this quotes it against how the reader actually plays, which
-- is honest and teaches the mechanic without a word of explanation: press more of your kit and
-- every number on the panel falls.
--
-- An exponential mean rather than a window, because it is one number instead of a list of the
-- last twenty fights, and it is only ever read to draw a "~" figure. It starts at 1.0, so a
-- character that has not fought yet is quoted the honest floor rather than a guess.
local practiceRate = {}
-- guid -> lineId -> practice units earned on that line, in hundredths, counted from the first
-- press and never reset. The percentage the reader sees is this modulo one rank's worth, run
-- back through the curve -- a division done at the moment of display, so the count itself stays
-- an exact integer and a line cannot drift off its own rank boundary by a rounding error.
local lineUnits = {}
local PRACTICE_RATE_ALPHA = 0.05      -- roughly the last twenty fights
-- An earned rank waiting to be spent: guid -> { [lineId] = {cost, rank, talent ranks...} }.
local pending = {}
-- Set by EnsureSchema. Practice is inert without the column, but a login must still work.
local HAS_TREES = false
-- Progress is written on a purchase and on logout, not on every kill: the column would
-- otherwise be rewritten several times a minute for every player online.
local treeDirty = {}
-- Forward declaration. The practice pots are written by TreeFlush, which is defined down in
-- the practice section -- but the measurement timer above it flushes them once a minute, and
-- without this that call resolves to a nil global.
local TreeFlush

-- Whose game this is.
--
-- ClassLess lives on class 10 since 2026-09-16, and nothing it does reaches anyone else: a Druid
-- is a Druid again, learns what a Druid learns, and has no collection, no practice and no tome to
-- read. Before the class existed the system had no way to say that and applied to the whole
-- realm, which is how a plain Druid ended up holding all 21 proficiencies and a random ability.
--
-- Written as one predicate and spent everywhere the file already asked "is this a character we
-- act for" -- which was a bot test, because a bot was the only thing it had to exclude. Every one
-- of those call sites wanted this question and could not ask it yet.
local CLASSLESS_CLASS = 10
-- Which copy of this file the realm is actually running, reported by /tomes barsdebug.
--
-- Worth the line: the same question -- "did the server pick up the edit, or am I looking at the
-- state from before the last reload?" -- has cost hours in this file, and an error quoting a line
-- number from a version that no longer exists reads exactly like a live bug. The client half has
-- carried PRACTICE_BARS_BUILD for the same reason.
local SERVER_BUILD = "2026-09-17g offer carries the locked talents too"

local function Ours(player)
    return player ~= nil and not player:IsBot() and player:GetClass() == CLASSLESS_CLASS
end

-- Bots are outside this, as they are outside every other ClassLess system.
local function Practising(player)
    return PRACTICE and Ours(player)
end

-- How many casts of this ability a fight is expected to contain, from practice.data.
--
-- Capped at ONE for a line that ranks up on level. You cast a shout, an aspect or a blessing once
-- and then live with it, so one a fight is already generous -- and practice.data does not merely
-- fail to say that, it says the opposite: it hands the three Warrior stances and the Hunter
-- aspects a count of TWELVE, the spam-nuke band, because the number was derived for abilities in
-- a rotation and these were never in one.
--
-- It matters more now than it did, because for these lines the count has exactly ONE job left.
-- Their own ranks come from the level (GrantAutoRanks), so the only thing the price still buys is
-- the TALENTS bound to them -- and 35 talents have no other route. At 12 casts, Improved Aspect
-- of the Hawk, Improved Aspect of the Monkey and Aspect Mastery each asked 267 presses of an
-- ability pressed once a session: a route that exists on paper and nobody could ever walk. At 1
-- they cost 22, which is the median for every other talent in the game.
--
-- A cap and not a rewrite of practice.data: the file is generated from Spell.dbc and this is a
-- statement about how the ability is PLAYED, which the DBC does not know.
-- How many presses of this ability a nominal fight holds, at the rank the character owns.
--
-- The rank OWNED, not the line. practice.data is keyed by rank because a nuke's cast time grows
-- with it -- Fireball is 1.5 seconds at rank 1 and 3.5 at rank 16 -- and reading rank 1's figure
-- for a whole career priced every cast as though it were the cheap one. Measured across the
-- chains: Fireball 2.40x out, Frostbolt 2.00x, Shadow Bolt 1.83x, Lightning Bolt and Smite 1.50x,
-- Wrath 1.20x, every instant 1.00x -- they sit on the global cooldown at every rank and nothing
-- about them changes.
--
-- The highest owned rank rather than the newest, because the pool is not ordered and a character
-- can hold a rank above one it is missing. Falls back to the line's own entry -- which is its rank
-- 1 -- and then to PRACTICE_CASTS, so an incomplete practice.data still prices everything.
local function LineCasts(guid, lineId)
    local tbl = CLDB.casts or {}
    local n
    local owned = poolSet[guid]
    if owned then
        local chain = ranksOfLine[lineId]
        if chain then
            for i = #chain, 1, -1 do
                if owned[chain[i]] and tbl[chain[i]] then
                    n = tbl[chain[i]]
                    break
                end
            end
        end
    end
    n = n or tbl[lineId] or PRACTICE_CASTS
    if ((CLDB and CLDB.autorank) or {})[lineId] and n > 1 then
        return 1
    end
    return n
end

-- The chance ONE cast of a line advances it.
--
-- Divided by the expected casts, which is what makes a Corruption and a Heroic Strike worth the
-- same per FIGHT instead of the same per press.
--
-- Nothing else goes into it. It used to take how much of the line was already held and decay by
-- it; that is gone (see PRACTICE_CHANCE), so an ability's advance costs the same on its
-- sixteenth rank as on its second, and the same whichever line an advance is eventually spent
-- on. No `owned` parameter, deliberately: with one there, a call site could quietly start
-- pricing by depth again.
-- The chance one press earns anything, and it is proportional to what that press COST you.
--
-- LineCasts is FIGHT / step -- how many of this ability a nominal twenty seconds holds -- so
-- dividing by it gives, exactly:
--
--     chance = (PRACTICE_CHANCE / 20) x seconds the press occupies you
--
-- which is the rule this is meant to follow and always was. What went wrong was never the formula;
-- it was two distortions feeding it. The figure was measured on rank 1, where a nuke still casts
-- in 1.5 seconds; and practicegen capped it at twelve presses a fight, which priced everything
-- quicker than 1.67 seconds identically -- a 1.0-second Sinister Strike, a global-cooldown instant
-- and a rank-1 Fireball all at the same chance per press. Both are gone: the rank in hand is read,
-- and the cap is lifted.
--
-- So an instant is now the SLOWEST thing per press, which is what it should be -- pressing it cost
-- you nothing you could have spent elsewhere. A 3.5-second Fireball earns 2.3x what a
-- global-cooldown press earns, because it took 2.3x as long.
--
-- Per FIGHT the two end up close, and that falls out rather than being arranged: the instant gets
-- more presses at a smaller chance each. PRACTICE_CHANCE is unchanged at 0.045 for the same
-- reason -- it is the per-fight figure, and the per-fight figure has not moved.
local function CastChance(guid, lineId)
    local c = PRACTICE_CHANCE / LineCasts(guid, lineId)
    return (c > 1) and 1 or c
end

-- What one cast of a line is worth, in stored units.
--
-- A rank is PRACTICE_RANK_UNITS and the old roll charged 1/CastChance presses for one, so this
-- is that per-press value spread over the rank, divided by what a rank now costs. At
-- PRACTICE_RANK_COST = 1 it is exactly the old pricing to the press; at 0.5 every ability earns
-- twice as fast and keeps its price relative to every other, which is what the share cap, the
-- rotation bonus and the drop bands are all stated in terms of.
--
-- There is no roll here any more. The old mechanic rolled once a press for a whole rank, so it
-- had to be a lottery; a press worth a hundredth of a per cent can simply be paid. What is left
-- of chance is the fraction of a stored unit a press does not cover, which RollPresses settles so
-- the expected value is exact rather than rounded down on every press of a career.
local function CastUnits(guid, lineId)
    return CastChance(guid, lineId) * PRACTICE_RANK_STORED / PRACTICE_RANK_COST
end

-- The same thing the other way round, for the panel: how many PRESSES of this ability a whole
-- rank of it costs. Per ability, so it differs -- about 134 presses of Frostbolt against 22 of
-- Corruption, which is the same amount of fighting either way. The same for every rank of that
-- ability, which is the point of flat pricing and is worth seeing on the panel.
--
-- Priced THROUGH CastUnits rather than off the chance directly. It used to read
-- `1 / CastChance`, which was the same number until a rank stopped costing exactly one roll --
-- and then quoted every distance in the game at twice the truth, silently, because nothing
-- compares the two. One expression of what a press is worth, and everything that quotes a
-- distance divides by it.
--
-- And per READER, divided by what a fight has lately been worth to them (practiceRate). The
-- bare rate is what one ability pressed alone outside an instance earns; anyone playing a
-- rotation, or playing it in a dungeon, earns two or three times that and was being quoted the
-- floor. A figure that is 2.4x too long is worse than no figure.
local function RankCasts(guid, lineId)
    return math.ceil(PRACTICE_RANK_STORED / (CastUnits(guid, lineId) * (practiceRate[guid] or 1)))
end

-- What is LEFT of the rank being worked on, in presses.
--
-- The honest answer to "how far to the next one", and it could not be asked before: practice
-- kept no position inside a rank, so the panel had to quote the whole rank however close the
-- reader stood to finishing it. A number that never moved while they played is the one thing
-- worse than no number.
-- How far into the CURRENT rank a stored unit count stands, as a percentage.
--
-- The inverse of U(p) = A*p^2 + (1-A)*p, which is a quadratic and so has a closed form: there is
-- no loop over a hundred steps on a path that runs for every button press on the server. It is
-- exact at the boundaries -- U(100) inverts to exactly 100 -- because A is rational and the
-- discriminant at a boundary is a perfect square; the epsilon is there for the float division
-- that gets it there, not for the algebra.
--
-- A line whose chain is finished keeps earning and keeps wrapping: a maxed Fireball still earns
-- its eighteen bound talents at one advance a rank, and the percentage is then the distance to
-- the next of those.
local function SkillPercent(stored)
    local u = ((stored or 0) % PRACTICE_RANK_STORED) / PRACTICE_UNIT_SCALE
    -- STRAIGHT. `u` runs 0 to PRACTICE_RANK_UNITS across a rank and the bar is its share of that,
    -- so every per cent is the same amount of fighting as every other.
    --
    -- It used to invert the storage curve -- p from U(p) = A*p^2 + (1-A)*p -- which made the
    -- shown per cent cost what the p-th per cent weighed, five times as much at the end as at the
    -- start. The intent was a rank that tightens as it closes. What it produced was a bar that
    -- visibly gave up near the finish: the last ten per cent were 4.08x the first ten, and 50%
    -- shown was 33% of the work done. Flattened on the user's report, 2026-09-19.
    --
    -- Costs nothing, and that is worth stating because it looks like a balance change. A press
    -- earns CastChance * RANK_STORED / RANK_COST units and a rank is RANK_STORED units, so
    -- presses per rank is RANK_COST / CastChance -- no curve in it anywhere. This moves where the
    -- bar sits during a rank, not how long the rank takes.
    --
    -- To put the curve back, restore the quadratic inverse here:
    --   local a = PRACTICE_CURVE
    --   p = math.floor(((a - 1) + math.sqrt((1 - a) * (1 - a) + 4 * a * u)) / (2 * a) + 1e-9)
    local p = math.floor(u * PRACTICE_STEPS / PRACTICE_RANK_UNITS + 1e-9)
    if p < 0 then
        return 0
    elseif p > PRACTICE_STEPS then
        return PRACTICE_STEPS
    end
    return p
end

-- Is this line waiting on a LEVEL rather than on another cast? Returns the level it waits for,
-- or 0 for "not waiting" -- which doubles as the boolean the credit loop and the display need.
--
-- One function and not three, because the main chunk of this file sits against Lua's 200-local
-- ceiling and each of these costs a slot. It answers both halves of the same question:
--
--   a rank already OWNED but not learned -- banked, waiting for its own level
--   the next rank not owned yet, whose level the character has not reached
--
-- The second half is the one that took two goes to get right. LineBanked alone asks whether a
-- rank is ALREADY waiting, and that is one event too late: a line with nothing banked is not
-- blocked, so the bar crosses the boundary, buys the rank, and only THEN finds the character too
-- low to use it. The rank goes to the pool, the bar restarts from nothing, and the hold engages
-- for the next one. From the inside that is a bar reaching 100% and resetting for nothing, which
-- is what it did on Cicuka at level 7: 99% one fight, 2% the next, Wrath rank 3 (level 14) banked
-- in between. Asked BEFORE the crossing instead.
--
-- A finished chain is not waiting: it goes on earning and wrapping, because its advances still
-- buy the talents bound to it.
local function LineWaitsFor(player, guid, lineId)
    if player == nil then
        return 0
    end
    local owned = poolSet[guid]
    for _, rankId in ipairs(ranksOfLine[lineId] or {}) do
        if owned and owned[rankId] then
            if not player:HasSpell(rankId) then
                return rankLevel[rankId] or 0
            end
        elseif player:GetLevel() < (rankLevel[rankId] or 1) then
            return rankLevel[rankId] or 0
        else
            return 0
        end
    end
    return 0
end

-- Where the bar is parked when it is held: one unit short of the boundary, because landing ON the
-- boundary is indistinguishable from an empty bar once the modulo has run.
local PRACTICE_HELD_AT = PRACTICE_RANK_STORED - 1

local function LineHeld(player, guid, lineId)
    local stored = (lineUnits[guid] or {})[lineId] or 0
    return (stored % PRACTICE_RANK_STORED) == PRACTICE_HELD_AT
        and LineWaitsFor(player, guid, lineId) > 0
end

-- What the reader is shown. 100 for a held line -- it IS full; what it is waiting for is a level,
-- not another cast.
local function ShownPercent(player, guid, lineId)
    if player and LineHeld(player, guid, lineId) then
        return PRACTICE_STEPS
    end
    return SkillPercent((lineUnits[guid] or {})[lineId] or 0)
end

local function RankLeft(guid, lineId, player)
    if player and LineHeld(player, guid, lineId) then
        return 0
    end
    local held = (lineUnits[guid] or {})[lineId] or 0
    local left = PRACTICE_RANK_STORED - (held % PRACTICE_RANK_STORED)
    return math.ceil(left / (CastUnits(guid, lineId) * (practiceRate[guid] or 1)))
end


-- The core's own grey level, copied from Acore::XP::GetGrayLevel
-- (src/server/game/Miscellaneous/Formulas.h). A creature at or below it awards no experience.
--
-- Copied rather than read off the experience number, because the experience number is not
-- available where this is needed. mod-individual-progression holds a character at 60 until it
-- has cleared vanilla and at 70 until it has cleared Outland, and MaxPlayerLevel does the same
-- at 80 -- three long stretches of a career where every kill pays nothing at all. Practice used
-- to hang off PLAYER_EVENT_ON_GIVE_XP and so stopped dead through all three, which for a
-- collection that is only 1112 ranks findable out of 3963 meant it stopped for good.
local function GrayLevel(level)
    if level <= 5 then
        return 0
    elseif level <= 39 then
        return level - 5 - math.floor(level / 10)
    elseif level <= 59 then
        return level - 1 - math.floor(level / 5)
    end
    return level - 9
end

-- CREATURE_TYPE_CRITTER. A squirrel is not a fight at any level.
local CREATURE_TYPE_CRITTER = 8

-- Is this kill worth practising on? This is the rule that keeps grinding things beneath you
-- from being the fast route, and it used to be free: the experience hook simply never fired for
-- a grey creature. Off the kill hook it has to be stated.
local function WorthPractising(player, killed)
    if killed:GetCreatureType() == CREATURE_TYPE_CRITTER then
        return false
    end
    return killed:GetLevel() > GrayLevel(player:GetLevel())
end

-- The enemy a press was aimed at, or nil for anything that is not one.
--
-- CALL THIS THROUGH pcall. Spell:GetTarget in the Eluna fork declares a return value even when
-- the spell has no target at all (SpellMethods.h, the if/else chain falls through and it still
-- returns 1), so what comes back can be a stale stack slot rather than nil -- and calling a
-- Unit method on that raises.
--
-- A creature with an OWNER is somebody's pet, minion or totem: something you heal and buff, not
-- something you kill, so it is not an enemy target either and its presses go in the shared
-- bucket where a heal belongs.
local function EnemyTarget(spell)
    local target = spell:GetTarget()
    local creature = target and target:ToCreature()
    if creature == nil or creature:GetOwner() ~= nil then
        return nil
    end
    return creature:GetGUIDLow()
end

--Database Functions
--create DB for GUID
local function DBCreate(guid)
    -- Only the columns this system still uses. spells/tpells/talents/stats are nullable and
    -- resets/dataver carry defaults, so omitting them is safe whether or not
    -- classless_drop_panel_columns.sql has been applied yet.
    --
    -- `pool` and `profs` MUST be listed explicitly. They are NOT NULL, and MySQL refuses to
    -- give a BLOB/TEXT column a default value at all (error 1101), so there is no schema-side
    -- fix -- omitting them fails the whole INSERT under strict mode with "[1364] Field 'pool'
    -- doesn't have a default value" and the character gets no row.
    CharDBQuery("INSERT INTO character_classless (guid, pool, profs, profver, poolver) "
        .. "VALUES (" .. guid .. ", '', '', " .. PROF_VER .. ", " .. POOL_VER .. ")")
end

-- Ensure the columns this system reads exist. MySQL 8.4 has no ADD COLUMN IF NOT EXISTS, so
-- probe information_schema first. Runs once at script load, before any LoadPlayerData can
-- read them. Synchronous (CharDBQuery, not CharDBExecute) so the columns exist before the
-- first SELECT runs.
local function EnsureSchema()
    local t = CharDBQuery("SELECT COUNT(*) FROM information_schema.TABLES "
        .. "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'character_classless'")
    if not t or t:GetUInt32(0) == 0 then
        return -- table not installed yet; DBCreate will make rows with the right shape
    end
    local function ensure(column, ddl)
        local c = CharDBQuery("SELECT COUNT(*) FROM information_schema.COLUMNS "
            .. "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'character_classless' "
            .. "AND COLUMN_NAME = '" .. column .. "'")
        if c and c:GetUInt32(0) == 0 then
            CharDBQuery("ALTER TABLE character_classless ADD COLUMN " .. ddl)
            -- Whether the column is there NOW, which is what the login SELECT depends on. An
            -- ALTER that failed (no privilege, table locked) must not take the login path down
            -- with it: a query naming a missing column returns nil, LoadPlayerData reads that
            -- as "no row" and tries to INSERT a duplicate for every character that logs in.
            local after = CharDBQuery("SELECT COUNT(*) FROM information_schema.COLUMNS "
                .. "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'character_classless' "
                .. "AND COLUMN_NAME = '" .. column .. "'")
            return after ~= nil and after:GetUInt32(0) > 0
        end
        return c ~= nil
    end
    -- The earned-rank pool. MEDIUMTEXT because a completionist can hold most of the ~3960
    -- ranks, which is ~27 KB of comma-separated ids -- well past TEXT's comfort.
    ensure("pool", "pool MEDIUMTEXT NOT NULL")
    -- Earned weapon/armour proficiencies, and their own migration marker. At most 21 skill
    -- ids, so TEXT is generous.
    ensure("profs", "profs TEXT NOT NULL")
    ensure("profver", "profver INT NOT NULL DEFAULT 0")
    -- Which SHAPE the pool column is in: 0 = line ids (one entry meant a whole chain),
    -- 1 = rank ids. The two cannot be told apart by looking at them -- a line id is its own
    -- rank 1 -- so the expansion has to be driven by this rather than by inspection.
    -- DEFAULT 0 is exactly right for every row that predates the column: those all hold line
    -- ids.
    ensure("poolver", "poolver INT NOT NULL DEFAULT 0")
    -- Practice experience per tree, "CLASS|Spec=amount" comma-separated. 27 trees, so a few
    -- hundred bytes at most. Nullable because MySQL refuses a DEFAULT on TEXT (error 1101) and
    -- a row written before this column existed has to be readable without one.
    HAS_TREES = ensure("trees", "trees TEXT NULL") or false
end
EnsureSchema()

--Write DB for GUID
-- Asynchronous on purpose: nothing here ever reads its own write back, and the pool column is
-- a ~27 KB MEDIUMTEXT rewrite that would otherwise block the world thread every time a tome
-- is read. AzerothCore runs the async queue FIFO on one worker per database, so a write
-- queued after DBCreate's synchronous INSERT still lands after it.
local function DBWrite(guid, entry, value)
    CharDBExecute("UPDATE character_classless SET " .. entry .. "='" .. value
        .. "' WHERE guid = " .. guid)
end

--Utility Functions
-- All of a character's practice in one column, because it is all one economy and it is all
-- rewritten together:
--
--   L133=48210      what casting Fireball has earned
--   R=237           what a fight has lately been worth to them, in hundredths, for the panel
--
-- Prefixed rather than split across columns: the shapes are all "key = whole number", the writes
-- always happen together, and a tree key can never collide with an "L" + digits one.
--
-- "S" (quest experience banked toward a token) and "T" (tokens in hand) were the quest route and
-- are gone. READING them is still tolerated below -- silently, by falling through -- because
-- every character saved before 2026-09-11 has them in this column and a row must load.
local function TreesToString(guid)
    local parts = {}
    for line, amount in pairs(lineUp[guid] or {}) do
        if amount >= 1 then
            parts[#parts + 1] = "L" .. line .. "=" .. math.floor(amount)
        end
    end
    -- "U133=4712" -- practice units earned on line 133, in hundredths. One key per line the
    -- character has ever practised, which for a reader who fights with a dozen abilities is a
    -- few hundred bytes; a completionist who has pressed every line in the game would reach
    -- ~19 KB, still inside TEXT.
    for line, units in pairs(lineUnits[guid] or {}) do
        if units >= 1 then
            parts[#parts + 1] = "U" .. line .. "=" .. math.floor(units)
        end
    end
    -- Hundredths, because the stored form only carries digits. Written so the panel is right
    -- the moment it opens after a login rather than converging over the next twenty fights.
    if (practiceRate[guid] or 1) > 1.01 then
        parts[#parts + 1] = "R=" .. math.floor(practiceRate[guid] * 100)
    end
    return table.concat(parts, ",")
end

local function TreesFromString(guid, str)
    lineUp[guid] = {}
    lineUnits[guid] = {}
    practiceRate[guid] = 1
    for key, amount in string.gmatch(str or "", "([^=,]+)=(%d+)") do
        local n = tonumber(amount) or 0
        if key == "R" then
            practiceRate[guid] = (n >= 100) and (n / 100) or 1
        else
            -- "S" and "T" from the retired quest route land here and are dropped, which is what
            -- turns an old row into a new one: the next write leaves them out for good.
            local line = string.match(key, "^L(%d+)$")
            if line then
                lineUp[guid][tonumber(line)] = n
            end
            -- Rows written before the scale existed carry no U keys at all, and rows written
            -- during the morning of 2026-09-16 carry "P" keys counting TICKS, which this shape
            -- has no use for. Both fall through here, the way the retired quest keys do, and
            -- LoadPlayerData backfills from the ranks the character already holds -- so the
            -- scale opens at the rank they are standing on rather than at zero.
            local uline = string.match(key, "^U(%d+)$")
            if uline then
                lineUnits[guid][tonumber(uline)] = n
            end
        end
    end
end

-- The single place that adds to the pool, so the array and the set can never disagree.
local function PoolInsert(guid, rankId)
    if poolSet[guid][rankId] then
        return false
    end
    poolSet[guid][rankId] = true
    table.insert(pools[guid], rankId)
    local counts = lineOwned[guid]
    if counts then
        local line = lineOfSpell[rankId]
        if line then
            counts[line] = (counts[line] or 0) + 1
        end
    end
    return true
end

-- Populates the in-memory tables for a guid from the DB (creating the row if missing).
local function LoadPlayerData(guid)
    local pool = ""
    -- Named columns rather than SELECT * and positional reads: the old code indexed columns
    -- 7..10 behind four pcalls because their position depended on which migrations had run.
    --
    -- `profs` is no longer read. Every character has all 21 proficiencies, so the stored list
    -- answers nothing; the column stays in the schema because DBCreate still has to satisfy its
    -- NOT NULL.
    local trees = ""
    local cols = HAS_TREES and "pool, trees" or "pool"
    local q = CharDBQuery("SELECT " .. cols .. " FROM character_classless "
        .. "WHERE guid = " .. guid)
    if q == nil then
        DBCreate(guid) -- created already at PROF_VER and POOL_VER
    else
        pool = q:GetString(0)
        if HAS_TREES then
            trees = q:GetString(1) or ""
        end
    end
    TreesFromString(guid, trees)
    lineAt[guid], lineHit[guid] = {}, {}
    pending[guid], treeDirty[guid] = {}, nil

    pools[guid], poolSet[guid] = {}, {}
    -- Before the pool is filled, so PoolInsert counts every rank as it arrives rather than the
    -- panel counting them all again later.
    lineOwned[guid] = {}

    local raw = toTable(pool)
    for i = 1, #raw do
        PoolInsert(guid, raw[i])
    end
    if #pools[guid] ~= #raw then
        -- Duplicates in the stored string; PoolInsert dropped them, so persist the clean list.
        DBWrite(guid, "pool", toString(pools[guid]))
    end

    -- Seed on first sight. An empty pool means this character was just created (or predates
    -- the earn system). starterPool is currently empty by design (STARTER_LEVEL == 0), so for
    -- a genuinely new character the only thing seeded is the one random level-1 spell below --
    -- without it this block would leave the pool empty and re-run every login.
    if #pools[guid] == 0 then
        for i = 1, #starterPool do PoolInsert(guid, starterPool[i]) end
        -- One random level-1 spell so a new character has something to press instead of an
        -- empty action bar. GrantBankedRanks (called right after LoadPlayerData in OnLogin)
        -- picks this up immediately since its level requirement is already met. If it needs a
        -- weapon type, flag it for OnLogin (see pendingWeaponReq) -- there's no player object
        -- here to check HasSkill against or to hand the weapon item to.
        if #level1Spells > 0 then
            local pick = level1Spells[math.random(#level1Spells)]
            PoolInsert(guid, pick)
            pendingWeaponReq[guid] = level1WeaponReq[pick]
        end
        DBWrite(guid, "pool", toString(pools[guid]))
    end

    -- Starter lines are re-checked on EVERY login, not only on first sight. The seed above
    -- fires once, when the pool is empty, so it can never reach a character that already
    -- exists -- and the starter set has grown before now. Rather than carry another schema
    -- version column for each such change, just make the rule continuously true: whatever is
    -- in starterPool is in every character's pool. Idempotent, and cheap.
    local backfilled = 0
    for i = 1, #starterPool do
        if PoolInsert(guid, starterPool[i]) then
            backfilled = backfilled + 1
        end
    end
    if backfilled > 0 then
        DBWrite(guid, "pool", toString(pools[guid]))
    end

    -- Where the visible practice scale starts for a line with no U key of its own.
    --
    -- Every rank above the first is one rank's worth of practice, whoever paid for it -- so a
    -- character holding eight ranks of Frostbolt stands at the foot of the eighth and the number
    -- should say so. Without this they would read 0% beside a nearly-finished chain, which is
    -- not a smaller truth but a wrong one.
    --
    -- Only where the key is MISSING, so it can never walk back progress that was actually
    -- earned, and not written here: the next flush carries it, and a login that writes a column
    -- for every character is what the flush exists to avoid.
    for line, owned in pairs(lineOwned[guid]) do
        if lineUnits[guid][line] == nil and owned > 1 then
            lineUnits[guid][line] = (owned - 1) * PRACTICE_RANK_STORED
        end
    end

    -- Proficiencies are not per-character any more: every character has all 21, applied from
    -- profOf on every login. The `profs` column is left in the schema and left alone -- it costs
    -- nothing, and dropping a NOT NULL column out from under a running realm to save a few
    -- hundred bytes is not a trade worth making.
end

local function SendVars(msg, player)
    if not Ours(player) then
        return
    end
    -- Which lines take their ranks from the LEVEL instead of from practice. Sent once, here,
    -- because every practice sentence the client writes -- the catalogue row, the action bar
    -- tooltip, the talent card's heading -- has to know not to quote a rank distance for one of
    -- these: their next rank is not something practice is working toward, it arrives on its own.
    -- 135 numbers, so it rides along with init rather than being asked for per line.
    --
    -- Only the SENTENCES change. These lines still earn practice and still offer the talents
    -- bound to them, which for 40 talents is the only route there is.
    local auto = {}
    for lineId in pairs((CLDB and CLDB.autorank) or {}) do
        auto[#auto + 1] = lineId
    end
    -- The resource bars are the only thing left that needs anything from the server at init.
    AIO.Handle(player, handlerName, "LoadVars",
        player:GetQuestRewardStatus(WOTLK_PROGRESSION_QUEST), auto)
end

AIO.AddOnInit(SendVars)

--Delete DB for GUID
local function OnDelete(event, guid)
    CharDBExecute("DELETE FROM character_classless WHERE guid = " .. guid)
    ForgetPlayer(guid)
end

-- =====================================================================================
-- The collection panel  (/tomes)
--
-- 3963 ranks exist and nothing in the game tells a character which ones it is missing. For
-- the tradeable majority the auction house answers that -- search "Tome of", see what is on
-- offer -- but 414 tomes bind on pickup and never reach it, and the hint notes that used to
-- point at those were retired on 2026-08-27. Without a list they are invisible: not hard to
-- get, unknowable.
--
-- Server-driven, and that is the whole design. The old panel's data rode along as nine
-- AIO.AddAddon files (571 KB, of which tomes.data alone was 469 KB), and because tomes.data
-- is regenerated by every pipeline run its checksum changed every time, forcing a fresh
-- download on every client. Nothing is shipped here. The client asks, the server answers out
-- of the tables it already holds, and the answer is current by construction -- including the
-- player's own pool, which a static addon file could never have carried at all.
--
-- What crosses the wire, in the order the UI needs it:
--   CollIndex  -> CollBegin, then one CollPage per spec carrying every LINE with its
--                 owned/total. Ids only: the client resolves names and icons out of its own
--                 Spell.dbc for free, which is what keeps this to numbers -- about 19 KB
--                 for all 1180 lines.
--   CollLine   -> CollRanks: the ranks of ONE line, with the creature and zone each is found
--                 on. This is the string-heavy half -- the 469 KB -- so it is fetched only
--                 for the line actually being looked at.
--   CollBump   -> pushed on unlock, so the cached counts stay right without a re-request.
-- =====================================================================================

-- How many of each kind of panel request may be served, and over how many seconds.
--
-- The two expensive ones keep a hard gate: the catalogue index is ~19 KB over 18 messages and
-- the suggestion walk sorts all 1,180 lines, and nobody needs either more than once every few
-- seconds. The rest are one line's worth of work and get an allowance generous enough that
-- reading the collection never hits it -- twenty line opens in five seconds is faster than
-- anyone browses, and a held keybind sustains four a second, which this refuses.
--
-- Throttle itself is declared with the other per-player state at the top of the file: the
-- cleanup in OnDelete runs textually BEFORE this point, and a local declared here would have
-- left that line writing to a global that does not exist -- which is exactly what happened with
-- its predecessor, until somebody deleted a character and got "attempt to index global
-- 'collLastIndex' (a nil value)".
local COLL_INDEX_LIMIT, COLL_INDEX_WINDOW = 1, 3
local COLL_SUGGEST_LIMIT, COLL_SUGGEST_WINDOW = 1, 5
local COLL_LINE_LIMIT, COLL_LINE_WINDOW = 20, 5
local COLL_STATE_LIMIT, COLL_STATE_WINDOW = 10, 5

-- How much of one line a character has found. Two table reads: the running count PoolInsert
-- keeps, and the chain length, which never changes.
local function LineOwned(guid, lineId)
    local chain = ranksOfLine[lineId]
    if chain == nil then
        return 0, 0
    end
    local counts = lineOwned[guid]
    return counts and (counts[lineId] or 0) or 0, #chain
end

-- One flat array per catalogue page, built once. Five numbers per line -- lineId, ranks in
-- the line, ranks owned, the level the line opens at, flags -- of which only the third is
-- personal. Smallfolk writes a nested table per line as its own braces and keys, which for
-- 1180 lines would be most of the message, hence flat.
local pageFlat = {}
local rankTotalAll = 0

local function BuildPanelTemplates()
    for i = 1, #catalog do
        local lines = catalog[i].lines
        local flat = {}
        for j = 1, #lines do
            local lineId = lines[j]
            local chain = ranksOfLine[lineId] or {}
            local n = #flat
            flat[n + 1] = lineId
            flat[n + 2] = #chain
            flat[n + 3] = 0                      -- owned, filled in per request
            flat[n + 4] = rankLevel[chain[1]] or 1
            -- bit 1: rare buff line -- every rank comes off a dungeon boss and binds on
            -- pickup, so it is the one thing on the list the auction house cannot supply.
            flat[n + 5] = (CLDB.rarebuffs and CLDB.rarebuffs[lineId]) and 1 or 0
            rankTotalAll = rankTotalAll + #chain
        end
        pageFlat[i] = flat
    end
end

-- Load a character's data if this Lua state does not have it.
--
-- Every AIO handler used to open with "if lineUnits[guid] == nil then return end" and say nothing,
-- on the assumption that OnLogin had already run. A `reload ale` breaks that assumption: the Lua
-- state is thrown away and rebuilt while the player stays in the world, so no login event fires
-- for them. The catch-up sweep at the bottom of this file is supposed to cover it and evidently
-- did not -- the symptom was a character whose action bar strips were all blank, /tomes barsdebug
-- reporting "asked 7s ago, no answer" on the client and "player data loaded false" on the server,
-- and a relog fixing it.
--
-- Guessing which of the two is at fault is not necessary to make it stop happening. A handler that
-- needs the data loads it. Only when it is missing -- LoadPlayerData resets the in-flight practice
-- tallies, so calling it on a character that IS loaded would throw away the current fight.
-- Takes the PLAYER, not a guid, and it is not a convenience: the gate is the reason.
--
-- The first version took a guid and loaded whatever it was given. Three handlers -- PracticeState,
-- PracticeAsk, PracticePick -- have no Ours() test of their own; they relied on lineUp[guid] being
-- nil for anyone the login hook had turned away, which was a class gate by side effect. Loading on
-- demand removed it, and a Druid asking for practice state got an answer. A test caught it.
--
-- So the class test lives here, where it cannot be forgotten at a call site.
local function EnsureLoaded(player)
    if not Ours(player) then
        return false
    end
    local guid = player:GetGUIDLow()
    if lineUnits[guid] == nil then
        LoadPlayerData(guid)
    end
    return lineUnits[guid] ~= nil
end

function Handlers.CollIndex(player)
    if not Ours(player) then
        return
    end
    EnsureLoaded(player)
    local guid = player:GetGUIDLow()
    if pools[guid] == nil then
        return
    end
    if not Throttle(guid, "index", COLL_INDEX_LIMIT, COLL_INDEX_WINDOW) then
        return
    end

    -- Summed over the catalogue rather than over the counter table: a rank can belong to a
    -- line the catalogue does not list, and the progress figure has to match what the panel
    -- can actually show.
    local counts = lineOwned[guid] or {}
    local ownedTotal = 0
    for i = 1, #catalog do
        local lines = catalog[i].lines
        for j = 1, #lines do
            ownedTotal = ownedTotal + (counts[lines[j]] or 0)
        end
    end
    AIO.Handle(player, handlerName, "CollBegin", #catalog, ownedTotal, rankTotalAll)

    -- Batched per class+kind, not one message for the whole catalogue and not one per spec.
    -- A single 19 KB message is split into eight addon packets that only reassemble once the
    -- last one arrives, so the panel would stay empty until then; one per spec is 54 messages
    -- to save nothing. Grouped this way each message fits in a packet or two and the left
    -- column fills in as they land.
    local msg = nil
    for i = 1, #catalog do
        local page = catalog[i]
        if msg == nil then msg = AIO.Msg() end
        -- Flat, five numbers per line: lineId, ranks in the line, ranks owned, the level the
        -- line opens at, flags. Smallfolk writes a nested table per line as its own braces
        -- and keys, which for 1180 lines is most of the message.
        -- The shared template, with only the personal slot rewritten.
        local flat = pageFlat[i]
        for j = 1, #page.lines do
            flat[(j - 1) * 5 + 3] = counts[page.lines[j]] or 0
        end
        msg:Add(handlerName, "CollPage", i, page.cls, page.kind, page.spec, page.icon, flat)
        local nxt = catalog[i + 1]
        if nxt == nil or nxt.cls ~= page.cls or nxt.kind ~= page.kind then
            msg:Send(player)
            msg = nil
        end
    end
    AIO.Handle(player, handlerName, "CollDone")
end

-- The sources for one line. Three states per rank, because "found" and "usable" are not the
-- same thing here: a rank can sit in the pool waiting for a level or for the rank below it,
-- and the panel is the only place that difference is visible after the pickup message has
-- scrolled away.
function Handlers.CollLine(player, lineId)
    if not Ours(player) or type(lineId) ~= "number" then
        return
    end
    local guid = player:GetGUIDLow()
    EnsureLoaded(player)
    local chain = ranksOfLine[lineId]
    if pools[guid] == nil or chain == nil then
        return
    end
    if not Throttle(guid, "line", COLL_LINE_LIMIT, COLL_LINE_WINDOW) then
        return
    end
    local set = poolSet[guid]
    -- A talent the DBC gives no press count for cannot be pressed at all: it is earned entirely
    -- through the spells it improves, so a press count for it would be the PRACTICE_CASTS
    -- fallback dressed up as a measurement. 618 of the 622 bound talents are in this state; the
    -- four that are castable keep their number, because pressing those is a real act.
    local passive = (isTalentLine[lineId] and not ((CLDB.casts or {})[lineId])) and 1 or 0
    -- A buff, a stance or a teleport is not practised at all -- its ranks come with the level --
    -- so quoting a press count for one would be inventing a price nobody pays.
    local autoLine = ((CLDB and CLDB.autorank) or {})[lineId] and true or false
    -- What a rank of this line costs in PRESSES of it. One number for the whole chain: pricing is
    -- flat, so the sixteenth rank asks exactly what the second does. Hoisted out of the loop for
    -- that reason -- computing it per row would suggest the rows could differ.
    local presses = (passive == 0 and not autoLine) and RankCasts(guid, lineId) or nil
    local rows = {}
    for i = 1, #chain do
        local rankId = chain[i]
        local t = tomeOf[rankId]
        local state = 0
        if set[rankId] then
            state = player:HasSpell(rankId) and 2 or 1
        end
        -- A rank with no tome row above rank 1 is not missing data: it is a rank the
        -- world does not carry, because the world carries the discovery and the practice
        -- carries the rest. Kind "p" says that; "?" stays for the genuine hole -- a rank 1
        -- with no source, which would be a generator bug worth seeing.
        --
        -- A TALENT has no discovery rank either. Every talent is offered against a spell line
        -- and earned by practising it, so the world carries none of the chain and rank 1 is
        -- practice like the rest -- talentcut.py took the last 622 of those rows out of
        -- tomes.data. Without this the whole talent half of the panel would read "?".
        -- ...and a buff, stance, form, aura, portal or teleport is neither: kind "l" says the
        -- rank arrives with the LEVEL, which is the truth for 123 lines that practice could
        -- never have paid for. Checked before "p", because these lines are pressable and would
        -- otherwise read as practice.
        local kind = t and t[2]
            or (autoLine and i > 1 and "l")
            or ((i > 1 or isTalentLine[lineId]) and "p" or "?")
        -- rankId, level, state, kind, itemId, source name, place, source level, alts, fights
        local row = { rankId, rankLevel[rankId] or 1, state,
                      kind, t and t[1] or 0,
                      t and t[4] or "", t and t[5] or "", t and t[7] or 0 }
        -- What this rank costs, in PRESSES of the ability -- divided by how often that
        -- particular button gets pressed, so about 267 of Frostbolt against 45 of Corruption:
        -- the same amount of fighting either way, which is the point. Only for the ranks
        -- practice can reach; rank 1 is found, never practised.
        if i > 1 and presses then
            row[10] = presses
        end
        rows[i] = row
    end

    -- Bounties, as a second table rather than more fields on the row: a rank without alts
    -- already leaves row[9] empty, and hanging further entries past a hole makes the row a
    -- sparse array for no gain. Keyed by rank so the client can look one up without a scan.
    --
    -- Only for a rank the character has not found yet -- a bounty on a book already in the pool
    -- is noise -- and only where the rank's GROUP has a named target with a bounty on it: the
    -- shallowest rare or boss that answers for the group (BountyForRank).
    --
    -- status 1 is QUEST_STATUS_COMPLETE and 3 is INCOMPLETE (both mean "in the log"); anything
    -- else, including 6 REWARDED, reads as "exists, not taken".
    local bounty
    for i = 1, #chain do
        local rankId = chain[i]
        local b = BountyForRank(rankId)
        if b and not set[rankId] then
            local status = player:GetQuestStatus(b[2])
            bounty = bounty or {}
            bounty[rankId] = { b[2], (status == 1 or status == 3) and 1 or 0 }
        end
    end
    AIO.Handle(player, handlerName, "CollRanks", lineId, rows, bounty, passive)
end

-- =====================================================================================
-- The zone view.
--
-- The catalogue answers "what does this class have"; the world is walked by ZONE. A player
-- standing in Duskwood wants the other question -- what is there to find here -- and until now
-- the only way to ask it was to open every line and read the source strings one at a time.
--
-- Built once at load from the same tables the panel already uses. A rank whose primary source
-- is in one zone and whose alt is in another belongs to both, which is the truth: either kill
-- hands over the same book.
-- =====================================================================================
local zoneRanks = {}          -- zone name -> { rankId, ... }
-- zone name -> the rows and line ids sent for it. Constant except each row's state field, so
-- it is built on the first request for that zone and reused after.
local zoneTemplate = {}
local zoneNames = {}          -- sorted, so the client's list is stable across restarts

local function BuildZoneIndex()
    local seen = {}
    local function put(zone, rankId)
        if zone == nil or zone == "" or rankId == nil then
            return
        end
        local key = zone .. "\0" .. rankId
        if seen[key] then
            return
        end
        seen[key] = true
        local list = zoneRanks[zone]
        if list == nil then
            list = {}
            zoneRanks[zone] = list
            zoneNames[#zoneNames + 1] = zone
        end
        list[#list + 1] = rankId
    end

    for rankId, t in pairs(tomeOf) do
        -- Keyed by the SOURCE GROUP -- "Shadow casters, undead and demons" -- and not by the
        -- place, because the place is a band of levels now ("levels 21-25") and a list of
        -- sixteen bands says nothing a reader could act on. The group is the thing the world
        -- makes visible: what kind of creature to go and fight.
        --
        -- "s" is granted at creation and has no source at all; a quest rank names its quest
        -- giver, which is still a place worth listing, so those keep whatever they carry.
        if t[2] ~= "s" then
            put(t[2] == "q" and t[5] or t[4], rankId)
        end
    end
    table.sort(zoneNames)
    for _, list in pairs(zoneRanks) do
        table.sort(list, function(a, b)
            local la, lb = rankLevel[a] or 1, rankLevel[b] or 1
            if la ~= lb then return la < lb end
            return a < b
        end)
    end
end

function Handlers.CollZones(player)
    if not Ours(player) then
        return
    end
    EnsureLoaded(player)
    local guid = player:GetGUIDLow()
    local set = poolSet[guid]
    if set == nil then
        return
    end
    if not Throttle(guid, "zones", COLL_INDEX_LIMIT, COLL_INDEX_WINDOW) then
        return
    end
    -- Flat triples, the same shape the spec pages use: names are the bulk of this message and
    -- three values per zone keeps the rest of it small.
    local flat = {}
    for i = 1, #zoneNames do
        local zone = zoneNames[i]
        local list = zoneRanks[zone]
        local owned = 0
        for j = 1, #list do
            if set[list[j]] then owned = owned + 1 end
        end
        flat[#flat + 1] = zone
        flat[#flat + 1] = #list
        flat[#flat + 1] = owned
    end
    AIO.Handle(player, handlerName, "CollZoneList", flat)
end

function Handlers.CollZone(player, zone)
    if not Ours(player) or type(zone) ~= "string" then
        return
    end
    local guid = player:GetGUIDLow()
    EnsureLoaded(player)
    local list = zoneRanks[zone]
    local set = poolSet[guid]
    if list == nil or set == nil then
        return
    end
    if not Throttle(guid, "zone", COLL_LINE_LIMIT, COLL_LINE_WINDOW) then
        return
    end
    -- Rows in the CollRanks layout, so the client reuses its rendering, its tooltip and the
    -- bounty marker untouched; the line each rank belongs to travels as a parallel array,
    -- because a tenth field would sit past the alts slot, which is empty for most ranks.
    --
    -- Built once per zone and kept. Only field 3, the state, is personal.
    local cached = zoneTemplate[zone]
    if cached == nil then
        local rows, lineIds = {}, {}
        for i = 1, #list do
            local rankId = list[i]
            local t = tomeOf[rankId]
            rows[i] = { rankId, rankLevel[rankId] or 1, 0,
                        t and t[2] or "?", t and t[1] or 0,
                        t and t[4] or "", t and t[5] or "", t and t[7] or 0 }
            lineIds[i] = lineOfSpell[rankId] or rankId
        end
        cached = { rows = rows, lineIds = lineIds }
        zoneTemplate[zone] = cached
    end
    for i = 1, #list do
        local rankId = list[i]
        local state = 0
        if set[rankId] then
            state = player:HasSpell(rankId) and 2 or 1
        end
        cached.rows[i][3] = state
    end
    AIO.Handle(player, handlerName, "CollZoneRows", zone, cached.rows, cached.lineIds)
end

BuildZoneIndex()
BuildPanelTemplates()
print("[ClassLess] zone view: " .. #zoneNames .. " zones indexed, "
      .. #catalog .. " catalogue pages precomputed")

-- =====================================================================================
-- Unlocking ability ranks
--
-- Creature drops are handled entirely by creature_loot_template -- the tome falls into the
-- loot window like any other item, which is the whole point of the design: it is visible, it
-- can be traded, and it uses the game's own systems. The server only gets involved when the
-- tome is USED.
-- =====================================================================================

-- Rank N of a line can't be known before rank N-1 is. ranksOfLine[lineId] is already in rank
-- order (index 1 = the line's first rank), so this is a lookup, not a search over levels or
-- ids. A rank with no line (shouldn't happen, every rank is indexed off spells.data /
-- talents.data) or sitting at index 1 has nothing to require.
local function PrevRankOf(rankId)
    local chain = ranksOfLine[lineOfSpell[rankId]]
    if not chain then
        return nil
    end
    for i = 2, #chain do
        if chain[i] == rankId then
            return chain[i - 1]
        end
    end
    return nil
end

local function PrevRankKnown(player, rankId)
    local prev = PrevRankOf(rankId)
    return prev == nil or player:HasSpell(prev)
end

-- Fury (34428) is one spell id that has always had to drag two more along with it.
local function LearnRank(player, rankId)
    player:LearnSpell(rankId)
    if rankId == 34428 then
        player:LearnSpell(32215)
        player:LearnSpell(32216)
    end
end

-- Hand over anything in the pool the character has now grown into. Cheap enough to run on
-- every level-up and on login: the pool is a few thousand ids at most and HasSpell is a hash
-- lookup. Login matters as much as level-up, because a rank can also be banked by a migration
-- or a backfill rather than by reading a book.
--
-- Runs to a fixed point rather than one pass: granting rank 2 can make rank 3 eligible in the
-- same call (a multi-level-up, or a backfill that banked several ranks of one line at once),
-- and the pool isn't stored in rank order so a single pass could see 3 before 2.
local function GrantBankedRanks(player, guid)
    if not Ours(player) then
        return 0
    end
    local pool, level, got = pools[guid], player:GetLevel(), 0
    local refused, refusedIds = 0, {}
    local changed = true
    while changed do
        changed = false
        for i = 1, #(pool or {}) do
            local rankId = pool[i]
            if level >= (rankLevel[rankId] or 1) and PrevRankKnown(player, rankId)
                and not player:HasSpell(rankId) then
                LearnRank(player, rankId)
                -- Read it back. LearnSpell is a void call and the core drops a spell it does not
                -- like without saying so -- which is how a character ended up holding a pool
                -- entry it had never been taught, and no way to tell from the outside whether
                -- the grant had run at all. Counting the successes separately turns that into
                -- something the next login reports instead of something to go looking for.
                if player:HasSpell(rankId) then
                    got = got + 1
                    changed = true
                else
                    refused = refused + 1
                    refusedIds[#refusedIds + 1] = rankId
                end
            end
        end
    end
    if refused > 0 then
        print("[ClassLess] guid " .. guid .. ": the core refused " .. refused
            .. " banked rank(s): " .. table.concat(refusedIds, ", "))
    end
    return got
end

-- Unlock a rank and tell the client. Returns true if it was new.
-- `src` is "practice" when the rank was EARNED rather than found. It changes nothing about what
-- happens and everything about what the reader is told: below level 10 a line's second rank is
-- banked, so the only thing the player sees for a full bar is a message -- and that message said
-- "You have found Immolate (Rank 2)", which is what a tome says. Nothing was found. A bar that
-- restarts at zero next to a sentence about finding something reads as the practice having been
-- thrown away, which is precisely what it was not.
local function UnlockRank(player, guid, rankId, src)
    if pools[guid] == nil or not PoolInsert(guid, rankId) then
        return false
    end
    DBWrite(guid, "pool", toString(pools[guid]))
    -- With no panel to spend it in, owning a rank has to mean knowing it. Level and the
    -- previous rank are still enforced: an early find is banked until both catch up.
    --
    -- The full sweep, not just "learn this one id", because ranks are found in whatever order
    -- the world hands them over. Owning rank 3 while rank 2 is still missing leaves 3 banked
    -- on PrevRankKnown; reading rank 2 is exactly the event that frees it, and learning only
    -- rank 2 here left rank 3 stuck until the next level-up or login. One pass over the pool
    -- measures ~1 ms even for a character holding all 3963 ranks, and reading a tome is a rare
    -- event, so there is no reason to be clever about it.
    GrantBankedRanks(player, guid)
    -- The client prints the ability's name; the server has no spell-name lookup. Tell it what
    -- ACTUALLY happened rather than letting it guess: a tome can be read at any time, so the
    -- rank may have been learned, or banked because the level is too low, or banked because
    -- the rank below it has not been found yet. The client used to infer this from level
    -- alone, so reading rank 3 while missing rank 2 announced "It is in your spellbook now"
    -- when it was not, and never mentioned the rank that was actually blocking it.
    local state, arg
    if player:HasSpell(rankId) then
        state = "ok"
    elseif player:GetLevel() < (rankLevel[rankId] or 1) then
        state, arg = "lvl", rankLevel[rankId] or 1
    else
        state, arg = "req", PrevRankOf(rankId)
    end
    AIO.Handle(player, handlerName, "PoolAdd", rankId, state, arg, src)
    -- Keep an open collection panel honest without making it re-request the index. Sent
    -- unconditionally rather than only when the panel is open: the server does not know
    -- whether it is, and the client caches the counts for the whole session either way.
    local lineId = lineOfSpell[rankId]
    if lineId then
        local owned, total = LineOwned(guid, lineId)
        AIO.Handle(player, handlerName, "CollBump", lineId, owned, total)
    end
    return true
end

-- Ranks that arrive with the LEVEL rather than with practice.
--
-- Practice prices an advance in PRESSES of the ability, which is honest for anything you press in
-- a fight and nonsense for anything you press once and then live with. Arcane Intellect lasts half
-- an hour, Battle Stance is a toggle, Teleport: Orgrimmar is pressed when you want to be in
-- Orgrimmar. practice.data cannot describe them and does not try to: it hands the three Warrior
-- stances and Aspect of the Hawk a count of TWELVE, the spam-nuke band, so the least pressable
-- abilities in the game were priced as the dearest -- about 267 presses a rank, which for a
-- half-hour buff is not a price, it is a wall.
--
-- 123 lines, 223 ranks above rank 1: every buff, stance, form, aura, aspect, armor, shout,
-- blessing and weapon enchant, plus every portal and teleport. Chosen by
-- tools/classless-web/autorank.py from roles.data AND a Spell.dbc damage test, because roles.data
-- alone labels Arcane Missiles, Blizzard, Rain of Fire and Volley as "buff" and a role-only rule
-- would have handed out 35 ranks of nuke for free.
--
-- RANK 1 IS UNCHANGED. The discovery is still found in the world; this only decides how the rest
-- of an already-found line arrives. A line nobody has found gets nothing, which is the same rule
-- practice obeys.
--
-- Nothing needs to change in PracticeOptions for these. It offers the line's next rank only when
-- RankReady passes, and by the time a level is reached this has already taken every rank that
-- level allows -- so the only thing left for practice to sell on a buff line is the talents bound
-- to it, which is exactly right: pressing Battle Shout should still earn Commanding Presence.
local function GrantAutoRanks(player, guid)
    if not Ours(player) or pools[guid] == nil then
        return 0
    end
    local auto = (CLDB and CLDB.autorank) or {}
    local counts, level, added = lineOwned[guid] or {}, player:GetLevel(), 0
    local touched = nil
    for lineId in pairs(auto) do
        -- Owned means found: rank 1 came out of the world. Without this test the first rank of
        -- every buff in the game would arrive on a level-up, which is the one thing neither this
        -- nor practice may ever do.
        if (counts[lineId] or 0) > 0 then
            for _, rankId in ipairs(ranksOfLine[lineId] or {}) do
                if level >= (rankLevel[rankId] or 1) and not poolSet[guid][rankId] then
                    if PoolInsert(guid, rankId) then
                        added = added + 1
                        touched = touched or {}
                        touched[lineId] = true
                    end
                end
            end
        end
    end
    if added == 0 then
        return 0
    end
    -- One write and one message for the whole sweep, not one per rank. A character that has been
    -- away since before this existed, or one that owns thirty buff lines, would otherwise log in
    -- to thirty chat lines and thirty pool writes of a 27 KB column.
    DBWrite(guid, "pool", toString(pools[guid]))
    GrantBankedRanks(player, guid)
    for lineId in pairs(touched) do
        local owned, total = LineOwned(guid, lineId)
        AIO.Handle(player, handlerName, "CollBump", lineId, owned, total)
    end
    return added
end

-- Practice experience is written on a purchase and on logout, and nowhere else -- which
-- means a crash, or a `reload ale`, throws away whatever has been earned since. During the
-- measurement run that cost the sample its pots seven times over and the rank count sat still
-- through four fixes. So the unsaved remainder is flushed on a timer as well; treeDirty is
-- already the list of who needs it.
local PRACTICE_FLUSH_MS = 60000

local function PracticeFlush()
    for guid in pairs(treeDirty) do
        TreeFlush(guid)
    end
    -- Drop press tallies for fights that are over. CreditPractice prunes as well, but only when
    -- something DIES -- so a character pressing at things it never kills (a tank holding a mob
    -- it cannot finish, anyone who keeps losing) accumulated an entry per target with nothing to
    -- clear them. Bounded by the window either way; this makes it bounded by time as well.
    for guid, held in pairs(lineAt) do
        for target, tally in pairs(held) do
            if GetTimeDiff(tally.at or 0) > PRACTICE_WINDOW then
                held[target] = nil
            end
        end
        local support = lineHit[guid]
        if support and support.at and GetTimeDiff(support.at) > PRACTICE_WINDOW then
            lineHit[guid] = {}
        end
    end
end
if PRACTICE then
    CreateLuaEvent(PracticeFlush, PRACTICE_FLUSH_MS, 0)
end

-- ---------------------------------------------------------------------------------------
-- PRACTICE: what a fight earns, and what it buys.
--
-- Casting a spell in a fight that ends in a kill credits THAT LINE, and a quarter of the credit
-- goes to the line's tree. When a line has earned its next rank it does not take it silently:
-- it offers the rank, or one of the talents that make that same spell better, and the reader
-- picks. That choice is the only build decision left in a game whose talent panel is gone --
-- and it is a real one, because the practice pays for one of them, not both.
--
-- The tree pot exists for the 204 talents that modify no single spell (Thick Hide, Omen of
-- Clarity, Leader of the Pack). Nothing can offer those against a spell rank, so they are
-- bought outright as the tree fills.

function TreeFlush(guid)
    if HAS_TREES and treeDirty[guid] and lineUp[guid] then
        DBWrite(guid, "trees", TreesToString(guid))
        treeDirty[guid] = nil
    end
end

-- Practice changed: write it now.
--
-- It used to be marked dirty here and written by the minute timer, on the reasoning that this
-- runs for every press of every ability of everyone online. That reasoning was wrong twice over.
-- CreditPress is called once per ABILITY per FIGHT -- RollPresses hands it a whole fight's presses
-- already summed -- and playerbots are not ClassLess characters at all, so the writers are the
-- handful of people actually logged in. The cost is one UPDATE per ability per fight.
--
-- What the delay bought instead was a window in which earned practice did not exist anywhere but
-- memory. A crash, a `reload ale` or a worldserver kill inside that minute threw it away, and
-- during the measurement run that happened seven times.
--
-- The minute timer stays as a net: it now finds nothing dirty on a normal fight, and still catches
-- anything that sets treeDirty without coming through here.
local function TreeTouch(guid)
    treeDirty[guid] = true
    TreeFlush(guid)
end

-- The first rank of a line the character does not own yet, or nil if the chain is complete.
-- Stops at the first gap rather than skipping it: ranks are learned in order.
local function NextRankOfLine(guid, lineId)
    local owned = poolSet[guid]
    if owned == nil then
        return nil
    end
    for _, rankId in ipairs(ranksOfLine[lineId] or {}) do
        if not owned[rankId] then
            return rankId
        end
    end
    return nil
end

-- Can this rank be taken now? Only the level is asked here. Being next in the chain is not
-- checked because it cannot fail: every caller gets `rankId` from NextRankOfLine, which returns
-- the first rank of the line the character does not already own.
local function RankReady(player, rankId)
    return rankId ~= nil and player:GetLevel() >= (rankLevel[rankId] or 1)
end

-- The line's own next rank, taken without spending anything.
--
-- Since 2026-09-14 a rank is not something the reader chooses -- it is what practising an
-- ability does. The user's call: "a kovetkezo rang automatikusan legyen megtanitva es egy
-- related talentet lehessen valasztani". So an advance grants the rank AND opens a talent
-- choice, where it used to make the reader trade one against the other.
--
-- What that trade cost was clarity, not balance. Both options moved the same ability forward,
-- both cost exactly one advance, and the panel could not say why anyone would take the rank
-- over the talent or the other way round -- so the only real decision in the game was being
-- spent on a question with no legible answer. Now the question is the one that has one: WHICH
-- talent this ability should grow into.
--
-- It spends no advance, so it cannot fail for want of one, and one gate is left on it: the line
-- must be OWNED, because rank 1 is found in the world and is never granted.
--
-- The LEVEL gate came off on 2026-09-16, with the visible skill scale. It used to refuse here,
-- and refusing threw the work away: a character whose next rank sits at level 40 kept pressing
-- the ability, kept succeeding, and kept getting nothing, with no way to see that was what was
-- happening. Now the rank is BANKED -- UnlockRank puts it in the pool, the character is told
-- "It becomes usable at level 40", and GrantBankedRanks hands it over on the level-up that
-- earns it. Practice is never wasted and the level-up has something behind it, which is the
-- whole point of showing the number.
local function GrantOwnRank(player, guid, lineId)
    if ((lineOwned[guid] or {})[lineId] or 0) < 1 then
        return false
    end
    local own = NextRankOfLine(guid, lineId)
    if own == nil then
        return false
    end
    -- UnlockRank writes the pool itself. Nothing here touches the practice pot -- no advance is
    -- spent and no rate moves -- so there is deliberately no treeDirty/TreeFlush: marking it
    -- would write a 27 KB column on every rank a character earns, for no change in it.
    return UnlockRank(player, guid, own, "practice")
end

-- What a line's earned practice may be spent on: the next rank of any talent that improves this
-- spell. The line's own rank is no longer among them -- GrantOwnRank above hands that over for
-- free on the same advance.
--
-- The ownership rules that used to differ between the two halves:
--
--   * A SPELL line has to be owned before practice may advance it. Rank 1 is the discovery and
--     the discovery is found in the world; without this test the first rank of every ability in
--     the game would be for sale, which is the one thing practice must never sell.
--   * A TALENT line does not, because the world does not carry one. talentcut.py took the last
--     622 talent rows out of tomes.data on 2026-09-08 -- a talent has no discovery rank to hunt,
--     it IS the reward for practising the spell it improves. The ownership test was written
--     when talents still dropped, and it survived that cut: measured on the shipped file, a
--     character maxing all sixteen ranks of Fireball over 2000 fights opened 0 of the 21 talent
--     lines bound to it. That is 621 of 622 talent lines -- 1892 ranks, 48% of the whole
--     collection -- reachable by nothing at all once the quest study token went.
--
-- So a talent's FIRST rank is offered like any other, and every rank after it follows the same
-- path. What still gates it is RankReady: the character's level, which is what spreads a talent
-- across a career exactly as it spreads a spell chain.
--
-- Capped, because the popular spells bind to far too many talents to put in a prompt: Fireball
-- improves eighteen of them.
local function PracticeOptions(player, guid, lineId)
    local out = {}
    local counts = lineOwned[guid] or {}
    -- Everything here is earned by PRESSING this line, so the line being pressed must be owned.
    -- That one test carries the discovery rule for both halves: the talents of an ability nobody
    -- has found are not on the table either.
    if (counts[lineId] or 0) < 1 then
        return out
    end
    for _, talentLine in ipairs(bindOf[lineId] or {}) do
        if #out < 5 then
            local nxt = NextRankOfLine(guid, talentLine)
            if RankReady(player, nxt) then
                out[#out + 1] = { rank = nxt, line = talentLine, kind = "talent" }
            end
        end
    end
    return out
end

-- What one line's offer looks like on the wire: the options, where each of them comes from,
-- and ONE number for the whole offer.
--
-- One number, because every option costs the same thing -- a single advance buys any one of
-- them. A number per option said otherwise, and said it wrongly: a talent has no press count of
-- its own (618 of the 622 bound talents fall back to PRACTICE_CASTS), so a talent showed ~4
-- beside its rank's ~99 and looked twenty-five times cheaper than something it costs exactly as
-- much as. This is the only build decision left in the game and the screen was lying about it.
-- Everything else this ability could ever be practised into, and why it is not on the table.
--
-- The offer itself is five entries: PracticeOptions walks bindOf[lineId] and takes the first five
-- the character can take. Seventeen talents are bound to Lightning Bolt, so from level 30 up the
-- reader was shown the same five and given no way to learn that the other twelve exist -- not that
-- they are coming, not what they are, not what it would take. A choice with a hidden two thirds is
-- not a choice being made, it is one being guessed at.
--
-- So the rest go down too, greyed, each with the level that would unlock it. 0 means "takeable,
-- but past the five this offer holds" -- which is a real answer as well, and the one that says the
-- ORDER in bind.data is what to argue with (tools/classless-web/binddesk.py).
local function LockedPayload(player, guid, lineId, opts)
    local shown = {}
    for i = 1, #(opts or {}) do
        shown[opts[i].line] = true
    end
    local ids, lines, lvls = {}, {}, {}
    for _, talentLine in ipairs(bindOf[lineId] or {}) do
        if not shown[talentLine] then
            local nxt = NextRankOfLine(guid, talentLine)
            -- nil means the chain is complete: nothing left to offer, so nothing to show.
            if nxt ~= nil then
                local n = #ids + 1
                ids[n], lines[n] = nxt, talentLine
                lvls[n] = RankReady(player, nxt) and 0 or (rankLevel[nxt] or 1)
            end
        end
    end
    return ids, lines, lvls
end

local function OfferPayload(guid, lineId, player)
    local o = pending[guid] and pending[guid][lineId]
    if o == nil then
        return nil
    end
    -- Levels for the takeable ones as well as for the locked ones. The client sorts the whole
    -- list by level and cannot work one out for itself: a spell's required level is in Spell.dbc,
    -- which does not ship to the client's Lua, and GetSpellInfo does not carry it.
    local ids, lines, lvls = {}, {}, {}
    for i = 1, #o.opts do
        ids[i], lines[i] = o.opts[i].rank, o.opts[i].line
        lvls[i] = rankLevel[o.opts[i].rank] or 1
    end
    local lockIds, lockLines, lockLvls
    if player then
        lockIds, lockLines, lockLvls = LockedPayload(player, guid, lineId, o.opts)
    end
    return ids, lines, RankLeft(guid, lineId, player), lockIds, lockLines, lockLvls, lvls
end

-- Take one option: charge the line that earned the practice and unlock what was chosen.
local function TakeOption(player, guid, lineId, opt)
    local bag = lineUp[guid]
    if bag == nil or (bag[lineId] or 0) < 1 then
        return false
    end
    if not UnlockRank(player, guid, opt.rank, "practice") then
        return false
    end
    bag[lineId] = bag[lineId] - 1
    TreeTouch(guid)
    if pending[guid] then
        pending[guid][lineId] = nil
    end
    TreeFlush(guid)
    return true
end

-- A line has earned something.
--
-- It buys on its own in exactly one case: there is only ONE thing this line could put the work
-- into, so there is nothing to decide. Anything else waits for an answer -- including when only
-- the cheaper option is within reach, because "take the rank now or save for the talent" is a
-- decision, and a mechanic that spends the pot the moment it can afford anything never lets
-- the reader make it. The first version tested "can it afford two things at once", and
-- measured 6 offers against 271 purchases.
local function OfferOrTake(player, guid, lineId)
    if pending[guid] == nil then
        return
    end
    local opts = PracticeOptions(player, guid, lineId)
    if #opts == 0 then
        pending[guid][lineId] = nil
        return
    end
    if ((lineUp[guid] or {})[lineId] or 0) < 1 then
        return -- nothing earned yet; nothing to show and nothing to take
    end
    if #opts == 1 then
        TakeOption(player, guid, lineId, opts[1])
        return
    end
    -- More than one thing to put the work into: everything goes on the table, affordable or
    -- not, and the reader decides when to spend.
    local standing = pending[guid][lineId]
    -- Re-sent only when the list of options has changed, so a line earning steadily does not
    -- push a message on every kill.
    if standing and standing.n == #opts then
        return
    end
    pending[guid][lineId] = { opts = opts, n = #opts }
    if standing == nil then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r Practice earned: open the "
            .. "collection and choose a talent to grow this ability into.")
    end
    local ids, lines, need, li, ll, lv, ol = OfferPayload(guid, lineId, player)
    -- The last argument is RAISE, and this call passes 0 on purpose: an advance lands on a KILL,
    -- so putting a full-screen decision up here interrupts whoever is still fighting the next
    -- pack. The chat line above is the whole notification during play; the choice keeps until
    -- the reader opens the collection or logs back in, and both of those paths pass 1.
    AIO.Handle(player, handlerName, "PracticeOffer", lineId, ids, lines, need, 1, 0,
        li, ll, lv, ol)
end

-- Raise anything still unspent again.
--
-- An offer lives in memory only, so logging out or reloading the UI used to leave an earned
-- advance sitting silently until that line next earned something -- which on a line the reader
-- had stopped using could be never. It does not need storing: the advances themselves are in
-- the trees column, and the offer is derivable from them.
local function ReofferPending(player, guid)
    for line, amount in pairs(lineUp[guid] or {}) do
        if amount >= 1 then
            OfferOrTake(player, guid, line)
        end
    end
end

-- Pay out one kill: one roll per ability that was used against the creature that died,
-- weighed by how many times it was actually pressed at it.
--
-- Exactly, and uncapped. A rare that took forty casts pays for forty, a trash mob that took
-- three pays for three, and it is safe to be that literal because a press was recorded against
-- the target it was aimed at -- so a fight that never ends never pays.
-- Spend one line's counted presses: roll each of them on its own and resolve every success.
--
-- Every success counts, rather than the fight asking "did at least one press teach something".
-- That test flattened a four-minute raid boss to barely more than a trash pull, so the system
-- preferred farming trash to fighting bosses -- the opposite of where the interesting play is.
--
-- What a success CANNOT do is pile up. An advance is resolved the moment it lands if there is
-- only one thing to put it into. Otherwise a level 20 character could bank progress on a line
-- whose ranks sit at 40, 42 and 44 and cash all three on the level-up that finally allowed them,
-- which is a windfall rather than practice.
--
-- A real choice holds one advance and waits, with no deadline on it. There used to be one -- an
-- offer standing since before this fight was resolved for the reader, taking the first option --
-- because the first option was the line's own NEXT RANK and an unanswered prompt therefore
-- stalled the line outright: 0.0 ranks in 600 fights for a character who never opened the panel,
-- against 11.0 for one who answered. The rank is granted on its own now (GrantOwnRank), so the
-- stall is gone and with it the reason to answer on the reader's behalf. An unanswered offer
-- costs the talent and nothing else.
-- One press, paid rather than rolled for. Returns how many RANK boundaries it crossed, which
-- is almost always none.
--
-- It says nothing. The whole fight is summed into one line by the caller, because a fight is
-- what the reader experienced and the presses inside it are not events they can tell apart --
-- practice is only ever credited at the kill, so all of a fight's presses land in the same
-- instant and used to arrive as a column of near-identical lines:
--
--     Your skill in Heroic Strike has increased to 2%.
--     Your skill in Heroic Strike has increased to 4%.
--     Your skill in Heroic Strike has increased to 6%.
--
-- which is one thing said three times.
-- `blocked` parks the bar instead of letting it cross. Nothing is thrown away: it stops one unit
-- short of the boundary, so the moment the banked rank is learned the next press crosses it.
local function CreditPress(guid, lineId, units, blocked)
    local bag = lineUnits[guid]
    if bag == nil then
        return 0
    end
    local before = bag[lineId] or 0
    local after = before + units
    if blocked then
        local boundary = (math.floor(before / PRACTICE_RANK_STORED) + 1) * PRACTICE_RANK_STORED
        if after >= boundary then
            after = boundary - 1
        end
    end
    bag[lineId] = after
    TreeTouch(guid)
    if blocked then
        return 0
    end
    return math.floor(after / PRACTICE_RANK_STORED) - math.floor(before / PRACTICE_RANK_STORED)
end

local function RollPresses(player, guid, line, presses, worth)
    local bag = lineUp[guid]
    -- Stored units are integers, and a press of a spammed ability is worth less than one of
    -- them, so the fraction is settled with the only roll left in the mechanic. Rounding it away
    -- instead would cost a Frostbolt reader nothing and a Corruption reader everything, which is
    -- exactly the per-ability bias the flat pricing exists to remove.
    local per = CastUnits(guid, line) * worth
    local whole = math.floor(per)
    local frac = per - whole
    local function mint()
        -- Only mint an advance if none is being held. Minting a second one and spending that
        -- left the held one in the bag for good, and a bag stuck at one with no offer against it
        -- is a line that can neither take nor offer: deadlocked. A scenario found it as "1.0
        -- ranks in 600 fights" where the fix was meant to give about half of 11.
        if (bag[line] or 0) < 1 then
            bag[line] = 1
            TreeTouch(guid)
        end
    end
    -- What a full rank buys, once the hundredth per cent of it is paid for. This is what one
    -- successful roll used to be in its entirety.
    local function advance()
        -- The rank first, and unconditionally: it costs no advance, so it happens whether or
        -- not there is a talent to choose between. A line whose talents are all taken or all
        -- still level-gated used to lose the whole rest of the fight here; now it simply
        -- keeps ranking up, which is what practising an ability should do.
        GrantOwnRank(player, guid, line)
        -- No talent this line can take yet -- all of them held, or all still level-gated.
        -- There is nothing to mint an advance for, since an advance now buys a talent and
        -- only a talent, but the press is not wasted: the rank above already took it.
        local opts = PracticeOptions(player, guid, line)
        if #opts == 1 then
            -- Nothing to decide: one talent this line could grow into, so it takes it.
            mint()
            TakeOption(player, guid, line, opts[1])
        elseif #opts > 1 then
            mint()
            -- Unconditionally, not only when the advance is new: this is also what recovers
            -- a line that is holding an advance with no offer standing against it.
            OfferOrTake(player, guid, line)
        end
        -- An unanswered offer is no longer resolved for the reader. It used to be, because
        -- the first option WAS the line's own next rank and leaving it unanswered stalled
        -- the line -- measured at 0.0 ranks in 600 fights for somebody who never opened the
        -- panel. Ranks arrive on their own now, so an unanswered prompt costs only what it
        -- should: the talent. mint() holds at one advance, so a line whose choice is never
        -- answered keeps ranking up and stops collecting talents until it is.
    end
    -- Where this line stood before the fight, so the whole of it can be reported as one move.
    local bag2 = lineUnits[guid] or {}
    -- Asked before the loop AND again after every rank this fight takes.
    --
    -- It used to be asked once, on the reasoning that "a rank cannot be learned in the middle of a
    -- fight, so the answer cannot change while this loop runs". Learning cannot -- BANKING can,
    -- and a line that starts the fight clear, crosses a boundary and receives a rank it is too low
    -- to use has been waiting from that instant. A verdict captured beforehand goes on saying no,
    -- and the bar rolls straight over the hold it was supposed to park at.
    --
    -- Found on Cicuka, level 7, 2026-09-19: Wrath rank 2 learned, rank 3 (level 14) banked, and
    -- the line sitting at 69232 units -- two boundaries crossed and a third bar a third full.
    local blocked = LineWaitsFor(player, guid, line) > 0
    local opened = ShownPercent(player, guid, line)
    local ranks = 0
    for _ = 1, presses do
        local paid = whole
        if frac > 0 and math.random() < frac then
            paid = paid + 1
        end
        if paid > 0 then
            -- The rank is taken the moment it is crossed and not at the end of the loop: it can
            -- open a talent choice, and a second rank crossed in the same fight has to find the
            -- first one already granted or NextRankOfLine hands out the same id twice.
            local crossed = CreditPress(guid, line, paid, blocked)
            for _ = 1, crossed do
                ranks = ranks + 1
                advance()
            end
            if crossed > 0 then
                -- advance() has just handed the rank over, and it may have gone into the POOL
                -- rather than into the spellbook. Re-asked here, so the next press of this same
                -- fight sees the hold: this is the line between "a rank landed and the bar
                -- starts again", which is right, and "the bar keeps starting again for ranks
                -- that cannot be used", which is what the hold exists to stop.
                blocked = LineWaitsFor(player, guid, line) > 0
            end
        end
    end
    local shown = ShownPercent(player, guid, line)
    if ranks > 0 then
        -- The rank's own line is the news and PoolAdd has just sent it, so this one only says
        -- where the NEW rank stands -- and stays quiet if that is nowhere yet. No gain is
        -- quoted: the move crossed a boundary, and "+97%" describes nothing the reader can use.
        if shown > 0 then
            AIO.Handle(player, handlerName, "SkillUp", line, shown, RankLeft(guid, line, player), 0,
                LineWaitsFor(player, guid, line))
        end
    elseif shown ~= opened then
        -- The distance rides along so an open panel stays right without asking for it: this is
        -- the only message a line gets between one panel open and the next.
        AIO.Handle(player, handlerName, "SkillUp", line, shown, RankLeft(guid, line, player),
            shown - opened, LineWaitsFor(player, guid, line))
    end
end

-- Pay out one kill.
--
-- The fight is everything pressed AT the creature that died, plus everything pressed with no
-- enemy behind it inside the same window (a heal, a self-buff) -- one fight, one budget, one
-- cap. Its length sets the budget, and no single ability may take more than PRACTICE_SHARE_CAP
-- of it, which is what makes a rotation the right way to play rather than a slower one.
--
-- `place` is PRACTICE_INSTANCE_BONUS if the fight happened in a dungeon or a raid, and 1
-- otherwise. It is the only thing here that cares where you are.
local function CreditPractice(player, guid, killedGuid, place)
    local bag, held = lineUp[guid], lineAt[guid]
    if bag == nil or held == nil then
        return
    end
    -- Tallies for anything last touched outside the window belong to a fight that is over --
    -- fled from, or given up on -- and holding them would let a pull from five minutes ago pay
    -- for a kill now. This is also the only thing that bounds the table.
    for target, tally in pairs(held) do
        if GetTimeDiff(tally.at or 0) > PRACTICE_WINDOW then
            held[target] = nil
        end
    end

    -- How long the fight lasted, and what was pressed in it. The longer of the two windows: a
    -- healer may never have touched the creature at all, and their own window is then the only
    -- record of how long they were at it.
    local hits, total, elapsed = {}, 0, 0
    local tally = killedGuid and held[killedGuid]
    if tally then
        -- First press until now, which is the kill: the whole fight, tail included.
        elapsed = GetTimeDiff(tally.first or 0)
        for line, n in pairs(tally) do
            if line ~= "at" and line ~= "first" then   -- the timestamps share the table
                hits[line] = n
                total = total + n
            end
        end
        held[killedGuid] = nil             -- a corpse cannot pay twice
    end
    local support = lineHit[guid]
    if support then
        if support.at and GetTimeDiff(support.at) <= PRACTICE_WINDOW then
            local span = GetTimeDiff(support.first or 0)
            if span > elapsed then
                elapsed = span
            end
            for line, n in pairs(support) do
                if line ~= "at" and line ~= "first" then
                    hits[line] = (hits[line] or 0) + n
                    total = total + n
                end
            end
        end
        -- Cleared whether or not it was still in the window: a fight's heals must not also pay
        -- for the next kill.
        lineHit[guid] = {}
    end
    if total <= 0 then
        return                             -- killed with the weapon alone, or nothing owned
    end

    -- A fight too short to have a rotation at all is exempt from both rules. Otherwise: scale
    -- the whole fight down to its budget, then hold every ability to its share of it.
    if total > PRACTICE_SHORT_FIGHT then
        local budget = (elapsed / 1000) * PRACTICE_PRESSES_PER_SEC
        if budget < PRACTICE_SHORT_FIGHT then
            budget = PRACTICE_SHORT_FIGHT
        end
        local scale = (total > budget) and (budget / total) or 1
        local ceiling = budget * PRACTICE_SHARE_CAP
        for line, n in pairs(hits) do
            local c = n * scale
            if c > ceiling then
                c = ceiling
            end
            hits[line] = math.floor(c + 0.5)
        end
    end

    -- How wide the rotation was, as an EFFECTIVE number of abilities: the presses inverted,
    -- total^2 / sum of squares. One button is 1.00, an even pair 2.00, an even five 5.00 -- and
    -- forty Fireballs with one Scorch woven in is 1.05, which is why this is not a count of
    -- distinct abilities. A token press earns a token bonus.
    --
    -- On the presses that COUNTED, after the budget and the share cap, so a spammer's discarded
    -- excess neither helps nor hurts.
    local sum, squares = 0, 0
    for _, n in pairs(hits) do
        sum = sum + n
        squares = squares + n * n
    end
    local rotation = 1
    if squares > 0 then
        rotation = 1 + PRACTICE_ROTATION_STEP * (((sum * sum) / squares) - 1)
        if rotation > PRACTICE_ROTATION_MAX then
            rotation = PRACTICE_ROTATION_MAX
        end
    end

    -- What this fight was worth to the reader, folded into their rolling estimate.
    --
    -- Marked for saving only when it crosses a tenth, not on every kill. Every kill would put
    -- the whole online population back to a write a minute, which is what the flush exists to
    -- avoid; riding along on the writes that real PROGRESS causes was the other idea and it is
    -- worse than it looks -- a character deep in a chain earns a rank an hour, so the estimate
    -- would never reach the database. A tenth fires perhaps fifteen times while it converges
    -- and then essentially never again.
    local worth = rotation * (place or 1)
    local was = practiceRate[guid] or 1
    local now = was + (worth - was) * PRACTICE_RATE_ALPHA
    practiceRate[guid] = now
    if math.floor(now * 10) ~= math.floor(was * 10) then
        TreeTouch(guid)
    end

    local order = {}
    for line in pairs(hits) do
        order[#order + 1] = line
    end
    -- Rolled in a FIXED order, not in whatever order pairs() hands the lines back.
    --
    -- It matters because the order decides who draws from math.random first, and because
    -- RollPresses stops a line at the point it puts a choice on the table -- so which ability of
    -- a rotation gets the offer out of one kill depended on Lua's hash layout, which is not
    -- stable between runs. That is invisible in play and ruinous to measure against: the
    -- eight-ability career in test_practice_scenarios.py moved between 62 and 73 fights from one
    -- run to the next with the same seeds, enough to swing the rotation-ladder check across its
    -- own threshold.
    --
    -- A sort of at most a handful of line ids per credited kill, on a path that already walks
    -- every tally twice.
    table.sort(order)
    for i = 1, #order do
        local line = order[i]
        local n = hits[line]
        if n > 0 then
            RollPresses(player, guid, line, n, worth)
        end
    end
end

-- Which ability the character is fighting with, and what it is aimed at. Only the press is
-- recorded here; the kill it leads to is what pays for it.
local function OnSpellCast(event, player, spell, skipCheck)
    if not Practising(player) then
        return
    end
    local guid = player:GetGUIDLow()
    local held = lineAt[guid]
    if held == nil then
        return
    end
    local id = spell and spell:GetEntry()
    local line = id and lineOfSpell[id]
    if line == nil then
        return
    end
    local ok, target = pcall(EnemyTarget, spell)
    if ok and target then
        -- Held against the enemy. The timestamp lives in the same table under a STRING key,
        -- which cannot collide with a line id and saves a second table per target on a path
        -- that runs for every button press on the server.
        local now = GetCurrTime()
        local tally = held[target]
        if tally == nil or GetTimeDiff(tally.at or 0) > PRACTICE_WINDOW then
            -- A new fight against this creature: the last one was abandoned long enough ago
            -- that its presses no longer belong to this one.
            tally = { first = now }
            held[target] = tally
        end
        tally.at = now
        tally[line] = (tally[line] or 0) + 1
    elseif player:IsInCombat() then
        -- Nothing enemy-facing behind this press: a heal, or an ability aimed at a friend. It
        -- joins the fight's own tally and is paid for by the next kill inside PRACTICE_WINDOW.
        --
        -- The combat check is the whole of what keeps that honest, and it was missing until
        -- 2026-09-19. CreditPractice has always described this bag as "everything pressed with
        -- no enemy behind it INSIDE THE SAME WINDOW", but the window is three minutes of wall
        -- clock and nothing else: standing in a field out of combat casting Rejuvenation on
        -- yourself filled the bag, and the first kill afterwards paid for all of it. Worse than
        -- the presses, the budget is set by how long the bag has been open -- elapsed is the
        -- LONGER of the fight and the support span -- so three minutes of idle healing bought a
        -- 180-press budget and handed the line its whole 40% share of it. Reported against
        -- Rejuvenation (774); it was true of every line a character could aim at a friend.
        --
        -- In combat is the right test rather than "has an enemy": a healer in a group may never
        -- touch the creature that dies, which is exactly the case the bag exists for, and
        -- healing someone who is fighting puts the healer in combat too.
        local support = lineHit[guid]
        if support then
            local now = GetCurrTime()
            if support.first == nil or GetTimeDiff(support.at or 0) > PRACTICE_WINDOW then
                lineHit[guid] = { first = now }
                support = lineHit[guid]
            end
            support.at = now
            support[line] = (support[line] or 0) + 1
        end
    end
end

-- ---- what the client may ask for and what it may spend -----------------------------------
--
-- The old panel's authenticated handlers went with the panel, so these are validated rather
-- than trusted: a pick has to name an option the SERVER put on the table for that line, and a
-- token has to be spent on a line that is genuinely unfound and within the character's level.
-- A modified client can send anything; the worst it can do is be told no.

-- The whole picture, pushed unconditionally. Split from the handler below because a PURCHASE
-- also has to push it, and the handler is rate-limited: two picks inside a second would
-- otherwise leave the panel showing the state before the first one.
local function SendPracticeState(player, guid)
    -- Every line holding an unspent advance, and how many presses the one after it wants.
    local lines, amounts, needs = {}, {}, {}
    for line, amount in pairs(lineUp[guid]) do
        if amount >= 1 then
            local n = #lines + 1
            lines[n], amounts[n] = line, math.floor(amount)
            needs[n] = RankLeft(guid, line, player)
        end
    end
    -- Anything earned and not yet answered is raised again first, so opening the panel is one
    -- of the two places a choice left standing across a logout comes back (the other is login).
    ReofferPending(player, guid)
    local waiting = {}
    for line in pairs(pending[guid] or {}) do
        waiting[#waiting + 1] = line
    end

    -- The offers themselves travel WITH the state, batched into one message, rather than the
    -- client naming each one back at us.
    --
    -- It used to send a PracticeAsk per waiting line in a single burst, and "ask" shares the
    -- twenty-per-five-seconds allowance with opening a line -- so a reader returning to more than
    -- twenty standing choices had the rest dropped in silence: a marker on the row with no
    -- options behind it and no prompt raised, until they closed the panel and opened it again.
    -- The server is holding every one of them already, and ReofferPending has just refreshed
    -- them, so asking was never more than a round trip.
    --
    -- One AIO.Msg rather than one Handle per line, for the same reason CollIndex batches: a
    -- hundred separate messages to say a hundred small things is most of the cost.
    local msg = nil
    for i = 1, #waiting do
        local ids, froms, need, li, ll, lv, ol = OfferPayload(guid, waiting[i], player)
        if ids then
            msg = msg or AIO.Msg()
            msg:Add(handlerName, "PracticeOffer", waiting[i], ids, froms, need, 1, 1,
                li, ll, lv, ol)
        end
    end
    if msg then
        msg:Send(player)
    end

    -- Every line the character has ever practised, and how far along it is. Sent whole rather
    -- than per row on demand: it is two numbers a line, a few dozen lines for a reader who
    -- fights with a rotation, and the panel would otherwise have to ask for each row it draws.
    local skillLines, skillValues, skillLeft = {}, {}, {}
    for line, units in pairs(lineUnits[guid] or {}) do
        if units >= 1 then
            local n = #skillLines + 1
            skillLines[n], skillValues[n] = line, ShownPercent(player, guid, line)
            -- The distance travels with the percentage because the two answer different halves
            -- of the same question -- "how far in" and "how much left" -- and a row that shows
            -- one without the other invites the reader to guess the other from it, which the
            -- curve makes wrong: 50% is a third of the way through the work, not half.
            skillLeft[n] = RankLeft(guid, line, player)
        end
    end

    -- The three token slots that used to sit between `waiting` and `needs` are gone with the
    -- quest route. The client reads this positionally, so the arguments were closed up rather
    -- than left as zeroes: a wire that still carries a number nothing can earn is a wire that
    -- invites the panel to draw it.
    AIO.Handle(player, handlerName, "PracticeState", lines, amounts, waiting, needs,
        skillLines, skillValues, skillLeft)
end

function Handlers.PracticeState(player)
    local guid = player:GetGUIDLow()
    EnsureLoaded(player)
    if lineUp[guid] == nil then
        return
    end
    if not Throttle(guid, "state", COLL_STATE_LIMIT, COLL_STATE_WINDOW) then
        return
    end
    SendPracticeState(player, guid)
end

-- Five lines worth hunting next.
--
-- 1,180 lines and a list of what you are missing is a catalogue, not a goal. The server already
-- knows everything needed to narrow it: what the character owns, what its level allows, where
-- each line's rank 1 is found, and -- the part a static list could never have -- which trees it
-- has actually been fighting in, so the suggestion sits next to what the reader already does
-- rather than being the alphabetically first thing they lack.
function Handlers.CollSuggest(player)
    if not Ours(player) then
        return
    end
    EnsureLoaded(player)
    local guid = player:GetGUIDLow()
    if pools[guid] == nil then
        return
    end
    if not Throttle(guid, "suggest", COLL_SUGGEST_LIMIT, COLL_SUGGEST_WINDOW) then
        return
    end
    local level, counts = player:GetLevel(), lineOwned[guid] or {}
    local warm = {}
    for line in pairs(lineUp[guid] or {}) do
        local tree = treeOfLine[line]
        if tree then
            warm[tree] = true
        end
    end
    local out = {}
    for lineId, chain in pairs(ranksOfLine) do
        local first = chain[1]
        local t = first and tomeOf[first]
        -- Only what is actually gettable: it has a source in the world, the level is met, and
        -- the carrier is not so far above the character that the hunt is a death sentence.
        if t and t[2] ~= "s" and (counts[lineId] or 0) == 0
            and level >= (rankLevel[first] or 1) and (t[7] or 0) <= level + 3 then
            out[#out + 1] = { lineId, warm[treeOfLine[lineId]] and 1 or 0, t }
        end
    end
    -- A tree the reader already practises first; within that, the carrier closest to their own
    -- level, which is both the safest fight and the one nearest their questing.
    table.sort(out, function(a, b)
        if a[2] ~= b[2] then
            return a[2] > b[2]
        end
        return (a[3][7] or 0) > (b[3][7] or 0)
    end)
    local ids, srcs, places, kinds = {}, {}, {}, {}
    for i = 1, math.min(5, #out) do
        local e = out[i]
        ids[i], srcs[i], places[i], kinds[i] = e[1], e[3][4], e[3][5], e[3][2]
    end
    AIO.Handle(player, handlerName, "CollSuggest", ids, srcs, places, kinds)
end

function Handlers.PracticeAsk(player, lineId)
    local guid = player:GetGUIDLow()
    EnsureLoaded(player)
    if lineUp[guid] == nil or type(lineId) ~= "number" then
        return
    end
    -- Take any rank of the line and answer for the LINE. The panel always had the first rank's id
    -- to hand so this never came up; /tomes pick does not -- somebody shift-clicking Lightning Bolt
    -- (Rank 4) out of their spellbook sends 15208, and bindOf has nothing under that. One lookup
    -- here beats making every caller know the difference.
    lineId = lineOfSpell[lineId] or lineId
    -- Sent alongside every line open, so it needs the same allowance as one.
    if not Throttle(guid, "ask", COLL_LINE_LIMIT, COLL_LINE_WINDOW) then
        return
    end
    -- Recomputed rather than replayed: the character may have levelled or found something
    -- since the offer was made, which changes both the options and their prices.
    if pending[guid] and pending[guid][lineId] then
        local ids, lines, need, li, ll, lv, ol = OfferPayload(guid, lineId, player)
        -- RAISE 1: this reply is an answer to the reader opening the line, so the prompt is
        -- something they asked for rather than something that took the screen from them.
        AIO.Handle(player, handlerName, "PracticeOffer", lineId, ids, lines, need, 1, 1,
            li, ll, lv, ol)
        return
    end
    -- No standing offer: answer with what this line COULD put the work into and how many
    -- presses that will take, so the panel can show the distance before anything is earned.
    -- The last slot is 0 -- nothing here is takeable, there is no advance to spend.
    local opts = PracticeOptions(player, guid, lineId)
    local ids, lines = {}, {}
    for i = 1, #opts do
        ids[i], lines[i] = opts[i].rank, opts[i].line
    end
    -- The REAL opts, not an empty list. Handing LockedPayload {} made it return every bound
    -- talent including the ones already in `ids`, so Convection arrived twice -- once as an
    -- option and once as "Not offered" underneath it. LockedPayload's whole job is to describe
    -- what is NOT in the offer, so it has to be told what is.
    local li, ll, lv = LockedPayload(player, guid, lineId, opts)
    local lvls = {}
    for i = 1, #opts do
        lvls[i] = rankLevel[opts[i].rank] or 1
    end
    AIO.Handle(player, handlerName, "PracticeOffer", lineId, ids, lines,
        RankLeft(guid, lineId, player), 0, 0, li, ll, lv, lvls)
end

-- What the action bars are looking at.
--
-- The client can see that slot 3 holds spell 285 and nothing else: it does not carry tomes.data,
-- so it cannot know that 285 is the third rank of Heroic Strike, and the percentage it wants to
-- draw belongs to the LINE rather than to the rank sitting on the bar. So it sends the spell ids
-- it found and gets back, for each one it may draw, which line it belongs to and where that line
-- stands.
--
-- Asked once when the bars change rather than per button per frame: the answer only moves when a
-- slot is rearranged or a rank is learned, and SkillUp keeps the percentage current in between.
--
-- Ids it cannot place are simply left out of the answer -- a profession spell, a mount, a rank of
-- something the character was given outside the collection. The client draws nothing for those,
-- which is right: there is no practice behind them.
local BARS_LIMIT, BARS_WINDOW, BARS_MAX_IDS = 6, 5, 240
local BARS_MAX_CHARS = 2048

-- What the server knows, asked from the client and answered to the client.
--
-- /tomes barsdebug could only ever report the CLIENT's half -- which buttons it found, which
-- spell each holds, and whether a line ever came back. When the answer is "asked, no answer",
-- that is where it stopped and the next step was reading Lua by eye. This closes it: the same
-- command now asks the server to describe its own state on the same four things that can make
-- PracticeBars return nothing, and prints the reply beside the client's half.
--
-- Deliberately outside the "bars" throttle -- it is a diagnostic a person types, not something a
-- sweep sends -- but on a throttle of its own so it cannot be used as an amplifier.
function Handlers.PracticeProbe(player, ids)
    local guid = player:GetGUIDLow()
    if not Throttle(guid, "probe", 4, 10) then
        return
    end
    -- Reported BEFORE the lazy load, or the probe would answer for the state it just repaired
    -- rather than for the one the player was in.
    local wasLoaded = lineUnits[guid] ~= nil
    EnsureLoaded(player)
    local known = 0
    for _ in pairs(lineOfSpell) do
        known = known + 1
    end
    local asked = {}
    for digits in string.gmatch(type(ids) == "string" and ids or "", "%d+") do
        local id = tonumber(digits)
        asked[#asked + 1] = id .. "=" .. tostring(lineOfSpell[id])
        if #asked >= 6 then
            break
        end
    end
    AIO.Handle(player, handlerName, "PracticeProbeInfo",
        guid,
        player:GetClass(),
        tostring(Ours(player)),
        tostring(wasLoaded),
        known,
        table.concat(asked, " "),
        SERVER_BUILD)
end

function Handlers.PracticeBars(player, ids)
    local guid = player:GetGUIDLow()
    -- A comma-separated string of spell ids. Validated rather than trusted, like every other
    -- handler here: a modified client can send anything, and the worst this can do is describe
    -- somebody else's spell ids back to the sender.
    if type(ids) ~= "string" or #ids > BARS_MAX_CHARS or not EnsureLoaded(player) then
        return
    end
    if not Throttle(guid, "bars", BARS_LIMIT, BARS_WINDOW) then
        return
    end
    local outIds, outLines, outPct, outLeft, outHold = {}, {}, {}, {}, {}
    local seen = {}
    for digits in string.gmatch(ids, "%d+") do
        if #outIds >= BARS_MAX_IDS then
            break
        end
        local rankId = tonumber(digits)
        local line = rankId and lineOfSpell[rankId]
        -- One entry per ID, and an id is answered once: two ranks of the same ability on two
        -- bars each get their own row, because the client draws per button and looks the answer
        -- up by what the button is holding.
        if line and not seen[rankId] then
            seen[rankId] = true
            local n = #outIds + 1
            outIds[n], outLines[n] = rankId, line
            outPct[n] = ShownPercent(player, guid, line)
            outLeft[n] = RankLeft(guid, line, player)
            -- 0 for every line that is simply working. Only a held one carries a level, and it is
            -- the whole of what the tooltip needs to say "waiting" instead of "nearly there".
            outHold[n] = LineWaitsFor(player, guid, line)
        end
    end
    AIO.Handle(player, handlerName, "PracticeBarInfo", outIds, outLines, outPct, outLeft, outHold)
end

function Handlers.PracticePick(player, lineId, rankId)
    local guid = player:GetGUIDLow()
    EnsureLoaded(player)
    if lineUp[guid] == nil or type(lineId) ~= "number" or type(rankId) ~= "number" then
        return
    end
    local o = pending[guid] and pending[guid][lineId]
    -- No standing offer is not an error: a line with only one option never made one, and the
    -- reader may be answering a prompt the server has since resolved.
    local opts = o and o.opts or PracticeOptions(player, guid, lineId)
    for i = 1, #opts do
        if opts[i].rank == rankId then
            if TakeOption(player, guid, lineId, opts[i]) then
                SendPracticeState(player, guid)
            end
            return
        end
    end
end

-- Purely cosmetic feedback for reading a tome/manual -- no gameplay effect. 28288
-- "Omarion's Secrets" carries SpellVisualID 222, the same golden book-learning glow that
-- spell 483 'Learning' plays at a trainer, but unlike 483 it is inert: Effect_1 =
-- SPELL_EFFECT_DUMMY, every other effect slot, EffectAura and EffectTriggerSpell are 0,
-- duration 0, instant, self-targeted, no cooldown or reagent, and no spell_script_names,
-- spell_dbc, spell_scripts, spell_linked_spell or disables row. So it cannot apply a
-- buff/debuff, deal damage, move the player, or run any script.
--
-- It was 63727 "Test Cosmetic DGK" until 2026-08-18, which produced nothing at all: its
-- SpellVisualID_1 and _2 are both 0, and the id is missing from the client's Spell.dbc
-- entirely (it only exists in the acore_world.spell_dbc table), so the client had nothing
-- to render even in principle.
--
-- Any replacement must be visible client-side -- check the id is present in
-- data/dbc/Spell.dbc, not just in acore_world.spell_dbc -- and have a non-zero
-- SpellVisualID_1. `.cast 28288` in-game to preview.
local TOME_LEARN_VISUAL_SPELL = 28288
local function PlayTomeLearnEffect(player)
    player:CastSpell(player, TOME_LEARN_VISUAL_SPELL, true)
end

-- Using a tome. Returning false suppresses the item's own (placeholder) spell cast:
-- ALE::OnUse only skips the cast when the handler explicitly returns false, and the default
-- with no handler bound is true, so unrelated items keep working normally.
local function OnTomeUse(event, player, item)
    if not Ours(player) then
        return false
    end
    local guid = player:GetGUIDLow()
    local entry = item:GetEntry()
    if pools[guid] == nil then
        return false
    end

    local rankId = rankOfItem[entry]
    if rankId == nil then
        return false
    end
    if poolSet[guid][rankId] then
        player:SendBroadcastMessage(
            "|cffff5555[ClassLess]|r You already know this rank. The tome is untouched.")
        return false
    end
    UnlockRank(player, guid, rankId)
    player:RemoveItem(entry, 1)
    player:SaveToDB()
    PlayTomeLearnEffect(player)
    return false
end

-- RegisterItemEvent RAISES A LUA ERROR when the item is not in item_template -- see
-- LuaEngine.cpp, it calls luaL_error, which longjmps and aborts the whole chunk. The items
-- live in data/sql/custom/, applied separately from this file, so an un-applied or
-- half-applied SQL install would otherwise take every handler BELOW this loop with it.
-- Degrade to a readable warning instead.
local function RegisterItemUse(itemId, handler)
    return pcall(RegisterItemEvent, itemId, 2, handler) -- 2 = ITEM_EVENT_ON_USE
end

local tomesBound, tomesMissing = 0, 0
for itemId in pairs(rankOfItem) do
    if RegisterItemUse(itemId, OnTomeUse) then
        tomesBound = tomesBound + 1
    else
        tomesMissing = tomesMissing + 1
    end
end
if tomesMissing > 0 then
    print("[ClassLess] WARNING: " .. tomesMissing .. " of " .. (tomesBound + tomesMissing)
        .. " tome items are missing from item_template. Run "
        .. "data/sql/custom/classless_rank_items.sql (and classless_rank_loot.sql, or "
        .. "nothing will drop). Everything else has loaded normally.")
end

-- There is no proficiency manual item any more, and so no ITEM_EVENT_ON_USE handler for one.
-- Everyone has every proficiency from level one; the 21 items and their loot rows are removed
-- from the world by data/sql/custom/classless_prof_retire.sql.

-- =====================================================================================
-- Bounties: kill-quests that point players at a named creature, offered by a letter that drops
-- in dungeons and raids. The bounty is the pity path next to the loot roll -- it hands over one
-- of the target's OWN tomes (TomesOfCreature, read off the group tables), so an unlucky streak
-- has a ceiling measured in kills. Real
-- quest_template rows (classless_bounty_quests.sql), so they track kill progress in the normal
-- quest log; rewarded here (XP/gold only, no item) the instant kill credit lands, since none
-- of them has -- or needs -- a turn-in NPC.
-- =====================================================================================

-- Bounty letters come out of dungeons and raids only. In the open world a bounty was worth
-- 8 kills of a common target against the ~30 a 3.3% loot roll costs, which made the pity path
-- the fast path and left the drop table decorative. Inside an instance the letter costs group
-- time and travel to earn, so the world roll is what a solo character lives on.
local BOUNTY_DROP_CHANCE = 0.10 -- on a credited kill of a non-tome-carrier, instances only
local BOUNTY_PER_INSTANCE = 3    -- letters per player per instance id, counted for every
                                 -- instance the player has been in this session
local BOUNTY_DRAW_ATTEMPTS = 8   -- fallback (any zone) draw, same as before this zone/rank pass
local ZONE_ELITE_ATTEMPTS = 4    -- first pass: same zone, rank >= 1 (elite/rareelite/worldboss/rare)
local ZONE_ANY_ATTEMPTS = 4      -- second pass: same zone, any rank
-- The letter is earned inside, but points outside: a bounty drawn from the dungeon the player
-- is standing in would only be completable by staying there with the group. Set this false to
-- have instance kills hand out bounties on that same instance's carriers instead.
local BOUNTY_TARGETS_ANYWHERE = true

-- Sorted with a per-level cutoff index, because the old version walked all ~1650 bounties
-- per drop, calling GetQuestStatus and GetQuestRewardStatus on each. Sorted by the TARGET's
-- level, with a cumulative index, so eligibility by level is a range and only the few actually
-- drawn cost a quest-state lookup.
--
-- "Eligible" means the target is within reach -- srcLevel <= player level + 2, the same little
-- headroom the game normally tolerates fighting slightly-above-level mobs -- so nobody gets
-- pointed at something wildly out of a fresh character's league.
local bountyDraw = {}

-- Same targets, split by b[4] ("place"). GrantRandomBounty tries these first so a bounty
-- points at something in the zone the player is actually standing in, rather than sending them
-- across the continent (or into a still-locked expansion zone, which is what TBC_ZONES/
-- WOTLK_ZONES below used to have to guard against on every single draw).
local bountyDrawByZone = {}

local function BuildBountyPool()
    local byZone = {}
    for _, b in pairs(bountyOf) do
        table.insert(bountyDraw, b)
        local zone = b[4]
        if byZone[zone] == nil then
            byZone[zone] = {}
        end
        table.insert(byZone[zone], b)
    end
    table.sort(bountyDraw, function(a, b) return a[5] < b[5] end)
    local cutoff, i = {}, 1
    for level = 1, 85 do
        while i <= #bountyDraw and bountyDraw[i][5] <= level do
            i = i + 1
        end
        cutoff[level] = i - 1
    end
    bountyDraw.cutoff = cutoff

    for zone, list in pairs(byZone) do
        table.sort(list, function(a, b) return a[5] < b[5] end)
        local zcutoff, zi = {}, 1
        for level = 1, 85 do
            while zi <= #list and list[zi][5] <= level do
                zi = zi + 1
            end
            zcutoff[level] = zi - 1
        end
        list.cutoff = zcutoff
        bountyDrawByZone[zone] = list
    end
end
BuildBountyPool()

-- Tries `attempts` random draws out of `list` (must carry a per-level .cutoff, see
-- BuildBountyPool), skipping anything below `minRank` or already active/completed for
-- `player`. Grants and returns true on the first hit; false if nothing panned out.
local function TryGrantBountyFrom(player, list, level, minRank, attempts)
    if list == nil then
        return false
    end
    local n = list.cutoff[level] or 0
    if n == 0 then
        return false
    end
    for _ = 1, attempts do
        local b = list[math.random(n)]
        if b[6] >= minRank then
            local questId = b[2]
            if player:GetQuestStatus(questId) == 0 -- QUEST_STATUS_NONE: not active, not done
                and not player:GetQuestRewardStatus(questId) then
                if GiveItem(player, b[1]) then
                    return true
                end
            end
        end
    end
    return false
end

-- Returns true when a letter actually went into the player's bags.
local function GrantRandomBounty(player, skipZonePass)
    local level = player:GetLevel() + 2
    if level > 85 then level = 85 end

    -- Same-zone passes first: rank >= 1 (elite/rareelite/worldboss/rare) biased over normal
    -- trash, but not exclusive to it -- if the zone has no eligible elite target the second
    -- pass falls back to any rank in that same zone. A player standing in a given zone has
    -- already crossed whatever progression gate opened it, so neither pass needs the
    -- TBC_ZONES/WOTLK_ZONES check the fallback below still carries.
    --
    -- Skipped for a letter earned inside an instance: the zone there is the instance itself,
    -- so the zone pass would hand out a bounty only completable without leaving the group.
    if not skipZonePass then
        local zone = GetAreaName(player:GetZoneId())
        local zoneList = bountyDrawByZone[zone]
        if TryGrantBountyFrom(player, zoneList, level, 1, ZONE_ELITE_ATTEMPTS) then
            return true
        end
        if TryGrantBountyFrom(player, zoneList, level, 0, ZONE_ANY_ATTEMPTS) then
            return true
        end
    end

    -- Fallback: anywhere in the game, same as before the zone pass existed above. Still has to
    -- guard against sending a not-yet-progressed character at a locked TBC/WotLK zone.
    local n = bountyDraw.cutoff[level] or 0
    if n == 0 then
        return false
    end
    for _ = 1, BOUNTY_DRAW_ATTEMPTS do
        local b = bountyDraw[math.random(n)]
        local place = b[4]
        local locked = (WOTLK_ZONES[place] and not player:GetQuestRewardStatus(WOTLK_PROGRESSION_QUEST))
            or (TBC_ZONES[place] and not player:GetQuestRewardStatus(TBC_PROGRESSION_QUEST))
        if not locked then
            local questId = b[2]
            if player:GetQuestStatus(questId) == 0 -- QUEST_STATUS_NONE: not active, not done
                and not player:GetQuestRewardStatus(questId) then
                if GiveItem(player, b[1]) then
                    return true
                end
            end
        end
    end
    return false
end

-- The bounty payout: one tome off the target creature that the killer has not learned yet.
-- Picked at random among the unknown ones (reservoir sample, one pass) so a creature carrying
-- several does not always hand over the same book. Returns nil when the player already knows
-- every rank the target carries -- then the bounty is just the xp and gold it always was.
--
-- This is the counterweight to the low drop chances in classless_tome_chances.sql: the loot
-- roll is the fast path, the bounty is the guaranteed one, so an unlucky streak has a ceiling
-- measured in kills rather than in hours.
local function PickUnknownTome(player, entry)
    local list = TomesOfCreature(entry)
    if list == nil then
        return nil
    end
    local pick, seen = nil, 0
    for i = 1, #list do
        if not player:HasSpell(list[i][2]) then
            seen = seen + 1
            if math.random(seen) == 1 then
                pick = list[i]
            end
        end
    end
    return pick
end

-- One hook for both drops and the bounty reward. PLAYER_EVENT_ON_KILL_CREATURE (7) fires once
-- per player CREDITED for the kill (i.e. XP share, not just the killing blow), which is
-- exactly "every mob that yields xp" -- no separate loot-table edits needed for the ~every
-- creature in the game this should cover. It is also one of the hottest hooks on the server,
-- which is why this was merged from two registrations into one.
-- How far from the corpse a group member still counts as having been there. The core's own
-- kill-credit radius for quests is 100 yards on the same map, and matching it keeps "I was in
-- the fight" mean the same thing here as it does for the quest credit this rides on.
local KILL_CREDIT_RANGE = 100

-- --------------------------------------------------------------------------------------
-- Kill log: which creatures the world actually kills, and at what level.
--
-- The drop chance of every tome row is exact in the database. What no calculation can supply
-- is whether a carrier is anywhere near the path of play -- a 5% tome on a creature nobody
-- fights is a 0% tome. Playerbots are the sampling engine for that, and they can only measure
-- this half: they PASS on every tome (ItemUsageValue is ITEM_USAGE_NONE for the item range,
-- and they are excluded as bounty recipients), so nothing about the payout can be read from
-- their bags.
--
-- Counts are aggregated in memory and flushed on a timer. One row per kill would be millions
-- of inserts over a long run for an answer that is a GROUP BY anyway.
local KILL_LOG_FLUSH_MS = 60000
-- Pickups of ANY item since the last flush. See OnLootItem for why it exists.
lootAll = 0
lootByLevel = {}
local killLog = {}          -- "entry:level:isbot" -> corpses since the last flush
local killCredit = {}       -- the same key -> how many players those corpses could pay
local killLogPending = 0

-- `credits` is the denominator the loot log has to be divided by, and it stopped being the same
-- number as `kills` on 2026-09-14.
--
-- A corpse is one kill: the hook fires for the killing blow only, so in a five-man party four
-- members never reach this function at all. That was the right denominator while a tome dropped
-- once and the party rolled for it -- one corpse, one book, one winner. With ITEM_FLAG_MULTI_DROP
-- every eligible member now gets their OWN copy, so one corpse can pay five pickups, and
-- pickups/kills would read five times the true per-player rate.
--
-- So each corpse also adds the size of the killer's group. It is an approximation in one
-- direction only: it counts members who were out of range or already knew the rank, so the
-- measured per-player rate is a floor, never an overstatement.
CharDBQuery("CREATE TABLE IF NOT EXISTS `classless_killlog` ("
    .. "`entry` INT UNSIGNED NOT NULL, `killer_level` TINYINT UNSIGNED NOT NULL, "
    .. "`is_bot` TINYINT UNSIGNED NOT NULL, `kills` BIGINT UNSIGNED NOT NULL DEFAULT 0, "
    .. "`credits` BIGINT UNSIGNED NOT NULL DEFAULT 0, "
    .. "PRIMARY KEY (`entry`, `killer_level`, `is_bot`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4")
CharDBQuery("CREATE TABLE IF NOT EXISTS `classless_lootcount` (`id` TINYINT UNSIGNED NOT NULL, "
    .. "`picks` BIGINT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY (`id`)) "
    .. "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4")
-- The same count again, split by the LOOTER's level, because the single running total above
-- cannot answer "what share of loot did the bots collect in band 10-19". On 2026-09-15 that gap
-- made the one band that looked wrong impossible to check: the only way to get a per-band
-- collection rate was to snapshot the global counter at each band boundary and difference the
-- readings, and a reading taken 35 minutes before the cohort actually crossed into the band
-- silently folded the previous band's pickups into the answer. With this table any band, in any
-- past window, is a WHERE clause instead of a subtraction.
CharDBQuery("CREATE TABLE IF NOT EXISTS `classless_lootcount_lvl` ("
    .. "`level` TINYINT UNSIGNED NOT NULL, `picks` BIGINT UNSIGNED NOT NULL DEFAULT 0, "
    .. "PRIMARY KEY (`level`)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4")

local function KillLogRecord(killer, killed)
    -- The key carries the KILLER's level, not the creature's: what matters is whether the
    -- carrier is being fought by someone the rank is meant for. The creature's own level is
    -- static and already known from creature_template.
    local key = killed:GetEntry() .. ":" .. killer:GetLevel() .. ":"
        .. (killer:IsBot() and 1 or 0)
    local group = killer:GetGroup()
    local share = 1
    if group then
        share = group:GetMembersCount() or 1
        if share < 1 then
            share = 1
        end
    end
    killLog[key] = (killLog[key] or 0) + 1
    killCredit[key] = (killCredit[key] or 0) + share
    killLogPending = killLogPending + 1
end

local function KillLogFlush()
    if killLogPending == 0 and (lootAll or 0) == 0 and next(lootByLevel) == nil then
        return
    end
    -- ON DUPLICATE KEY so a restart or a second run adds to the sample instead of replacing
    -- it. Chunked because a busy minute on a full bot population is thousands of distinct
    -- (creature, level) pairs and one statement per pair would be the thing this avoids.
    local vals, n = {}, 0
    for key, count in pairs(killLog) do
        local entry, level, bot = key:match("^(%d+):(%d+):(%d+)$")
        n = n + 1
        vals[n] = "(" .. entry .. "," .. level .. "," .. bot .. "," .. count
            .. "," .. (killCredit[key] or count) .. ")"
        if n == 500 then
            CharDBExecute("INSERT INTO `classless_killlog` VALUES " .. table.concat(vals, ",")
                .. " ON DUPLICATE KEY UPDATE `kills` = `kills` + VALUES(`kills`), "
                .. "`credits` = `credits` + VALUES(`credits`)")
            vals, n = {}, 0
        end
    end
    if n > 0 then
        CharDBExecute("INSERT INTO `classless_killlog` VALUES " .. table.concat(vals, ",")
            .. " ON DUPLICATE KEY UPDATE `kills` = `kills` + VALUES(`kills`), "
            .. "`credits` = `credits` + VALUES(`credits`)")
    end
    if lootAll and lootAll > 0 then
        CharDBExecute("INSERT INTO `classless_lootcount` (id, picks) VALUES (1, " .. lootAll
            .. ") ON DUPLICATE KEY UPDATE `picks` = `picks` + VALUES(`picks`)")
        lootAll = 0
    end
    local lvlVals = {}
    for lvl, n in pairs(lootByLevel) do
        lvlVals[#lvlVals + 1] = "(" .. lvl .. "," .. n .. ")"
    end
    if #lvlVals > 0 then
        CharDBExecute("INSERT INTO `classless_lootcount_lvl` (level, picks) VALUES "
            .. table.concat(lvlVals, ",")
            .. " ON DUPLICATE KEY UPDATE `picks` = `picks` + VALUES(`picks`)")
        lootByLevel = {}
    end
    killLog, killCredit, killLogPending = {}, {}, 0
end
CreateLuaEvent(KillLogFlush, KILL_LOG_FLUSH_MS, 0)

-- THE LOOT LOG -- the half of the measurement the kill log cannot reach.
--
-- The kill log answers "is this carrier ever fought". It cannot answer "did the tome actually
-- come out", because on a bot population nothing ever picks one up: playerbots pass on every
-- tome (ItemUsageValue is ITEM_USAGE_NONE for the item range), so nothing is ever taken out of
-- a corpse to be counted. This once said corpse loot is not readable from Eluna at all; that
-- was wrong even then -- LootMethods.h exposes GetItems, AddItem and RemoveItem, which is what
-- ShowcastDecideLoot rewrites the corpse with. What is still missing is a bot that LOOTS, and
-- reading a corpse nobody opens would not measure the drop side anyway.
--
-- A REAL player in the group is the missing sensor, and mod-dungeon-clear is what makes one
-- cheap: the tank bot drives the clear, the player walks along and loots. That is also the only
-- way to reach the 58 boss-only rare buffs, which no bot run has ever been able to sample --
-- bots never form a dungeon group on their own (the LFG path is blocked seven ways).
--
-- One row per tome picked up, not an aggregate: the volume is a handful an hour at most, and
-- the questions here are about single events (which boss, how deep into the run, at what level)
-- rather than about a rate.
local LOOT_LOG_HINT_SECS = 180
-- Which creature the loot probably came from. There is no loot-source API, so this is the last
-- creature the player's own group killed with them in credit range, and the row records how
-- many seconds old that is so the analysis can decide whether to believe it. A corpse looted
-- three minutes after the pull carries no usable attribution and is written with entry 0.
local lastKill = {}         -- player guid low -> { creature entry, os.time() }

CharDBQuery("CREATE TABLE IF NOT EXISTS `classless_lootlog` ("
    .. "`id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, `at` DATETIME NOT NULL, "
    .. "`guid` INT UNSIGNED NOT NULL, `level` TINYINT UNSIGNED NOT NULL, "
    .. "`rank` INT UNSIGNED NOT NULL, `item` INT UNSIGNED NOT NULL, "
    .. "`count` SMALLINT UNSIGNED NOT NULL, `map` SMALLINT UNSIGNED NOT NULL, "
    .. "`instance` INT UNSIGNED NOT NULL, `area` INT UNSIGNED NOT NULL, "
    .. "`from_entry` INT UNSIGNED NOT NULL, `from_age` SMALLINT UNSIGNED NOT NULL, "
    .. "PRIMARY KEY (`id`), KEY `k_rank` (`rank`), KEY `k_from` (`from_entry`)) "
    .. "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4")

local function OnLootItem(event, player, item, count)
    if player == nil or item == nil then
        return
    end
    -- The hook is documented as (event, player, item, count) with an Item object, but a number
    -- costs one branch to accept and saves a silent no-op if that ever changes.
    local itemId = type(item) == "number" and item or item:GetEntry()
    -- Every pickup of ANY item is counted, not just the tomes, and the reason is a measurement
    -- one. classless_lootlog can only ever show what somebody took OUT of a corpse, so a corpse
    -- nobody opens looks exactly like a corpse that dropped nothing. Against classless_killlog
    -- this counter separates the two: pickups per kill says how much of the world's loot the
    -- population is actually collecting, and the tome rate has to be read against THAT rather
    -- than against the kill count. 2026-09-15: tome pickups were running at 57% of what the
    -- loot tables promise with no cause left to blame after group loot, the reference tables,
    -- the drop rate multipliers and the designed figures had all been checked and cleared.
    lootAll = (lootAll or 0) + 1
    local lootLvl = player:GetLevel()
    lootByLevel[lootLvl] = (lootByLevel[lootLvl] or 0) + 1
    local rank = rankOfItem[itemId]
    if rank == nil then
        return      -- every other item in the game; this table is about tomes
    end
    local guid = player:GetGUIDLow()
    local from, age = 0, 0
    local seen = lastKill[guid]
    if seen then
        local d = os.time() - seen[2]
        if d <= LOOT_LOG_HINT_SECS then
            from, age = seen[1], d
        end
    end
    CharDBExecute("INSERT INTO `classless_lootlog` (`at`,`guid`,`level`,`rank`,`item`,`count`,"
        .. "`map`,`instance`,`area`,`from_entry`,`from_age`) VALUES (NOW(),"
        .. guid .. "," .. player:GetLevel() .. "," .. rank .. "," .. itemId .. ","
        .. (tonumber(count) or 1) .. "," .. player:GetMapId() .. "," .. player:GetInstanceId()
        .. "," .. (player:GetAreaId() or 0) .. "," .. from .. "," .. age .. ")")
end

-- One entry per real player who has killed something, so the table is bounded by the number of
-- humans online -- but it is read through a 180 second window, so anything older than that is
-- already unreadable and only takes up room.
CreateLuaEvent(function()
    local cut = os.time() - LOOT_LOG_HINT_SECS
    for guid, seen in pairs(lastKill) do
        if seen[2] < cut then
            lastKill[guid] = nil
        end
    end
end, KILL_LOG_FLUSH_MS, 0)

-- Everyone this kill should count for.
--
-- The engine only fires a kill hook for the player who landed the KILLING BLOW
-- (Unit::Kill -> OnPlayerCreatureKill, and OnPlayerCreatureKilledByPet for a pet's blow), so
-- taking `killer` at face value gave the entire ClassLess payout to whoever got the last hit:
-- in a party of five, four players got no bounty letters and -- worst of it -- no
-- bounty COMPLETION, which leaves a bounty stuck in their log for good, since these quests
-- have no turn-in NPC. With a playerbot landing the blow, nobody got anything at all.
--
-- Loot is deliberately NOT handled here: the tomes themselves are real loot rows, so the
-- group's own loot method decides who gets them -- rolls, round robin or master loot. This
-- list is only for what the engine has no loot rules for: bounties, which are personal quests
-- rather than something to compete over.
local function KillAudience(killer, killed)
    local out = {}
    local group = killer:GetGroup()
    if group == nil then
        if not killer:IsBot() then
            out[1] = killer
        end
        return out
    end
    -- A bot's killing blow still pays the humans standing next to it: bots are excluded as
    -- RECIPIENTS (they collect nothing, and IsBot guards every grant below), not as a reason
    -- to drop the kill.
    -- Instance id, not just map id: two copies of the same dungeon share a map id, and the
    -- distance test below compares raw coordinates, so a group member standing in the same
    -- corridor of a DIFFERENT Deadmines would otherwise be close enough to get paid.
    local mapId, instanceId = killer:GetMapId(), killer:GetInstanceId()
    for _, member in ipairs(group:GetMembers()) do
        if not member:IsBot() and member:GetMapId() == mapId
            and member:GetInstanceId() == instanceId
            and member:GetDistance(killed) <= KILL_CREDIT_RANGE then
            table.insert(out, member)
        end
    end
    return out
end

-- Pay one player's bounty for this creature, if they have it and it just completed.
local function RewardBounty(player, b, entry)
    local questId = b[2]
    if player:GetQuestStatus(questId) ~= 1 then -- QUEST_STATUS_COMPLETE
        return
    end
    player:RewardQuest(questId)
    local tome = PickUnknownTome(player, entry)
    -- A full bag would otherwise swallow the guaranteed tome while the quest still counts as
    -- rewarded -- the one payout in the system that has no second chance.
    if tome and GiveItem(player, tome[1]) then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r Bounty complete: |cffffd100"
            .. b[3] .. "|r -- it was carrying a tome you have not read.")
    elseif tome then
        player:SendBroadcastMessage("|cffff5555[ClassLess]|r Bounty complete: |cffffd100"
            .. b[3] .. "|r -- but your bags are full, so the tome was left behind.")
    else
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r Bounty complete: |cffffd100"
            .. b[3] .. "|r.")
    end
end

local function OnCreatureKill(event, killer, killed)
    if killed == nil then
        return -- the pet hook fires for player victims too, where there is no creature
    end
    -- ...and it fires with no OWNER when an ownerless pet, totem or guardian lands the blow,
    -- which on a thousand-bot realm happens often enough to fill the log with
    -- "attempt to index local 'killer'". Nothing below has anyone to credit or to count.
    if killer == nil then
        return
    end
    -- Measurement, and it has to run BEFORE the audience test: that test returns early for a
    -- bot-only kill, which is the whole population we are sampling. The drop CHANCE is exact
    -- in the database; what nothing knows is which carriers actually get killed, and that is
    -- the half this answers.
    KillLogRecord(killer, killed)
    -- Loot attribution, and it has to be here for the same reason the kill log is: KillAudience
    -- below drops bots, so stamping only the audience left every BOT pickup unattributable --
    -- five of the first five rows the loot log ever wrote. The killer is who loots a corpse in
    -- the ordinary case, bot or not, and it is one table write per kill.
    lastKill[killer:GetGUIDLow()] = { killed:GetEntry(), os.time() }
    local audience = KillAudience(killer, killed)
    if #audience == 0 then
        return
    end
    local entry = killed:GetEntry()

    -- Practice, before every early return below: a bounty target and a tome carrier are as much
    -- of a fight as anything else, and used to be paid for by the experience hook that ran
    -- regardless of what this one did with them.
    --
    -- Off the kill rather than off the experience because for three long stretches of a career
    -- there is no experience: mod-individual-progression holds a character at 60 until it has
    -- cleared vanilla and at 70 until it has cleared Outland, and MaxPlayerLevel does it again
    -- at 80. WorthPractising carries the grey rule that the experience number used to supply
    -- for free.
    local killedGuid, place = killed:GetGUIDLow(), 1
    local pmap = killed:GetMap()
    if pmap and (pmap:IsDungeon() or pmap:IsRaid()) then
        place = PRACTICE_INSTANCE_BONUS
    end
    local now = os.time()
    for i = 1, #audience do
        local p = audience[i]
        -- What the loot log will blame the next tome on. The audience is already real players
        -- only and already distance-checked, which is exactly the set that can loot this corpse.
        lastKill[p:GetGUIDLow()] = { entry, now }
        if Practising(p) and WorthPractising(p, killed) then
            CreditPractice(p, p:GetGUIDLow(), killedGuid, place)
        end
    end

    -- Reward side: this kill may be the target of a bounty already in someone's log. Native
    -- kill-credit runs before the hook fires (it is part of the same synchronous death-reward
    -- pipeline) and credits the whole group, so GetQuestStatus already reflects the kill for
    -- every member by the time this sees it.
    local b = bountyOf[entry]
    if b then
        for i = 1, #audience do
            RewardBounty(audience[i], b, entry)
        end
        return -- a tome-carrying creature never also drops a bounty item
    end

    -- Drop side: inside a dungeon or a raid only. The old second gate -- "only a creature that
    -- carries no tome of its own" -- is gone with the placement it described: under the group
    -- rule EVERY killable creature carries something, so that test was true everywhere and no
    -- bounty letter would ever have dropped again.
    local map = killed:GetMap()
    if map == nil or not (map:IsDungeon() or map:IsRaid()) then
        return
    end
    local instanceId = map:GetInstanceId()

    -- Instances can be reset five times an hour and their trash comes back for free, so the
    -- letters are capped per player per instance id rather than per kill count.
    for i = 1, #audience do
        local player = audience[i]
        local guid = player:GetGUIDLow()
        local seen = bountyPerInstance[guid]
        if seen == nil then
            seen = {}
            bountyPerInstance[guid] = seen
        end
        local got = seen[instanceId] or 0
        if got < BOUNTY_PER_INSTANCE and math.random() <= BOUNTY_DROP_CHANCE then
            if GrantRandomBounty(player, BOUNTY_TARGETS_ANYWHERE) then
                seen[instanceId] = got + 1
            end
        end
    end
end

local function OnLogin(event, player)
    if player:IsBot() then
        return
    end
    -- Not a ClassLess character. The addon is delivered to everyone -- it comes down with the
    -- realm, not with the class -- so it has to be TOLD, or it sits there having repointed the
    -- talent button at a collection this character does not have. Silence would look like a bug
    -- from the inside of the client.
    if not Ours(player) then
        AIO.Handle(player, handlerName, "ClassLessOff")
        return
    end
    local guid = player:GetGUIDLow()
    LoadPlayerData(guid)
    -- The seed in LoadPlayerData may have just picked a spell that needs a weapon in hand
    -- (level1WeaponReq). The PERMISSION to hold one is no longer in question -- every character
    -- has all 21 proficiencies -- but permission is not a weapon, so hand over an actual item of
    -- the right type and the seeded ability has something to swing or shoot on arrival.
    local reqSkill = pendingWeaponReq[guid]
    if reqSkill then
        pendingWeaponReq[guid] = nil
        local itemId = weaponItemOfSkill[reqSkill]
        if itemId then
            player:AddItem(itemId, 1)
        end
    end
    -- Every login, not just the first: proficiency is not persisted and _LoadSkills has
    -- already stripped anything that fails this character's race/class check.
    ApplyProficiencies(player)
    -- ...and the four auto-attacks beside them, for the same reason: a character may now equip a
    -- bow, a wand and a thrown weapon from level one, and three of the four were granted to
    -- somebody else's class or to nobody at all.
    GrantBaseAbilities(player)
    -- The client makes a button for a spell it watches arrive, so the four above have just
    -- landed on the action bar of anyone logging in for the first time. Tell the addon to take
    -- them off. Sent from here rather than decided on the client, because the addon ships to
    -- every character on this realm and a real Hunter's Auto Shot button is the real thing.
    AIO.Handle(player, handlerName, "BarCleanup")
    -- Buffs, stances and teleports catch up to the character's level. On login as well as on
    -- level-up, because a character that existed before this rule did has a career's worth of
    -- them waiting, and because it is the same sweep either way.
    local auto = GrantAutoRanks(player, guid)
    if auto > 0 then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r " .. auto
            .. " rank(s) of your buffs, stances and teleports have caught up to your level.")
    end
    -- Catch up anything banked below its level, plus whatever the starter backfill or the
    -- per-rank migration just added.
    local got = GrantBankedRanks(player, guid)
    if got > 0 then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r " .. got
            .. " ability rank(s) from your collection are now available.")
    end
    -- A choice earned last session and never answered. Rebuilt from the stored advances rather
    -- than stored itself, so it survives a logout, a crash and a `reload ale` alike.
    ReofferPending(player, guid)
end

-- Ranks are banked when found below their level, so every level-up may release some.
--
-- The same two sweeps as login and in the same order, because the two moments ask the same
-- question: the auto-rank lines (buffs, stances, teleports) rank up ON level and everything else
-- may have been sitting in the pool waiting for one.
local function OnLevelUp(event, player, oldLevel)
    if not Ours(player) then
        return
    end
    local guid = player:GetGUIDLow()
    if not EnsureLoaded(player) then
        return
    end
    local auto = GrantAutoRanks(player, guid)
    if auto > 0 then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r " .. auto
            .. " rank(s) of your buffs, stances and teleports have caught up to your level.")
    end
    local got = GrantBankedRanks(player, guid)
    if got > 0 then
        player:SendBroadcastMessage("|cff33ff99[ClassLess]|r " .. got
            .. " ability rank(s) from your collection are now available.")
    end
end

-- Drop every per-guid table this file keeps.
--
-- One list, in one place, because the hand-written copies drifted: the one in OnDelete was seven
-- tables behind and missing every practice table by the time it was found. The forward
-- declaration is at the top of the file, next to that story.
--
-- The list is the complete set of tables indexed by a character's guid. Anything added later has
-- to be added here too, or a character that logs out and back in keeps the old session's numbers.
ForgetPlayer = function(guid)
    pools[guid], poolSet[guid], lineOwned[guid] = nil, nil, nil
    lineUp[guid], lineUnits[guid], practiceRate[guid] = nil, nil, nil
    lineAt[guid], lineHit[guid], treeDirty[guid] = nil, nil, nil
    pending[guid], pendingWeaponReq[guid] = nil, nil
    bountyPerInstance[guid], lastKill[guid], throttleAt[guid] = nil, nil, nil
end

-- Practice earned this session is written on a purchase and on logout, and nowhere else -- plus
-- the PRACTICE_FLUSH_MS timer, which exists because a crash or a `reload ale` reaches neither.
-- So the flush comes FIRST here and the forgetting second; the other order throws the session
-- away and then writes an empty one over the stored row.
local function OnLogout(event, player)
    local guid = player:GetGUIDLow()
    if Ours(player) then
        TreeFlush(guid)
    end
    ForgetPlayer(guid)
end

-- What every Adventurer knows before it draws its first breath.
--
-- The proficiency spells and the four auto-attacks are handed out on LOGIN as well, and that has
-- to stay: it is what reaches characters that existed before any of this. But Player::_addSpell
-- sends SMSG_LEARNED_SPELL when the character is IN WORLD (Player.cpp:3138), and that packet is
-- what makes the client build a button for the spell on the first free action slot. So a new
-- Adventurer arrived with Pick Lock, Throw, Shoot and Auto Shot on its bar -- four buttons nobody
-- asked for, three of them useless without the weapon they belong to -- pushing the one ability it
-- was actually seeded with out of sight.
--
-- Granted here instead. PLAYER_EVENT_ON_CHARACTER_CREATE fires before the character has ever been
-- in the world, so no packet goes out; the spells reach the client in the initial spell list at
-- login, which the client does not treat as an arrival. The login sweeps then find HasSpell true
-- and do nothing.
--
-- SaveToDB is the whole trick and its absence is why this hook was written once, did nothing, and
-- was removed as dead. CharacterHandler.cpp:589 fires OnPlayerCreate from the AfterComplete
-- callback of the character's own insert transaction -- SaveToDB at line 568 has already run and
-- committed -- and the unique_ptr is destroyed on the way out. Anything learned here lives for a
-- few microseconds unless it is written. mod-learn-spells does the same thing for the professions
-- at the same moment and for the same reason, which is where the recipe comes from.
--
-- playercreateinfo_spell_custom would have been the obvious home and cannot be: the core throws a
-- row away unless its class mask overlaps CLASSMASK_ALL_PLAYABLE, which is classes 1-9 and 11.
--
-- No CastSpell here, unlike ApplyProficiencies: the cast is what sets the proficiency MASK, and it
-- wants a player that is in the world. Login does that, every login, which is where it belongs.
local function OnCharacterCreate(event, player)
    if not Ours(player) then
        return
    end
    for _, p in pairs(profOf) do
        if not player:HasSpell(p[2]) then
            player:LearnSpell(p[2])
        end
    end
    for i = 1, #BASE_ABILITIES do
        if not player:HasSpell(BASE_ABILITIES[i]) then
            player:LearnSpell(BASE_ABILITIES[i])
        end
    end
    player:SaveToDB()
end

-- =====================================================================================
-- THE SHOWN ABILITY IS THE ONE THAT DROPS
--
-- npc_showcast.py makes every carrier pick one ability out of its own tome pool at aggro and
-- cast it once, while its health is between 95% and 5%. That was a tell and nothing more: the
-- corpse still handed back whatever the reference table rolled, which was usually a different
-- book from the one you had just watched it use.
--
-- The user's rule (2026-09-18) closes that gap: the ability the creature CHOSE TO USE is the
-- one that may drop. The loot tables still decide IF a tome falls -- every chance, every band
-- and the whole 2026-09-13 tomes-per-level measurement is untouched -- and this decides WHICH.
--
-- WHY IT CAN BE DONE HERE AT ALL. An older comment in this file says mod-ale exposes no loot
-- API. That has stopped being true: LootMethods.h carries AddItem, RemoveItem, GetItems,
-- Get/SetUnlootedCount and UpdateItemIndex, and Creature:GetLoot hands over the corpse's Loot.
-- Two orderings in the core make the rewrite safe:
--
--   Creature::setDeathState(JustDied) fills the loot BEFORE Unit::Kill calls ai->JustDied,
--   which is what raises CREATURE_EVENT_ON_DIED -- so the corpse's items are already there to
--   be read when this runs.
--
--   The group's roll is not built at death. Player::SendLoot builds it when the first player
--   OPENS the corpse, so an item swapped in here is rolled for exactly like one the loot table
--   placed. The group loot rule -- the tome belongs to whoever the group's method says -- keeps
--   working without knowing anything about this.
--
-- WHAT COUNTS AS "USED". Any spell the creature lands that is a tome-bearing rank AND is in
-- that creature's own loot pool. The pool check is what keeps a creature's NATIVE abilities
-- from handing out a line its group never placed -- a mob that natively casts Shadow Bolt but
-- is not a shadow carrier shows a real ability and still drops only what it is allowed to.
--
-- Wrapped in a do-block, registrations included, for a reason that is easy to trip over twice:
-- a Lua function may declare at most 200 locals, the main chunk of this file is one function,
-- and it is close enough to that ceiling that seven more file-scope names do not fit. Nothing
-- outside this block needs any of them.
do
-- OFF since 2026-09-19, the day it went in, and it stays off until it is rebuilt on loot MODES
-- rather than on rewriting a Loot the core has already filled. See the note above
-- ShowcastDecideLoot for what went wrong.
--
-- What still runs with this false: the creature's performance (npc_showcast.py, untouched) and
-- the record of what it showed. Only the corpse is left alone, so the loot table's own pick
-- stands and every drop rate is exactly what groups.py tuned.
local SHOWCAST_DRIVES_LOOT = false
local SHOWCAST_STRICT = true   -- nothing shown, nothing given. See the note above the handler.

-- creature guid -> the rank it has shown in THIS fight. Wiped at aggro rather than at evade or
-- death, so a record can never leak from one pull into the next, whatever order the core raises
-- its combat hooks in.
local shownRank = {}
-- creature entry -> { ranks = { [rankId] = true }, shows = bool }, read once from the world
-- tables the first time one of these creatures matters. Lazy on purpose: the world has 27147
-- carrier rows and holding all of them would cost the RAM the group rule was written to save,
-- while the entries actually fought in a session are a small fraction of that.
--
-- `shows` is the other half of the strict rule and not an optimisation. npc_showcast.py gives a
-- performance to 7799 of the 8379 killable carriers; the rest have nothing it is willing to
-- cast (every ability they own is passive, or needs a stance they are not in, or is a heal, a
-- summon or a teleport). Those creatures CANNOT show anything, ever, so "nothing shown, nothing
-- given" would quietly delete their drops instead of ruling on them. They are exempt: their
-- loot row stands as the table rolled it.
local dropPoolOf = {}

local function InfoOf(entry)
    local info = dropPoolOf[entry]
    if info then return info end
    info = { ranks = {}, shows = false }
    -- Both shapes the generator emits: a creature row pointing at a group's reference table,
    -- and the plain item rows a rare pre-cast buff is placed with.
    local q = WorldDBQuery(
        "SELECT r.Item FROM creature_loot_template c "
        .. "JOIN reference_loot_template r ON r.Entry = c.Reference "
        .. "WHERE c.Entry = " .. entry .. " AND c.Reference > 0 "
        .. "UNION "
        .. "SELECT Item FROM creature_loot_template WHERE Entry = " .. entry
        .. " AND Reference = 0")
    if q then
        repeat
            local rank = rankOfItem[q:GetUInt32(0)]
            if rank then info.ranks[rank] = true end
        until not q:NextRow()
    end
    -- 900-909 is npc_showcast.py's whole id band -- the same one its DELETE owns and the one
    -- groups.py ignores when it reads smart_scripts.
    local c = WorldDBQuery(
        "SELECT 1 FROM smart_scripts WHERE source_type = 0 AND entryorguid = " .. entry
        .. " AND id BETWEEN 900 AND 909 LIMIT 1")
    info.shows = c ~= nil
    dropPoolOf[entry] = info
    return info
end

-- CREATURE_EVENT_ON_ENTER_COMBAT. One table write per pull; the fight starts having shown
-- nothing.
local function ShowcastForget(event, creature)
    shownRank[creature:GetGUIDLow()] = nil
end

-- CREATURE_EVENT_ON_SPELL_HIT_TARGET. Registered for every creature in the world, so the first
-- line has to be the cheap one: tomeOf is a plain hash and all but a few hundred spell ids miss
-- it outright.
local function ShowcastRemember(event, creature, target, spellId)
    if not tomeOf[spellId] then return end
    if not InfoOf(creature:GetEntry()).ranks[spellId] then return end
    shownRank[creature:GetGUIDLow()] = spellId
end

-- CREATURE_EVENT_ON_DIED. NOT REGISTERED while SHOWCAST_DRIVES_LOOT is false. Kept whole because
-- the shape of it is right and only the delivery is wrong.
--
-- WHAT IT BROKE, on a live realm, within an hour of going in: a tome appeared in the loot window,
-- could not be taken, and was gone on the second open.
--
-- Every ClassLess tome row is CONDITIONAL -- one negated CONDITION_SPELL each, so a character that
-- already knows the rank is not shown the book -- and conditional items do not live in Loot::items
-- alone. When a player opens the corpse, Loot::FillNonQuestNonFFAConditionalLoot walks items,
-- pushes QuestItem(i) -- an INDEX -- into a per-player list, raises unlootedCount and marks the
-- item is_counted. RemoveItem erases from the middle of that vector and AddItem appends a
-- LootStoreItem carrying no conditions, so the indexes, the count and the item's own
-- conditionality all stop agreeing. The client is shown a slot the server will not hand over.
--
-- The lost condition is a second bug hiding behind the first: swapped in, the tome would be
-- offered to a character that already knows the rank.
--
-- HOW TO BUILD IT INSTEAD. Not by editing a filled Loot -- by never filling the wrong one. A
-- creature has a LOOT MODE (Creature:SetLootMode, and creature_loot_template.lootmode is a
-- per-row mask), Loot::FillLoot filters rows by it, and the showcast is known while the creature
-- is still alive. Set the mode when the ability is shown and the core emits the right row itself,
-- with its conditions, its per-player lists and the group roll all intact. What that needs first
-- is a bit per line in the emitted loot rows, inside a 16-bit mask, for a creature that answers
-- for a median of three groups -- a change in emit_groups.py, not here.
--
-- The rest of this comment describes the handler as written and still applies to it.
--
-- The loot is already filled here (see the ordering note above).
--
-- Only ever swaps a tome for a tome, so the creature's own chance of giving one is exactly what
-- its loot row says. The one place the count can fall is a creature that died without showing
-- anything THOUGH IT COULD HAVE, which under SHOWCAST_STRICT gives nothing: with a health band
-- rather than a timer that means a creature killed from full in a single blow, since anything
-- fought down passes through 95%..5%. Flip SHOWCAST_STRICT to false to let the table's own pick
-- stand in that case instead.
local function ShowcastDecideLoot(event, creature, killer)
    local guid = creature:GetGUIDLow()
    local shown = shownRank[guid]
    shownRank[guid] = nil
    local loot = creature:GetLoot()
    if not loot then return end
    local dropped = {}
    for _, it in ipairs(loot:GetItems() or {}) do
        if rankOfItem[it.id] then table.insert(dropped, it.id) end
    end
    if #dropped == 0 then return end
    local want = shown and tomeOf[shown] and tomeOf[shown][1] or nil
    -- Nothing shown. Either the rule has nothing to say about this creature (it was never given
    -- a performance) or it is not strict -- both leave the table's own pick alone.
    if not want and (not SHOWCAST_STRICT or not InfoOf(creature:GetEntry()).shows) then
        return
    end
    if #dropped == 1 and dropped[1] == want then return end
    -- RemoveItem erases the row without touching unlootedCount and AddItem raises it, so the
    -- count is restated by hand rather than left to the sum of the two.
    local n = loot:GetUnlootedCount() or #dropped
    for _, itemId in ipairs(dropped) do
        loot:RemoveItem(itemId)
    end
    if want then
        -- chance 100 and lootmode 1: the roll that decided a tome falls has already happened,
        -- this only says which one. needs_quest false, stacking off.
        loot:AddItem(want, 1, 1, 100, 1, false, false)
        loot:SetUnlootedCount(math.max(0, n - #dropped + 1))
    else
        loot:SetUnlootedCount(math.max(0, n - #dropped))
    end
    loot:UpdateItemIndex()
end

-- Per ENTRY, and the reason is worth the paragraph because getting it wrong took the realm down.
--
-- RegisterAllCreatureEvent looks like the cheap way to say "every creature", and it does not take
-- the CreatureEvents ids. It takes Hooks::AllCreatureEvents, a different and much smaller enum --
-- ON_ADD, ON_REMOVE, ON_SELECT_LEVEL, the damage and heal modifiers, thirteen in all -- with no
-- combat, cast or death hook anywhere in it. So ids 1 and 4 registered quietly against the wrong
-- events, and id 15 was out of range. Out of range is not a warning: Eluna::Register calls
-- luaL_error, which ABORTS THE WHOLE CHUNK, so every RegisterPlayerEvent below this point never
-- ran. A character created after that got no starter spell, no base abilities and no practice,
-- and the only trace was one line in Server.log:
--
--   lua_scripts/ClassLess/Server.lua:4057: Unknown event type (regtype 18, event 15, ...)
--
-- RegisterCreatureEvent does take CreatureEvents, so the ids below are real. It needs an entry,
-- which is fine: only the creatures npc_showcast.py gave a performance to can show anything, and
-- that is the 900-909 smart_scripts band. Joined to creature_template so a stale row cannot hand
-- Register an entry that no longer exists -- which would be another luaL_error, in the same place,
-- with the same blast radius.
local shown = WorldDBQuery(
    "SELECT DISTINCT s.entryorguid FROM smart_scripts s "
    .. "JOIN creature_template ct ON ct.entry = s.entryorguid "
    .. "WHERE s.source_type = 0 AND s.entryorguid > 0 AND s.id BETWEEN 900 AND 909")
local hooked = 0
if shown then
    repeat
        local entry = shown:GetUInt32(0)
        RegisterCreatureEvent(entry, 1, ShowcastForget)        -- ON_ENTER_COMBAT
        RegisterCreatureEvent(entry, 15, ShowcastRemember)     -- ON_SPELL_HIT_TARGET
        if SHOWCAST_DRIVES_LOOT then
            RegisterCreatureEvent(entry, 4, ShowcastDecideLoot)  -- ON_DIED
        end
        hooked = hooked + 1
    until not shown:NextRow()
end
print("[ClassLess] showcast: " .. hooked .. " carrier(s) hooked, loot rule "
      .. (SHOWCAST_DRIVES_LOOT and "ON" or "OFF"))
end

RegisterPlayerEvent(1, OnCharacterCreate) -- PLAYER_EVENT_ON_CHARACTER_CREATE
RegisterPlayerEvent(2, OnDelete)
RegisterPlayerEvent(3, OnLogin)
RegisterPlayerEvent(4, OnLogout)
RegisterPlayerEvent(7, OnCreatureKill)   -- PLAYER_EVENT_ON_KILL_CREATURE
-- A pet's killing blow does NOT raise event 7 -- Unit::Kill routes it to
-- OnPlayerCreatureKilledByPet instead, and only one of the two ever fires -- so without this
-- a character fighting through a pet or a totem never completed a bounty.
-- Same argument shape as event 7, (event, player, killed), with the pet's owner as the player.
RegisterPlayerEvent(58, OnCreatureKill)  -- PLAYER_EVENT_ON_PET_KILL
RegisterPlayerEvent(13, OnLevelUp)       -- PLAYER_EVENT_ON_LEVEL_CHANGE
-- Practice records the press here and pays for it in OnCreatureKill. PLAYER_EVENT_ON_GIVE_XP
-- used to be the second half of this and is gone: nothing reads a kill's or a quest's
-- experience any more, and hanging off it meant practice stopped at every progression cap.
RegisterPlayerEvent(5, OnSpellCast)      -- PLAYER_EVENT_ON_SPELL_CAST
RegisterPlayerEvent(32, OnLootItem)      -- PLAYER_EVENT_ON_LOOT_ITEM
-- The creature events are registered inside the showcast block above, beside the handlers
-- themselves -- see the notes there about the 200-local ceiling and about which enum
-- RegisterAllCreatureEvent actually takes.

-- A `reload ale` fires no login event, so the players already in the world are swept by hand.
--
-- Each one in its own pcall. Unprotected, the first failure took the whole loop with it and every
-- character after that one was left with no data in this state -- silently, because the error went
-- nowhere anybody was looking. EnsureLoaded now repairs that on the first handler call either way;
-- this makes it visible rather than merely survivable.
local plrs = GetPlayersInWorld()
if plrs then
    local swept, failed = 0, 0
    for i, player in ipairs(plrs) do
        if not player:IsBot() then
            -- OnLogin sorts out whether this one is ours, including telling the client when it
            -- is not: a `reload eluna` is exactly when a Druid's client needs to hear it.
            local ok, err = pcall(OnLogin, i, player)
            if ok then
                swept = swept + 1
            else
                failed = failed + 1
                print("[ClassLess] reload sweep failed for " .. tostring(player:GetName())
                    .. ": " .. tostring(err))
            end
        end
    end
    print("[ClassLess] reload sweep: " .. swept .. " character(s) restored"
        .. (failed > 0 and (", " .. failed .. " FAILED") or ""))
else
    print("[ClassLess] reload sweep: GetPlayersInWorld returned nothing")
end
