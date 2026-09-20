-- ClassLess: everything the design no longer uses, cleared in one place.
--
-- This replaces four files that each cleared one retired id block
-- (classless_tomes_items, classless_hint_items_retired, classless_prof_retire,
-- classless_starter_loot_cleanup). They were separate because each retirement happened on its
-- own day; there was never a reason for them to stay separate afterwards, and four files that
-- all say DELETE made the merge plan look like it had four decisions in it instead of one.
--
-- WHAT THIS IS FOR. On a realm built from zero it is a no-op: no generator emits any of these
-- entries, so nothing ever creates them. It earns its place on a realm that has been running
-- since before the retirements, where the rows are still sitting in the tables -- and a loot row
-- pointing at an item that no longer exists is a warning LootMgr logs once per kill, forever.
--
-- Re-runnable, and scoped strictly to id blocks ClassLess owns.

-- ---------------------------------------------------------------------------------------------
-- 60000-61999 -- one tome per ABILITY LINE (560 spells + 622 talents).
--
-- Superseded by classless_rank_items.sql, which seeds one tome per ABILITY RANK at 63000-66999.
-- Removed outright rather than left in place: the legacy-unlock branch is gone from
-- Server.lua and tomes.data, and every owned instance (bots only) was purged from
-- item_instance / character_inventory / mail_items at the time.
--
-- The loot DELETE is a range where it used to be a generated list of 108 ids
-- (classless_starter_loot_cleanup.sql, written when these items still existed, to stop the
-- starter lines dropping a tome that could only ever say "You already know this ability").
-- Once the items themselves were gone, every row in the block was an orphan, so the id list
-- was a narrower way of saying the same thing and needed a generator to stay correct.
DELETE FROM `creature_loot_template` WHERE `Item` BETWEEN 60000 AND 61999;
DELETE FROM `npc_vendor`             WHERE `item` BETWEEN 60000 AND 61999;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 1
                           AND `SourceEntry` BETWEEN 60000 AND 61999;
DELETE FROM `item_template`          WHERE `entry` BETWEEN 60000 AND 61999;

-- ---------------------------------------------------------------------------------------------
-- 62000-62099 -- the 21 collectible weapon/armour proficiency manuals.
--
-- Retired 2026-09-11. Every character now has all 21 proficiencies from level one, applied by
-- Server.lua's ApplyProficiencies on login at skill 1 with a ceiling of 75, so there is nothing
-- left to collect. The argument for not putting them back: proficiency is the FLOOR of the game,
-- not a reward in it. Without armour proficiency a character cannot equip anything at all, so a
-- manual was a prerequisite dressed as a collectible -- and until profspread.py moved them, nine
-- of the primaries stood inside dungeons, which asked a level 5 character to find a group for the
-- right to hold a mace.
DELETE FROM `creature_loot_template` WHERE `Item` BETWEEN 62000 AND 62099;
DELETE FROM `npc_vendor`             WHERE `item` BETWEEN 62000 AND 62099;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 1
                           AND `SourceEntry` BETWEEN 62000 AND 62099;
DELETE FROM `item_template`          WHERE `entry` BETWEEN 62000 AND 62099;

-- ---------------------------------------------------------------------------------------------
-- 73000-76999 -- the "Weathered Notes: <ability>" hint items, one per rank at tome id + 10000.
--
-- They dropped at a flat 2% on every kill and carried their pointer in the item description. Each
-- cost a bag slot and only cleared itself when that exact rank was learned, so a character
-- levelling to 80 accumulated dozens. The note was a nudge, not something worth paying for in
-- inventory space every session.
--
-- 500782 was their icon in itemdisplayinfo_dbc, used by these items and nothing else. The tome
-- display rows (500000-500781) stay: they belong to the tomes.
DELETE FROM `creature_loot_template` WHERE `Item` BETWEEN 73000 AND 76999;
DELETE FROM `npc_vendor`             WHERE `item` BETWEEN 73000 AND 76999;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 1
                           AND `SourceEntry` BETWEEN 73000 AND 76999;
DELETE FROM `item_template`          WHERE `entry` BETWEEN 73000 AND 76999;
DELETE FROM `itemdisplayinfo_dbc`    WHERE `ID` = 500782;
