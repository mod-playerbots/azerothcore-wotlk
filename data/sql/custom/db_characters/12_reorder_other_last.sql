-- ============================================================================
-- Paragon System - Move "Other" to the Last Row
-- ============================================================================
-- The client sorts categories by their numeric id (see UIParagon_OnReceiveAllData
-- in Paragon_Network.lua: order = cat_id), so display order is just id order.
-- Swaps ids 4 (Other) and 5 (Journey) via a temp id to dodge the id UNIQUE key
-- during the swap. paragon_config_statistic.category follows automatically via
-- its ON UPDATE CASCADE foreign key - no need to touch that table directly.
-- CATEGORIES_ALWAYS_UNLOCKED stays "4,5": both ids are still in that set, they
-- have just traded which category name owns which id.
-- ============================================================================

UPDATE `acore_ale`.`paragon_config_category` SET `id` = 99 WHERE `id` = 5;
UPDATE `acore_ale`.`paragon_config_category` SET `id` = 5 WHERE `id` = 4;
UPDATE `acore_ale`.`paragon_config_category` SET `id` = 4 WHERE `id` = 99;
