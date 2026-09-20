-- ============================================================================
-- Paragon System - Remove the Experience Bonus AURA Statistic
-- ============================================================================
-- Removes the AURA stat (id 15, category 4) that boosted real character XP
-- gain via Hook.OnPlayerGiveXP in paragon_hook.lua. This is unrelated to the
-- Paragon system's own leveling (EXPERIENCE_SOURCE/UpdatePlayerExperience),
-- whose EXPERIENCE_MULTIPLIER_LOW_LEVEL/HIGH_LEVEL config fields stay untouched.
-- ============================================================================

DELETE FROM `acore_ale`.`paragon_config_statistic`
    WHERE `type` = 'AURA' AND `type_value` = 'EXPERIENCE';
DELETE FROM `acore_ale`.`paragon_config`
    WHERE `field` IN ('EXPERIENCE_PERCENT_PER_POINT', 'EXPERIENCE_MAX_PERCENT');
