-- ============================================================================
-- Paragon System - Utility Statistics
-- ============================================================================
-- Adds four statistics handled natively by paragon_hook.lua (no spell needed):
--   CRAFTSMANSHIP - chance for an extra skill point on profession skill ups
--   SCAVENGER     - chance for an extra copy of a looted item
--   RECOVERY      - out of combat health and mana regeneration
--   MOUNT_SPEED   - extra speed while mounted, on top of MOVE_SPEED
--
-- SCAVENGER replaces LOOT in place: LOOT was seeded against spell 1900000,
-- which exists in no Spell.dbc, so it never did anything at all.
-- ============================================================================

-- The type_value enum has to learn the new names before anything can use them
ALTER TABLE `acore_ale`.`paragon_config_statistic`
    MODIFY COLUMN `type_value` ENUM(
        'WEAPON_SKILL', 'DEFENSE_SKILL', 'DODGE', 'PARRY', 'BLOCK',
        'HIT_MELEE', 'HIT_RANGED', 'HIT_SPELL',
        'CRIT_MELEE', 'CRIT_RANGED', 'CRIT_SPELL',
        'HIT_TAKEN_MELEE', 'HIT_TAKEN_RANGED', 'HIT_TAKEN_SPELL',
        'CRIT_TAKEN_MELEE', 'CRIT_TAKEN_RANGED', 'CRIT_TAKEN_SPELL',
        'HASTE_MELEE', 'HASTE_RANGED', 'HASTE_SPELL',
        'WEAPON_SKILL_MAINHAND', 'WEAPON_SKILL_OFFHAND', 'WEAPON_SKILL_RANGED',
        'EXPERTISE', 'ARMOR_PENETRATION',
        'STAT_STRENGTH', 'STAT_AGILITY', 'STAT_STAMINA', 'STAT_INTELLECT', 'STAT_SPIRIT',
        'HEALTH', 'MANA', 'RAGE', 'FOCUS', 'ENERGY', 'HAPPINESS', 'RUNE', 'RUNIC_POWER',
        'ARMOR',
        'RESISTANCE_HOLY', 'RESISTANCE_FIRE', 'RESISTANCE_NATURE',
        'RESISTANCE_FROST', 'RESISTANCE_SHADOW', 'RESISTANCE_ARCANE',
        'ATTACK_POWER', 'ATTACK_POWER_RANGED',
        'DAMAGE_MAINHAND', 'DAMAGE_OFFHAND', 'DAMAGE_RANGED',
        'LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED',
        'CRAFTSMANSHIP', 'SCAVENGER', 'RECOVERY', 'MOUNT_SPEED'
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'STAT_STRENGTH';

-- ============================================================================
-- Validation triggers - final AURA whitelist
-- ============================================================================
-- Supersedes the version in 07: the new names have to pass validation, or every
-- INSERT and UPDATE below is rejected. See 07 for why they are recreated at all
-- (the shipped ones name a DEFINER that does not exist).
-- ============================================================================

DROP TRIGGER IF EXISTS `acore_ale`.`paragon_config_statistics_before_insert`;
DROP TRIGGER IF EXISTS `acore_ale`.`paragon_config_statistics_before_update`;

DELIMITER //

CREATE TRIGGER `acore_ale`.`paragon_config_statistics_before_insert`
BEFORE INSERT ON `acore_ale`.`paragon_config_statistic`
FOR EACH ROW
BEGIN
    IF NEW.type = 'COMBAT_RATING' THEN
        IF NEW.type_value NOT IN (
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

    IF NEW.type = 'UNIT_MODS' THEN
        IF NEW.type_value NOT IN (
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

    IF NEW.type = 'AURA' THEN
        IF NEW.type_value NOT IN (
            'LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED',
            'CRAFTSMANSHIP', 'SCAVENGER', 'RECOVERY', 'MOUNT_SPEED'
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid AURA value for this type.';
        END IF;
    END IF;
END//

CREATE TRIGGER `acore_ale`.`paragon_config_statistics_before_update`
BEFORE UPDATE ON `acore_ale`.`paragon_config_statistic`
FOR EACH ROW
BEGIN
    IF NEW.type = 'COMBAT_RATING' THEN
        IF NEW.type_value NOT IN (
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

    IF NEW.type = 'UNIT_MODS' THEN
        IF NEW.type_value NOT IN (
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

    IF NEW.type = 'AURA' THEN
        IF NEW.type_value NOT IN (
            'LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED',
            'CRAFTSMANSHIP', 'SCAVENGER', 'RECOVERY', 'MOUNT_SPEED'
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid AURA value for this type.';
        END IF;
    END IF;
END//

DELIMITER ;

-- ============================================================================
-- Category & statistics
-- ============================================================================
-- The panel lays out five statistics per row, so the new ones get their own
-- category rather than overflowing "Other". The client turns the name into the
-- locale key JOURNEY_TEXT.
-- ============================================================================

INSERT INTO `acore_ale`.`paragon_config_category` (id, name) VALUES
(5, 'Journey')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- LOOT never worked; SCAVENGER takes its slot, icon and any invested points
UPDATE `acore_ale`.`paragon_config_statistic`
    SET `type_value` = 'SCAVENGER', `limit` = 50
    WHERE `id` = 17 AND `type` = 'AURA' AND `type_value` = 'LOOT';

-- Experience belongs with the other levelling aids rather than in "Other"
UPDATE `acore_ale`.`paragon_config_statistic`
    SET `category` = 5
    WHERE `type` = 'AURA' AND `type_value` = 'EXPERIENCE';

DELETE FROM `acore_ale`.`paragon_config_statistic` WHERE `id` IN (20, 21, 22);
INSERT INTO `acore_ale`.`paragon_config_statistic` (id, category, type, type_value, icon, factor, `limit`, application) VALUES
(20, 5, 'AURA', 'CRAFTSMANSHIP', 'Interface/Icons/Trade_BlackSmithing', 1, 50, 0),
(21, 5, 'AURA', 'RECOVERY', 'Interface/Icons/Spell_Holy_Renew', 1, 50, 0),
(22, 5, 'AURA', 'MOUNT_SPEED', 'Interface/Icons/Ability_Mount_RidingHorse', 1, 50, 0);

-- ============================================================================
-- Configuration defaults
-- ============================================================================
-- RECOVERY is percent of maximum health and mana restored per upkeep tick
-- (3 seconds) while out of combat, hence the much smaller numbers.
-- ============================================================================

INSERT IGNORE INTO `acore_ale`.`paragon_config` (field, value) VALUES
('CRAFTSMANSHIP_PERCENT_PER_POINT', '0.5'),
('CRAFTSMANSHIP_MAX_PERCENT', '25'),
('SCAVENGER_PERCENT_PER_POINT', '0.5'),
('SCAVENGER_MAX_PERCENT', '25'),
('RECOVERY_PERCENT_PER_POINT', '0.1'),
('RECOVERY_MAX_PERCENT', '5'),
('MOUNT_SPEED_PERCENT_PER_POINT', '0.5'),
('MOUNT_SPEED_MAX_PERCENT', '25');

-- The new category is utility only, so it stays spendable while levelling
UPDATE `acore_ale`.`paragon_config`
    SET value = '4,5'
    WHERE field = 'CATEGORIES_ALWAYS_UNLOCKED';
