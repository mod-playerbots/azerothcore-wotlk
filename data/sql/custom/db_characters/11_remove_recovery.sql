-- ============================================================================
-- Paragon System - Remove the RECOVERY Statistic
-- ============================================================================
-- Health/mana-on-upkeep-tick statistic removed entirely: config row, per-point
-- override config, and the server-side UpkeepRecovery handler (removed from
-- paragon_hook.lua directly, not migrated here). No character had points
-- invested in it at removal time (character_paragon_stats keys on stat_id
-- only, nothing else to clean up).
-- ============================================================================

DELETE FROM `acore_ale`.`paragon_config_statistic`
    WHERE `type` = 'AURA' AND `type_value` = 'RECOVERY';

DELETE FROM `acore_ale`.`paragon_config`
    WHERE `field` IN ('RECOVERY_PERCENT_PER_POINT', 'RECOVERY_MAX_PERCENT');
