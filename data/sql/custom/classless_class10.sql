-- The ClassLess class on id 10, server side.
--
-- Class 10 has never been used by 3.3.5. ChrClasses.dbc ships ten records -- 1 to 9 and 11 -- and
-- the core's class-indexed tables carry a placeholder block where 10 would be, so the slot is
-- free and taking it collides with nothing. That is the argument for it over renaming a real
-- class: what sits there is separate from the blizzlike game rather than wearing its clothes.
--
-- The DBC half is tools/classless-web/newclass.py and has to be run as well -- a class that
-- exists in the database and not in ChrClasses.dbc is refused at character creation by
-- CharacterHandler.cpp, which validates the class by DBC lookup and nothing else.
--
-- Everything here is cloned from class 11, the chassis ClassLess has been riding, so a class 10
-- character starts life identical to what the realm already produces. The one deliberate
-- difference is in the DBC: 10 runs on MANA where 11 runs on energy.
--
-- Idempotent. Run it as often as you like.

-- ---- where a new character appears, and what it starts with ---------------------------------
DELETE FROM `playercreateinfo` WHERE `class` = 10;
INSERT INTO `playercreateinfo` (`race`, `class`, `map`, `zone`, `position_x`, `position_y`,
                                `position_z`, `orientation`)
    SELECT `race`, 10, `map`, `zone`, `position_x`, `position_y`, `position_z`, `orientation`
    FROM `playercreateinfo` WHERE `class` = 11;

DELETE FROM `playercreateinfo_action` WHERE `class` = 10;
INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`)
    SELECT `race`, 10, `button`, `action`, `type`
    FROM `playercreateinfo_action` WHERE `class` = 11;

DELETE FROM `playercreateinfo_item` WHERE `class` = 10;
INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`, `Note`)
    SELECT `race`, 10, `itemid`, `amount`, `Note`
    FROM `playercreateinfo_item` WHERE `class` = 11;

-- ---- the stats a level is worth ----------------------------------------------------------------
-- This core reads player_race_stats and player_class_stats rather than the older
-- player_levelstats / player_classlevelstats, so the per-race half is already class-agnostic and
-- only the per-class half needs a row per level.
DELETE FROM `player_class_stats` WHERE `Class` = 10;
INSERT INTO `player_class_stats` (`Class`, `Level`, `Strength`, `Agility`, `Stamina`, `Intellect`,
                                  `Spirit`, `BaseHP`, `BaseMana`)
    SELECT 10, `Level`, `Strength`, `Agility`, `Stamina`, `Intellect`, `Spirit`, `BaseHP`,
           `BaseMana`
    FROM `player_class_stats` WHERE `Class` = 11;

-- ---- the mask tables ----------------------------------------------------------------------------
-- These key on a bitmask rather than on a class column: bit (class - 1), so class 11 is 1024 and
-- class 10 is 512. Wherever the donor's bit is set the new one is set beside it, and a row whose
-- mask is 0 already means every class and is left alone.
UPDATE `playercreateinfo_spell_custom` SET `classmask` = `classmask` | 512 WHERE `classmask` & 1024;
UPDATE `playercreateinfo_skills`       SET `classMask` = `classMask` | 512 WHERE `classMask` & 1024;
UPDATE `playercreateinfo_cast_spell`   SET `classMask` = `classMask` | 512 WHERE `classMask` & 1024;
