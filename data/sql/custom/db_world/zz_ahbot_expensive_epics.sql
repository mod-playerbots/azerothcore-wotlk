-- =====================================================================
-- mod-ah-bot: make epic (and better) items EXPENSIVE
--
-- Applied automatically: this file lives in data/sql/custom/db_world, one of the directories
-- AzerothCore's updater scans. Re-runnable.
--
-- The "zz_" prefix is load-bearing. UpdateFetcher merges every .sql it finds -- core updates,
-- custom directories and every enabled module's data/sql -- into ONE set ordered by FILENAME
-- alone, ignoring which directory the file came from (UpdateFetcher.cpp, PathCompare). The
-- module file that owns this table, modules/mod-ah-bot/data/sql/db-world/mod_auctionhousebot.sql,
-- opens with DROP TABLE IF EXISTS. Under the original name this file sorted at "a", ahead of
-- "mod_...", so on a realm built from zero it would have run against a table that does not exist
-- yet -- and on any later run the module's DROP would have thrown these prices away. "zz_" puts
-- it after both mod_auctionhousebot.sql and the module's own z_filter_disabled_and_trash.sql.
--
-- Prices here are a PERCENTAGE of the item's vendor value:
--     buyout = vendorSellPrice * random(minprice, maxprice) / 100
-- (see modules/mod-ah-bot/src/AuctionHouseBot.cpp)
-- So 15000 == 150x the item's vendor price.
--
-- Applies to all three auction houses: 2 = Alliance, 6 = Horde, 7 = Neutral.
-- After running, restart worldserver (values are read from this table at
-- startup), or set them live in-game with:
--     .ahbotoptions minprice <ahMapID> purple <price>
--     .ahbotoptions maxprice <ahMapID> purple <price>
-- =====================================================================

-- Epic (purple): very expensive
UPDATE `acore_world`.`mod_auctionhousebot`
SET `minpricepurple` = 15000, `maxpricepurple` = 30000
WHERE `auctionhouse` IN (2, 6, 7);

-- Legendary (orange): even more expensive
UPDATE `acore_world`.`mod_auctionhousebot`
SET `minpriceorange` = 40000, `maxpriceorange` = 80000
WHERE `auctionhouse` IN (2, 6, 7);

-- Artifact (yellow): most expensive
UPDATE `acore_world`.`mod_auctionhousebot`
SET `minpriceyellow` = 60000, `maxpriceyellow` = 120000
WHERE `auctionhouse` IN (2, 6, 7);

-- ---------------------------------------------------------------------
-- ALTERNATIVE: remove epics/legendaries/artifacts from the AH entirely.
-- (The bot fills the AH by quality quotas; zeroing these stops it listing
--  those qualities. Uncomment and run INSTEAD of the price changes above.)
-- ---------------------------------------------------------------------
-- UPDATE `acore_world`.`mod_auctionhousebot`
-- SET `percentpurpleitems`      = 0, `percentpurpletradegoods` = 0,
--     `percentorangeitems`      = 0, `percentorangetradegoods` = 0,
--     `percentyellowitems`      = 0, `percentyellowtradegoods` = 0
-- WHERE `auctionhouse` IN (2, 6, 7);
