-- ============================================================================
-- Paragon System - Gate Reputation, Gold and Mount Speed Behind Max Level
-- ============================================================================
-- Reputation Bonus (19), Gold Bonus (18) and Mount Speed (22) live in
-- categories 4 ("Other") and 5 ("Journey"), which CATEGORIES_ALWAYS_UNLOCKED
-- (see 07_insert_progression_config.sql) keeps spendable below the individual
-- progression level cap, so players can boost XP/gold/move speed while
-- levelling.
--
-- These three do not help levelling itself, so they are pulled into their own
-- category instead. It is deliberately NOT added to CATEGORIES_ALWAYS_UNLOCKED,
-- so paragon_hook.lua's IsCategoryUnlocked() gates it the same way it already
-- gates Defense/Attack/Magic - locked (dimmed, tooltip "Unlocks at level X",
-- input refused client and server side) until the character reaches the level
-- cap of its individual progression stage. Already invested points keep
-- applying their bonus either way, same as the other gated categories.
-- ============================================================================

INSERT INTO `acore_ale`.`paragon_config_category` (id, name) VALUES
(6, 'Bonus')
ON DUPLICATE KEY UPDATE name = VALUES(name);

UPDATE `acore_ale`.`paragon_config_statistic`
    SET `category` = 6
    WHERE `id` IN (18, 19, 22)
      AND `type` = 'AURA' AND `type_value` IN ('GOLD', 'REPUTATION', 'MOUNT_SPEED');
