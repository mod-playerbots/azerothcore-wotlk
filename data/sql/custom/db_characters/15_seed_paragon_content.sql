-- Paragon: the configuration itself, asserted after every migration has run.
--
-- WHY THIS FILE EXISTS. The numbered migrations 07-14 transform a configuration they do not
-- create. The twenty statistic rows and the thirty-one `paragon_config` settings this realm
-- actually runs on were never in any SQL file -- they arrived with a database imported long ago,
-- and every later decision was applied on top of them by hand. A rebuild from an empty database
-- therefore produced a Paragon system with almost nothing in it, which is exactly what the
-- 2026-09-15 from-zero test was for.
--
-- Recovered from a mysqldump of the live acore_ale taken immediately before that test. This file
-- is the authority on the end state; 07-14 are kept because they record WHY each value is what it
-- is, and because they still have to run -- 07 rewrites the two validation triggers that 05
-- creates, and 08 widens `type_value` and adds the utility statistics.
--
-- Written as DELETE-then-INSERT rather than ON DUPLICATE KEY UPDATE so the result does not depend
-- on what the migrations happened to leave behind: ids 15 and 21 exist in no live row, and an
-- upsert would have left them in place. Re-runnable.
--
-- ORDER IS LOAD-BEARING. fk_category points paragon_config_statistic at
-- paragon_config_category, so every child row goes before any parent row is touched and
-- the parents come back before the children do. The first draft deleted the statistics,
-- re-inserted them, and only then tried to clear the categories -- which the constraint
-- refused, because the rows it had just inserted were pointing at them.

DELETE FROM `acore_ale`.`paragon_config_statistic`;
DELETE FROM `acore_ale`.`paragon_config_category`;

INSERT INTO `acore_ale`.`paragon_config_category` (`id`, `name`) VALUES
(1,'Defense'),
    (2,'Attack'),
    (3,'Magic'),
    (4,'Journey'),
    (5,'Other');

INSERT INTO `acore_ale`.`paragon_config_statistic`
    (`id`, `category`, `type`, `type_value`, `icon`, `factor`, `limit`, `application`) VALUES
(1,1,'UNIT_MODS','ARMOR','Interface/Icons/INV_Chest_Plate01',1,0,0),
    (2,1,'COMBAT_RATING','PARRY','Interface/Icons/Ability_Parry',1,0,0),
    (3,1,'COMBAT_RATING','BLOCK','Interface/Icons/Ability_Defend',1,0,0),
    (4,1,'COMBAT_RATING','DEFENSE_SKILL','Interface/Icons/Spell_Holy_MindSooth',1,0,0),
    (5,1,'COMBAT_RATING','DODGE','Interface/Icons/spell_arcane_blink',1,0,0),
    (6,2,'UNIT_MODS','STAT_STRENGTH','Interface/Icons/Ability_Warrior_InnerRage',1,0,0),
    (7,2,'UNIT_MODS','STAT_AGILITY','Interface/Icons/Ability_Rogue_Sprint',1,0,0),
    (8,2,'COMBAT_RATING','CRIT_MELEE','Interface/Icons/Ability_CriticalStrike',1,0,0),
    (9,2,'COMBAT_RATING','HASTE_MELEE','Interface/Icons/Spell_Nature_Bloodlust',1,0,0),
    (10,2,'COMBAT_RATING','ARMOR_PENETRATION','Interface/Icons/Ability_Warrior_Riposte',1,0,0),
    (11,3,'UNIT_MODS','STAT_INTELLECT','Interface/Icons/Spell_Holy_MagicalSentry',1,0,0),
    (12,3,'UNIT_MODS','STAT_SPIRIT','Interface/Icons/spell_holy_spiritualguidence',1,0,0),
    (13,3,'COMBAT_RATING','HIT_SPELL','Interface/Icons/Spell_Arcane_Blast',1,0,0),
    (14,3,'COMBAT_RATING','HASTE_SPELL','Interface/Icons/Spell_Frost_ManaBurn',1,0,0),
    (16,5,'AURA','MOVE_SPEED','Interface/Icons/Ability_Druid_Dash',1,50,0),
    (17,5,'AURA','SCAVENGER','Interface/Icons/INV_Misc_Bag_10_Blue',1,50,0),
    (18,5,'AURA','GOLD','Interface/Icons/INV_Misc_Coin_01',1,50,0),
    (19,5,'AURA','REPUTATION','Interface/Icons/Achievement_Reputation_01',1,50,0),
    (20,4,'AURA','CRAFTSMANSHIP','Interface/Icons/Trade_BlackSmithing',1,50,0),
    (22,5,'AURA','MOUNT_SPEED','Interface/Icons/Ability_Mount_RidingHorse',1,50,0);

DELETE FROM `acore_ale`.`paragon_config`;
INSERT INTO `acore_ale`.`paragon_config` (`field`, `value`) VALUES
('BASE_MAX_EXPERIENCE','100'),
    ('CATEGORIES_ALWAYS_UNLOCKED','4,5'),
    ('CRAFTSMANSHIP_MAX_PERCENT','25'),
    ('CRAFTSMANSHIP_PERCENT_PER_POINT','0.5'),
    ('DEFAULT_STAT_LIMIT','255'),
    ('ENABLE_PARAGON_SYSTEM','1'),
    ('EXPERIENCE_MULTIPLIER_HIGH_LEVEL','1'),
    ('EXPERIENCE_MULTIPLIER_LOW_LEVEL','3'),
    ('GOLD_MAX_PERCENT','25'),
    ('GOLD_PERCENT_PER_POINT','0.5'),
    ('HIGH_LEVEL_THRESHOLD','100'),
    ('LEVEL_LINKED_TO_ACCOUNT','0'),
    ('LOW_LEVEL_THRESHOLD','5'),
    ('MINIMUM_LEVEL_FOR_PARAGON_XP','60'),
    ('MOUNT_SPEED_MAX_PERCENT','25'),
    ('MOUNT_SPEED_PERCENT_PER_POINT','0.5'),
    ('MOVE_SPEED_MAX_PERCENT','25'),
    ('MOVE_SPEED_PERCENT_PER_POINT','0.5'),
    ('PARAGON_LEVEL_CAP','999'),
    ('PARAGON_STARTING_EXPERIENCE','1'),
    ('PARAGON_STARTING_LEVEL','1'),
    ('POINTS_PER_LEVEL','1'),
    ('REPUTATION_MAX_PERCENT','25'),
    ('REPUTATION_PERCENT_PER_POINT','0.5'),
    ('REQUIRE_PROGRESSION_MAX_LEVEL_FOR_PARAGON','1'),
    ('SCAVENGER_MAX_PERCENT','25'),
    ('SCAVENGER_PERCENT_PER_POINT','0.5'),
    ('UNIVERSAL_ACHIEVEVEMENT_EXPERIENCE','100'),
    ('UNIVERSAL_CREATURE_EXPERIENCE','50'),
    ('UNIVERSAL_QUEST_EXPERIENCE','75'),
    ('UNIVERSAL_SKILL_EXPERIENCE','25');
