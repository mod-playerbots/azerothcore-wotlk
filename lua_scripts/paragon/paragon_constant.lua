--- Paragon System Constants
-- This module defines all constants used by the paragon system including
-- database configuration, SQL queries, and statistic type enumerations
-- @module paragon_constant

return {
    --- Database name used for paragon system tables
    DB_NAME = "acore_ale",

    --- SQL queries for database operations
    -- Contains all CREATE and SELECT statements for paragon tables
    QUERY = {
        -- Database creation query
        CR_DB = "CREATE DATABASE IF NOT EXISTS `%s`;",

        --- Category Configuration Table
        -- Stores paragon statistic categories (e.g., Combat, Stats, etc.)
        CR_TABLE_CONFIG_CAT = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_category` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `name` VARCHAR(50) NOT NULL,

                PRIMARY KEY (`id`)
            );
        ]],

        -- Select all categories
        SEL_CONFIG_CAT = "SELECT `id`, `name` FROM `%s`.`paragon_config_category`;",

        --- Statistic Configuration Table
        -- Defines available paragon statistics with their properties
        -- type: AURA, COMBAT_RATING, or UNIT_MODS
        -- factor: Multiplier for each point invested
        -- limit: Maximum points that can be invested
        -- application: How the stat bonus is applied
        CR_TABLE_CONFIG_STAT = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_statistic` (
                `id` INT NOT NULL AUTO_INCREMENT,
                `category` INT NOT NULL DEFAULT 1,
                `type` ENUM('AURA','COMBAT_RATING','UNIT_MODS') NOT NULL DEFAULT 'AURA',
                `type_value` INT NOT NULL DEFAULT 0,
                `icon` VARCHAR(50) NOT NULL DEFAULT '0',
                `factor` INT NOT NULL DEFAULT 1,
                `limit` INT(3) NOT NULL DEFAULT 255,
                `application` INT NOT NULL DEFAULT 0,

                PRIMARY KEY (`id`),
                CONSTRAINT `fk_category`
                    FOREIGN KEY (`category`)
                    REFERENCES `%s`.`paragon_config_category`(`id`)
                        ON UPDATE CASCADE
                        ON DELETE NO ACTION
            );
        ]],

        --- Configuration Statistic BEFORE INSERT Trigger
        -- Validates that type_value matches the selected type
        CT_TRIGGER_BU_CONFIG_STAT = [[
            CREATE TRIGGER IF NOT EXISTS `%s`.`paragon_config_statistics_before_insert`
            BEFORE INSERT ON `%s`.`paragon_config_statistic`
            FOR EACH ROW
            BEGIN
                DECLARE v_type VARCHAR(50);
                DECLARE v_value VARCHAR(50);

                SET v_type = NEW.type;
                SET v_value = NEW.type_value;

                IF v_type = 'COMBAT_RATING' THEN
                    IF v_value NOT IN (
                        'WEAPON_SKILL', 'DEFENSE_SKILL', 'DODGE', 'PARRY', 'BLOCK',
                        'HIT_MELEE', 'HIT_RANGED', 'HIT_SPELL',
                        'CRIT_MELEE', 'CRIT_RANGED', 'CRIT_SPELL',
                        'HIT_TAKEN_MELEE', 'HIT_TAKEN_RANGED', 'HIT_TAKEN_SPELL',
                        'CRIT_TAKEN_MELEE', 'CRIT_TAKEN_RANGED', 'CRIT_TAKEN_SPELL',
                        'HASTE_MELEE', 'HASTE_RANGED', 'HASTE_SPELL',
                        'WEAPON_SKILL_MAINHAND', 'WEAPON_SKILL_OFFHAND', 'WEAPON_SKILL_RANGED',
                        'EXPERTISE', 'ARMOR_PENETRATION'
                    ) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid COMBAT_RATING value for this type.';
                    END IF;
                END IF;

                IF v_type = 'UNIT_MODS' THEN
                    IF v_value NOT IN (
                        'STAT_STRENGTH', 'STAT_AGILITY', 'STAT_STAMINA', 'STAT_INTELLECT', 'STAT_SPIRIT',
                        'HEALTH', 'MANA', 'RAGE', 'FOCUS', 'ENERGY', 'HAPPINESS',
                        'RUNE', 'RUNIC_POWER', 'ARMOR',
                        'RESISTANCE_HOLY', 'RESISTANCE_FIRE', 'RESISTANCE_NATURE', 'RESISTANCE_FROST', 'RESISTANCE_SHADOW', 'RESISTANCE_ARCANE',
                        'ATTACK_POWER', 'ATTACK_POWER_RANGED',
                        'DAMAGE_MAINHAND', 'DAMAGE_OFFHAND', 'DAMAGE_RANGED'
                    ) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid UNIT_MODS value for this type.';
                    END IF;
                END IF;

                IF v_type = 'AURA' THEN
                    IF v_value NOT IN ('LOOT', 'REPUTATION', 'EXPERIENCE') THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid AURA value for this type.';
                    END IF;
                END IF;
            END;
        ]],

        --- Configuration Statistic BEFORE UPDATE Trigger
        -- Validates that type_value matches the selected type
        CT_TRIGGER_BI_CONFIG_STAT = [[
            CREATE TRIGGER IF NOT EXISTS `%s`.`paragon_config_statistics_before_update`
            BEFORE UPDATE ON `%s`.`paragon_config_statistic`
            FOR EACH ROW
            BEGIN
                DECLARE v_type VARCHAR(50);
                DECLARE v_value VARCHAR(50);

                SET v_type = NEW.type;
                SET v_value = NEW.type_value;

                IF v_type = 'COMBAT_RATING' THEN
                    IF v_value NOT IN (
                        'WEAPON_SKILL', 'DEFENSE_SKILL', 'DODGE', 'PARRY', 'BLOCK',
                        'HIT_MELEE', 'HIT_RANGED', 'HIT_SPELL',
                        'CRIT_MELEE', 'CRIT_RANGED', 'CRIT_SPELL',
                        'HIT_TAKEN_MELEE', 'HIT_TAKEN_RANGED', 'HIT_TAKEN_SPELL',
                        'CRIT_TAKEN_MELEE', 'CRIT_TAKEN_RANGED', 'CRIT_TAKEN_SPELL',
                        'HASTE_MELEE', 'HASTE_RANGED', 'HASTE_SPELL',
                        'WEAPON_SKILL_MAINHAND', 'WEAPON_SKILL_OFFHAND', 'WEAPON_SKILL_RANGED',
                        'EXPERTISE', 'ARMOR_PENETRATION'
                    ) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid COMBAT_RATING value for this type.';
                    END IF;
                END IF;

                IF v_type = 'UNIT_MODS' THEN
                    IF v_value NOT IN (
                        'STAT_STRENGTH', 'STAT_AGILITY', 'STAT_STAMINA', 'STAT_INTELLECT', 'STAT_SPIRIT',
                        'HEALTH', 'MANA', 'RAGE', 'FOCUS', 'ENERGY', 'HAPPINESS',
                        'RUNE', 'RUNIC_POWER', 'ARMOR',
                        'RESISTANCE_HOLY', 'RESISTANCE_FIRE', 'RESISTANCE_NATURE', 'RESISTANCE_FROST', 'RESISTANCE_SHADOW', 'RESISTANCE_ARCANE',
                        'ATTACK_POWER', 'ATTACK_POWER_RANGED',
                        'DAMAGE_MAINHAND', 'DAMAGE_OFFHAND', 'DAMAGE_RANGED'
                    ) THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid UNIT_MODS value for this type.';
                    END IF;
                END IF;

                IF v_type = 'AURA' THEN
                    IF v_value NOT IN ('LOOT', 'REPUTATION', 'EXPERIENCE') THEN
                        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid AURA value for this type.';
                    END IF;
                END IF;
            END;
        ]],

        -- Select all statistic configurations
        SEL_CONFIG_STAT = "SELECT `id`, `category`, `type`, `type_value`, `icon`, `factor`, `limit`, `application` FROM `%s`.`paragon_config_statistic`;",

        --- General Configuration Table
        -- Stores key-value pairs for general paragon settings
        -- Uses field as primary key for efficient lookups and prevents duplicate keys
        CR_TABLE_CONFIG = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config` (
                `field` VARCHAR(255) NOT NULL,
                `value` VARCHAR(255) NOT NULL,

                PRIMARY KEY (`field`)
            );
        ]],

        -- Select all configuration settings
        SEL_CONFIG = "SELECT `field`, `value` FROM `%s`.`paragon_config`;",

        --- Character Paragon Table (Character-Linked)
        -- Stores each character's paragon level and experience when LEVEL_LINKED_TO_ACCOUNT = 0
        CR_TABLE_PARA_CHARACTER = [[
            CREATE TABLE IF NOT EXISTS `%s`.`character_paragon` (
                `guid` INT(11) NOT NULL,
                `level` INT(11) NOT NULL DEFAULT 1,
                `experience` INT(11) NOT NULL DEFAULT 0,

                PRIMARY KEY (`guid`)
            );
        ]],

        --- Account Paragon Table (Account-Linked)
        -- Stores account-wide paragon level and experience when LEVEL_LINKED_TO_ACCOUNT = 1
        CR_TABLE_PARA_ACCOUNT = [[
            CREATE TABLE IF NOT EXISTS `%s`.`account_paragon` (
                `account_id` INT(11) NOT NULL,
                `level` INT(11) NOT NULL DEFAULT 1,
                `experience` INT(11) NOT NULL DEFAULT 0,

                PRIMARY KEY (`account_id`)
            );
        ]],

        -- Select paragon level and experience for a character (character-linked)
        SEL_PARA_CHARACTER = "SELECT level, experience FROM `%s`.`character_paragon` WHERE guid = %d;",

        -- Select paragon level and experience for an account (account-linked)
        SEL_PARA_ACCOUNT = "SELECT level, experience FROM `%s`.`account_paragon` WHERE account_id = %d;",

        -- Insert new character paragon record (character-linked)
        INS_PARA_CHARACTER = "INSERT INTO `%s`.`character_paragon` (guid, level, experience) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE level = VALUES(level), experience = VALUES(experience);",

        -- Insert new account paragon record (account-linked)
        INS_PARA_ACCOUNT = "INSERT INTO `%s`.`account_paragon` (account_id, level, experience) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE level = VALUES(level), experience = VALUES(experience);",

        -- Delete character paragon record
        DEL_PARA_CHARACTER = "DELETE FROM `%s`.`character_paragon` WHERE guid = %d;",

        -- Delete account paragon record
        DEL_PARA_ACCOUNT = "DELETE FROM `%s`.`account_paragon` WHERE account_id = %d;",

        --- Character Paragon Statistics Table
        -- Stores stat points invested by each character
        CR_TABLE_PARA_STAT = [[
            CREATE TABLE IF NOT EXISTS `%s`.`character_paragon_stats` (
                `guid` INT(11) NOT NULL,
                `stat_id` INT(11) NOT NULL,
                `stat_value` INT(11) NOT NULL,

                PRIMARY KEY (`guid`, `stat_id`)
            );
        ]],

        -- Select all statistics for a character
        SEL_PARA_STAT = "SELECT stat_id, stat_value FROM `%s`.`character_paragon_stats` WHERE guid = %d;",

        INS_PARA_STAT = "INSERT INTO `%s`.`character_paragon_stats` (guid, stat_id, stat_value) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE stat_value = VALUES(stat_value);",

        -- Delete all statistics for a character
        DEL_PARA_STAT = "DELETE FROM `%s`.`character_paragon_stats` WHERE guid = %d;",

        --- Experience Reward Configuration Tables
        -- Stores experience rewards for specific sources
        -- Entry IDs from: creatures, achievements, skills, quests
        CR_TABLE_CONFIG_EXP_CREATURE = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_experience_creature` (
                `id` INT(11) NOT NULL,
                `experience` INT(11) NOT NULL DEFAULT 50,

                PRIMARY KEY (`id`)
            );
        ]],

        CR_TABLE_CONFIG_EXP_ACHIEVEMENT = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_experience_achievement` (
                `id` INT(11) NOT NULL,
                `experience` INT(11) NOT NULL DEFAULT 100,

                PRIMARY KEY (`id`)
            );
        ]],

        CR_TABLE_CONFIG_EXP_SKILL = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_experience_skill` (
                `id` INT(11) NOT NULL,
                `experience` INT(11) NOT NULL DEFAULT 25,

                PRIMARY KEY (`id`)
            );
        ]],

        CR_TABLE_CONFIG_EXP_QUEST = [[
            CREATE TABLE IF NOT EXISTS `%s`.`paragon_config_experience_quest` (
                `id` INT(11) NOT NULL,
                `experience` INT(11) NOT NULL DEFAULT 75,

                PRIMARY KEY (`id`)
            );
        ]],

        -- Select all creature experience overrides
        SEL_CONFIG_EXP_CREATURE = "SELECT id, experience FROM `%s`.`paragon_config_experience_creature`;",

        -- Select all achievement experience overrides
        SEL_CONFIG_EXP_ACHIEVEMENT = "SELECT id, experience FROM `%s`.`paragon_config_experience_achievement`;",

        -- Select all skill experience overrides
        SEL_CONFIG_EXP_SKILL = "SELECT id, experience FROM `%s`.`paragon_config_experience_skill`;",

        -- Select all quest experience overrides
        SEL_CONFIG_EXP_QUEST = "SELECT id, experience FROM `%s`.`paragon_config_experience_quest`;",

        --- Default Configuration Values
        -- Insert default paragon system configuration settings
        -- These are loaded on first server start if not already present
        INS_DEFAULT_CONFIG = [[
            INSERT IGNORE INTO `%s`.`paragon_config` (field, value) VALUES
            -- System Control
            ('ENABLE_PARAGON_SYSTEM', '1'),
            ('MINIMUM_LEVEL_FOR_PARAGON_XP', '0'),
            ('PARAGON_LEVEL_CAP', '999'),
            ('LEVEL_LINKED_TO_ACCOUNT', '0'),

            -- Progression Settings
            ('BASE_MAX_EXPERIENCE', '1000'),
            ('POINTS_PER_LEVEL', '1'),
            ('PARAGON_STARTING_LEVEL', '1'),
            ('PARAGON_STARTING_EXPERIENCE', '0'),

            -- Experience Rewards (Universal Defaults)
            ('UNIVERSAL_CREATURE_EXPERIENCE', '50'),
            ('UNIVERSAL_ACHIEVEVEMENT_EXPERIENCE', '100'),
            ('UNIVERSAL_SKILL_EXPERIENCE', '25'),
            ('UNIVERSAL_QUEST_EXPERIENCE', '75'),

            -- Experience Multipliers
            ('EXPERIENCE_MULTIPLIER_LOW_LEVEL', '1.5'),
            ('EXPERIENCE_MULTIPLIER_HIGH_LEVEL', '0.8'),
            ('LOW_LEVEL_THRESHOLD', '5'),
            ('HIGH_LEVEL_THRESHOLD', '100'),

            -- Point Customization
            ('DEFAULT_STAT_LIMIT', '255');
        ]]
    },

    --- Statistic Type Enumerations
    -- Defines the available statistic types that can be enhanced through the paragon system
    STATISTICS = {
        --- Combat Rating Statistics
        -- These affect combat performance metrics like hit chance, crit, haste, etc.
        COMBAT_RATING = {
            WEAPON_SKILL            = 0,
            DEFENSE_SKILL           = 1,
            DODGE                   = 2,
            PARRY                   = 3,
            BLOCK                   = 4,
            HIT_MELEE               = 5,
            HIT_RANGED              = 6,
            HIT_SPELL               = 7,
            CRIT_MELEE              = 8,
            CRIT_RANGED             = 9,
            CRIT_SPELL              = 10,
            HIT_TAKEN_MELEE         = 11,
            HIT_TAKEN_RANGED        = 12,
            HIT_TAKEN_SPELL         = 13,
            CRIT_TAKEN_MELEE        = 14,
            CRIT_TAKEN_RANGED       = 15,
            CRIT_TAKEN_SPELL        = 16,
            HASTE_MELEE             = 17,
            HASTE_RANGED            = 18,
            HASTE_SPELL             = 19,
            WEAPON_SKILL_MAINHAND   = 20,
            WEAPON_SKILL_OFFHAND    = 21,
            WEAPON_SKILL_RANGED     = 22,
            EXPERTISE               = 23,
            ARMOR_PENETRATION       = 24
        },

        --- Unit Modifier Statistics
        -- These affect base character attributes and resources
        UNIT_MODS = {
            STAT_STRENGTH           = 0,
            STAT_AGILITY            = 1,
            STAT_STAMINA            = 2,
            STAT_INTELLECT          = 3,
            STAT_SPIRIT             = 4,
            HEALTH                  = 5,
            MANA                    = 6,
            RAGE                    = 7,
            FOCUS                   = 8,
            ENERGY                  = 9,
            HAPPINESS               = 10,
            RUNE                    = 11,
            RUNIC_POWER             = 12,
            ARMOR                   = 13,
            RESISTANCE_HOLY         = 14,
            RESISTANCE_FIRE         = 15,
            RESISTANCE_NATURE       = 16,
            RESISTANCE_FROST        = 17,
            RESISTANCE_SHADOW       = 18,
            RESISTANCE_ARCANE       = 19,
            ATTACK_POWER            = 20,
            ATTACK_POWER_RANGED     = 21,
            DAMAGE_MAINHAND         = 22,
            DAMAGE_OFFHAND          = 23,
            DAMAGE_RANGED           = 24,
        },

        --- Aura-based Bonuses
        -- Custom aura IDs for special bonuses like loot, reputation, and experience
        AURA = {
            LOOT                    = 1900000,
            REPUTATION              = 1900001
        }
    }
}