-- Fix "Table 'creature_loot_template' Entry X does not exist" startup errors.
--
-- These creatures point `creature_template.lootid` at their own entry, but no
-- `creature_loot_template` row was ever written for it. The loot was empty either way -- the
-- table the id names does not exist -- so zeroing the id changes nothing a player can see and
-- silences one startup error per creature.
--
-- Two guards, and the second one is not optional:
--
--   `lootid` = `entry`   leaves alone any creature pointing at a SHARED loot table. That id
--                        belongs to another creature and may well have rows.
--
--   NOT EXISTS (...)     zeroes an id only while it still names nothing. Without it this file
--                        is a landmine for anything that GIVES a creature a loot table later:
--                        ClassLess asserts `lootid` = `entry` for every creature it drops a
--                        tome on, and entry 21316 (Deathforged Infernal) is on the list below
--                        AND carries the Living Bomb alt source. Applied in the order a fresh
--                        realm happens to use, this file ran first and the grant repaired it;
--                        re-applied afterwards -- one edit to this file is enough, the updater
--                        re-runs on a hash change -- it would have zeroed the id back and the
--                        tome would have stopped dropping, with nothing to show for it but a
--                        rank nobody could find.
--
-- With the guard the file is order-independent and stays correct as the dataset grows: it
-- cannot disable a loot table that exists, whoever created it.
--
-- Re-runnable.

-- Non-lootable trigger and visual NPCs: turrets, prisoners, spell-effect dummies.
UPDATE `creature_template` `ct` SET `ct`.`lootid` = 0
WHERE `ct`.`entry` IN
(29399,27349,30292,30209,29849,28553,28386,28385,25033,24980,23076,22443,22389,21316,20852,20851,20286,20148,20026,10698,10415,7343)
AND `ct`.`lootid` = `ct`.`entry`
AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` `clt` WHERE `clt`.`Entry` = `ct`.`lootid`);

-- The rest of the same set, found in Errors.log on 2026-08-28: festival participants
-- (Darkmoon Faire Carnie, Winter Reveler, Fire/Flame Eater, Eversong Partygoer), escort and
-- quest props (Helpless/Trapped Wintergarde Villager, Impaled Valgarde Scout, Tarren Mill
-- Peasant, Traveling Orphan), ambient wildlife and city commoners, and a handful of scenery
-- creatures (Archery Target, Hellfire Death Brazier, Ancient Draenei Spirit).
UPDATE `creature_template` `ct` SET `ct`.`lootid` = 0
WHERE `ct`.`entry` IN
(2914,5202,10779,14849,14865,15760,16831,17056,17432,17552,18644,19171,19416,22306,23087,23971,24077,25198,25962,25994,26321,27336,27359,28642,28782,28856,35246,39623)
AND `ct`.`lootid` = `ct`.`entry`
AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` `clt` WHERE `clt`.`Entry` = `ct`.`lootid`);

-- Three more from Errors.log on 2026-08-30: Eastvale Lumberjack, Eastvale Peasant and the
-- Elwynn Pink Elekk. Checked against tomes.data first -- none of the three is a ClassLess
-- carrier, so this is the same stock defect as the rest of the file and not a tome row that
-- went missing.
UPDATE `creature_template` `ct` SET `ct`.`lootid` = 0
WHERE `ct`.`entry` IN (1975, 11328, 23507)
AND `ct`.`lootid` = `ct`.`entry`
AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` `clt` WHERE `clt`.`Entry` = `ct`.`lootid`);


-- ---------------------------------------------------------------------------------------------
-- The lootids the ClassLess rank-1 cut abandoned.
--
-- Merged in from pending_db_world/classless_reset_abandoned_lootids.sql on 2026-09-15. It was a
-- separate migration and did not need to be: it is the same UPDATE as the three above, with the
-- same two guards, fixing the same symptom on a different list of creatures. Kept as an explicit
-- id list rather than folded into an unfiltered statement -- see the note at the top of this file
-- about ordering: this filename sorts at "f", ahead of every module's "z" files, so a blanket
-- zeroing here could take an id a later file is about to fill.

-- rank1cut.py took the tome placement from 3158 carriers to 1493 on 2026-09-05. Every pipeline
-- delete is scoped to the item id range, so the tome ROWS went cleanly -- but the matching
-- `creature_template`.`lootid` = `entry` grants did not, and these 121 creatures have no loot of
-- their own behind the id. Each one costs a startup warning
--
--   Table 'creature_loot_template' Entry 17108 does not exist but it is used by Creature 17108
--
-- and, worse, a LootMgr error at RUNTIME (LootMgr.cpp:553, "loot id #17108 used but it doesn't
-- have records") every single time one of them is killed -- Forsaken Raider had already logged
-- three in one boot.
--
-- These are OURS. The note in the session record saying the 121 were pre-existing world drift is
-- wrong: all 121 are at `lootid` = 0 in data/sql/base/db_world/creature_template.sql, no core
-- update, module or other custom file names any of them, and the git HEAD copy of
-- zz_classless.sql -- the pre-cut 3158-carrier grant list -- covers every one.
--
-- What hid it: emit_loot.py and verify.py both reconstructed "what ClassLess granted" by scanning
-- classless_tome_loot.sql, the file emit_loot.py OVERWRITES on each run, so a creature dropped
-- from the placement lost its grant from the scan at the same moment and became unreportable.
-- Both now read tools/classless-web/lootid_grants.json, an append-only ledger, and emit_loot.py
-- asserts the reset unconditionally instead of asking the database what still needs one.
--
-- Kept as a migration as well as in the generator so the live realm is repaired without a full
-- make.py --write --apply. Both guards are load-bearing and make it re-runnable and
-- order-independent:
--
--   `lootid` = `entry`   never touches a creature pointing at a SHARED loot table.
--   NOT EXISTS (...)     zeroes an id only while it still names nothing, so this cannot disable
--                        a loot table that exists -- including one a later ClassLess run gives
--                        back to a creature on this list.
UPDATE `creature_template` `ct` SET `ct`.`lootid` = 0
    WHERE `ct`.`entry` IN (
        5198, 6670, 6766, 10556, 11277, 13839, 14718, 15242, 15663, 15696, 15905, 15907, 15908,
        15961, 16378, 16541, 16580, 16804, 17108, 17272, 17407, 17408, 17855, 18358, 18489,
        18549, 18688, 18909, 19258, 19353, 19397, 19398, 19399, 19449, 19529, 19541, 19687,
        20238, 20710, 20796, 21081, 21443, 21736, 21975, 23115, 23257, 23716, 23755, 23779,
        23840, 23842, 23844, 23973, 24005, 24050, 24222, 24317, 24519, 25242, 25243, 25244,
        25253, 25377, 26217, 26282, 26448, 26570, 26603, 26839, 26870, 26925, 26933, 27035,
        27160, 27456, 27501, 27518, 27530, 27540, 27553, 27560, 27564, 27629, 27631, 27638,
        27745, 28005, 28029, 28041, 28113, 28156, 28169, 28218, 28220, 28260, 28801, 28844,
        29202, 29618, 29692, 29893, 29979, 30188, 30189, 30238, 30330, 30337, 30352, 30675,
        30755, 31033, 31094, 31397, 31813, 32836, 33550, 33698, 33713, 36841, 36877, 37675
    )
      AND `ct`.`lootid` = `ct`.`entry`
      AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` `l`
                      WHERE `l`.`Entry` = `ct`.`lootid`);
