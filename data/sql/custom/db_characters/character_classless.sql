-- ClassLess: per-character storage.
--
-- Applied by AzerothCore's updater (data/sql/custom/db_characters is one of the directories
-- it scans), so on a fresh realm this runs before any character logs in.
--
-- Five columns, and Server.lua reads exactly these five:
--
--   guid     the character
--   pool     every ability RANK the character has found, comma-separated spell ids.
--            MEDIUMTEXT because a completionist holds most of the ~3960 ranks -- about 27 KB
--            of ids, well past what TEXT is comfortable with.
--   profs    the weapon/armour proficiencies found. At most 21 skill ids.
--   profver  migration marker for profs.
--   poolver  which SHAPE pool is in: 0 = line ids (one entry meant a whole chain),
--            1 = rank ids. The two cannot be told apart by looking at them -- a line id is
--            its own rank 1 -- so the migration is driven by this, not by inspection.
--            A fresh table is born at the current shape; see POOL_VER in Server.lua.
--
-- This file used to be a HeidiSQL export of the ability-picker panel's table: guid, spells,
-- tpells, talents, stats, resets. The panel was removed on 2026-08-13 and those columns were
-- dropped from the live realm, but this file kept recreating them -- so a realm set up from
-- zero got the old shape, and Server.lua's EnsureSchema() then bolted the four real columns
-- on with ALTER TABLE at first login. It worked, and it meant the fresh table never matched
-- the one it was supposed to reproduce.
--
-- EnsureSchema() still runs and is still the safety net for an OLD realm, where it adds
-- whatever is missing. Against this definition it finds nothing to do.
--
-- Re-runnable.

CREATE TABLE IF NOT EXISTS `character_classless` (
  `guid` BIGINT NOT NULL,
  `pool` MEDIUMTEXT NOT NULL,
  `profs` TEXT NOT NULL,
  `profver` INT NOT NULL DEFAULT 0,
  `poolver` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
