-- ============================================================================
-- Paragon System - Progression Gate & Movement Speed Configuration
-- ============================================================================
-- Defaults for the individual progression gate and the movement speed
-- statistic. Every key here is optional: paragon_hook.lua falls back to the
-- same values when a row is missing (INSERT IGNORE keeps existing tuning).
-- ============================================================================

INSERT IGNORE INTO `acore_ale`.`paragon_config` (field, value) VALUES
-- Progression Gate
--   REQUIRE_PROGRESSION_MAX_LEVEL_FOR_PARAGON
--     1 = points may only be spent outside the always unlocked categories once
--         the character reaches the level cap of its individual progression
--         stage (60 in Vanilla, 70 in TBC, MaxPlayerLevel afterwards)
--     0 = every category is spendable at any level
--   CATEGORIES_ALWAYS_UNLOCKED
--     Comma separated category ids that stay spendable below that cap.
--     Defaults to the highest category id when the row is absent - pinning it
--     to 4 here means adding a 5th category will NOT move the gate by itself.
('REQUIRE_PROGRESSION_MAX_LEVEL_FOR_PARAGON', '1'),
('CATEGORIES_ALWAYS_UNLOCKED', '4'),

-- Movement Speed Statistic (AURA / MOVE_SPEED)
--   MOVE_SPEED_PERCENT_PER_POINT: run and swim speed gained per invested point
--   MOVE_SPEED_MAX_PERCENT: ceiling for the total bonus, in percent
--   50 points reach the ceiling. The bonus multiplies the rate the core
--   computed, so it applies while mounted as well.
('MOVE_SPEED_PERCENT_PER_POINT', '0.5'),
('MOVE_SPEED_MAX_PERCENT', '25'),

-- Experience, Gold and Reputation Statistics (AURA)
--   Same shape as above: percent per invested point, and a ceiling.
--   EXPERIENCE boosts character XP, GOLD boosts looted money only (trade and
--   mail are excluded on purpose), REPUTATION boosts the gain and not the
--   standing. LOOT has no keys - nothing implements it yet.
('EXPERIENCE_PERCENT_PER_POINT', '0.5'),
('EXPERIENCE_MAX_PERCENT', '25'),
('GOLD_PERCENT_PER_POINT', '0.5'),
('GOLD_MAX_PERCENT', '25'),
('REPUTATION_PERCENT_PER_POINT', '0.5'),
('REPUTATION_MAX_PERCENT', '25');

-- ============================================================================
-- Repair the validation triggers from 05_create_triggers.sql
-- ============================================================================
-- They were created with DEFINER='wowserver'@'%', a user that does not exist on
-- this server, so MySQL rejects every INSERT and UPDATE on the table with
-- ERROR 1449. Recreated without a DEFINER clause (the executing user owns them).
--
-- Their AURA whitelist is also incomplete: MOVE_SPEED and GOLD are valid values
-- of the type_value enum and are already seeded, but the triggers would reject
-- any update touching those rows.
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
        IF NEW.type_value NOT IN ('LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED') THEN
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
        IF NEW.type_value NOT IN ('LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid AURA value for this type.';
        END IF;
    END IF;
END//

DELIMITER ;

-- Keep each stat's own limit in step with the ceiling above, so the UI cannot
-- sink points into a bonus that has already stopped growing. LOOT keeps its
-- original limit: it is not implemented, so there is no ceiling to match.
UPDATE `acore_ale`.`paragon_config_statistic`
    SET `limit` = 50
    WHERE `type` = 'AURA' AND `type_value` IN ('MOVE_SPEED', 'EXPERIENCE', 'GOLD', 'REPUTATION');
