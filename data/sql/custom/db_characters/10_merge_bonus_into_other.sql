-- ============================================================================
-- Paragon System - Merge "Bonus" Category Back Into "Other"
-- ============================================================================
-- Reverses 09_lock_bonus_stats.sql: Reputation Bonus (19), Gold Bonus (18) and
-- Mount Speed (22) move back into category 4 ("Other"), and category 6
-- ("Bonus") is removed. These stats are now spendable pre-level-cap the same
-- as the rest of "Other", instead of being gated behind full Paragon unlock.
--
-- character_paragon_stats keys on stat_id only (no category column), so
-- already-invested points in these stats carry over unaffected.
-- ============================================================================

UPDATE `acore_ale`.`paragon_config_statistic`
    SET `category` = 4
    WHERE `id` IN (18, 19, 22)
      AND `type` = 'AURA' AND `type_value` IN ('GOLD', 'REPUTATION', 'MOUNT_SPEED');

DELETE FROM `acore_ale`.`paragon_config_category` WHERE `id` = 6;
