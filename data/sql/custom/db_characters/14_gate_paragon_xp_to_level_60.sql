-- ============================================================================
-- Paragon System - Gate Paragon XP Behind Level 60
-- ============================================================================
-- UpdatePlayerExperience (paragon_hook.lua) already reads this field and
-- refuses to award Paragon points below it. Was 1 (effectively unlocked from
-- the start); raised to 60 so characters must reach max classic level first.
-- ============================================================================

UPDATE `acore_ale`.`paragon_config`
    SET `value` = '60'
    WHERE `field` = 'MINIMUM_LEVEL_FOR_PARAGON_XP';
