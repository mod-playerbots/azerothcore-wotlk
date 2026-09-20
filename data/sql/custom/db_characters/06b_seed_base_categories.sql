-- Paragon: the four base categories, which no file in this repository ever created.
--
-- Found by the from-zero rebuild on 2026-09-15. 06_insert_default_config.sql writes only the
-- key/value `paragon_config` table; category 5 comes from 08 and category 6 from 09; and
-- categories 1-4 came from nowhere at all -- they were in the database the realm was first built
-- from and had never been written down. Without them 10_merge_bonus_into_other.sql dies on
--
--   ERROR 1452 (23000): Cannot add or update a child row: a foreign key constraint fails
--   (`acore_ale`.`paragon_config_statistic`, CONSTRAINT `fk_category` ...)
--
-- because it sets `category` = 4 against a category table that only has 5 and 6 in it.
--
-- The names are exact, not guessed: 12_reorder_other_last.sql swaps ids 4 and 5 through a
-- temporary 99, and the live table ends at 4='Journey', 5='Other' -- so before that swap 4 was
-- 'Other' and 'Journey' was the id 5 that 08 inserts. Everything else is unchanged by any
-- migration.
INSERT INTO `acore_ale`.`paragon_config_category` (`id`, `name`) VALUES
    (1, 'Defense'),
    (2, 'Attack'),
    (3, 'Magic'),
    (4, 'Other')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
