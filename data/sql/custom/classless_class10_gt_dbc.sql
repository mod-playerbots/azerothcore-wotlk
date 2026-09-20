-- The gt* scalar tables for class 10, fixed where the core actually reads them.
--
-- These nine tables exist twice. DBCStores.cpp loads each from data/dbc/gt*.dbc AND from a world
-- database table of the same name -- LOAD_DBC(sGtChanceToMeleeCritStore, "gtChanceToMeleeCrit.dbc",
-- "gtchancetomeleecrit_dbc") -- and the database copy is the one that ends up in memory. So a
-- corrected .dbc file on disk changes nothing on its own: the Adventurer kept showing Crit Chance
-- 40.84% from `gtchancetomeleecritbase_dbc` row 9 holding 0.2 and `gtchancetomeleecrit_dbc` row 900
-- holding 0.01, which are Blizzard's placeholders for the class slot nobody shipped.
--
-- 0.2 + 21 agility * 0.01 = 0.41. That is where the number came from.
--
-- Class 10's block is overwritten from the Druid's, the same donor the .dbc files use, so the two
-- copies agree. Indexing differs between the tables and is taken from the data rather than assumed:
-- the per-level tables are 0-based, 100 levels per class, so class 10 is 900..999 and the Druid
-- 1000..1099; the two base tables are one row per class, 0-based, so 9 and 10.
-- gtoctclasscombatratingscalar_dbc is the odd one -- 1-BASED ids 1..352, 32 combat ratings per
-- class -- so class 10 is 289..320 and the Druid 321..352. Writing +100 there would have hit the
-- wrong block entirely.
--
-- Re-runnable: every statement reads the Druid's row and writes class 10's, so a second run is a
-- no-op. gtOCTRegenMP has no table here because the core does not load it (DBCStores.cpp:334 is
-- commented out).

-- one row per class, 0-based
UPDATE `gtchancetomeleecritbase_dbc` SET `Data` = (SELECT `Data` FROM (SELECT * FROM `gtchancetomeleecritbase_dbc`) x WHERE x.`ID` = 10) WHERE `ID` = 9;
UPDATE `gtchancetospellcritbase_dbc` SET `Data` = (SELECT `Data` FROM (SELECT * FROM `gtchancetospellcritbase_dbc`) x WHERE x.`ID` = 10) WHERE `ID` = 9;

-- 100 levels per class, 0-based: class 10 = 900..999, Druid = 1000..1099
UPDATE `gtchancetomeleecrit_dbc` t JOIN (SELECT * FROM `gtchancetomeleecrit_dbc`) s ON s.`ID` = t.`ID` + 100 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 900 AND 999;
UPDATE `gtchancetospellcrit_dbc` t JOIN (SELECT * FROM `gtchancetospellcrit_dbc`) s ON s.`ID` = t.`ID` + 100 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 900 AND 999;
UPDATE `gtoctregenhp_dbc`        t JOIN (SELECT * FROM `gtoctregenhp_dbc`)        s ON s.`ID` = t.`ID` + 100 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 900 AND 999;
UPDATE `gtregenhpperspt_dbc`     t JOIN (SELECT * FROM `gtregenhpperspt_dbc`)     s ON s.`ID` = t.`ID` + 100 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 900 AND 999;
UPDATE `gtregenmpperspt_dbc`     t JOIN (SELECT * FROM `gtregenmpperspt_dbc`)     s ON s.`ID` = t.`ID` + 100 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 900 AND 999;

-- 32 combat ratings per class, 1-based: class 10 = 289..320, Druid = 321..352
UPDATE `gtoctclasscombatratingscalar_dbc` t JOIN (SELECT * FROM `gtoctclasscombatratingscalar_dbc`) s ON s.`ID` = t.`ID` + 32 SET t.`Data` = s.`Data` WHERE t.`ID` BETWEEN 289 AND 320;
