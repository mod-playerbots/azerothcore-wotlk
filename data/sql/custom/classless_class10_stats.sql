-- Base stats for class 10, the Adventurer.
--
-- Class 10 was created as a byte-for-byte clone of the Druid, which quietly filed a classless
-- class as a caster: 143 Intellect and 159 Spirit at level 80 against 89 Strength, so a melee
-- build opened with 51% of a Warrior's Strength while still having to practise every ability it
-- used. The stat sheet was making a choice the practice system is supposed to make.
--
-- Four decisions, in the order they matter:
--
-- The stat BUDGET starts as the mean of the nine classes that exist at every level (1,2,3,4,5,7,
-- 8,9,11 -- the Death Knight starts at 55 and would put a step in the curve).
--
-- The SPREAD is flat, not that same per-class mean. The mean would read 95/99/109/117/128 and lean
-- caster -- but only because Blizzard shipped more caster classes than melee ones, which is an
-- accident of the roster, not a design. The one class with no class should be the one place in the
-- game where no stat is the wrong stat. Where the budget does not divide by five, the remainder
-- goes to Spirit first and Strength last, so no single stat collects it every level.
--
-- BaseMana is the mean of the seven MANA classes rather than of all nine. A Warrior pays for
-- Heroic Strike in rage, which refills itself in combat, and a Rogue in energy. An Adventurer
-- casting the same ability pays mana. Averaging in two zeroes would charge it twice for the same
-- move.
--
-- Then EVERYTHING EXCEPT BaseHP is cut to 75%, on the user's instruction of 2026-09-17. The
-- Adventurer is not paying for its range with numbers anywhere else -- it can learn any ability in
-- the game and reach any of them by practice -- so the price is charged here. 411 points at level
-- 80 against the shipped 493 (Mage) .. 601 (Shaman), and 3034 mana against the Druid's 3496.
--
-- BaseHP is deliberately NOT cut: 7266 at 80, the plain mean of all nine, between the Paladin's
-- 6934 and the Warrior's 8121. Note that Stamina IS cut and Stamina is most of a character's
-- health, so the health total still falls -- what is held steady is the class's own contribution
-- to it, not the final number.
--
-- player_race_stats is untouched and still applies on top, so a Tauren Adventurer is still three
-- Strength ahead of a Gnome one.

DELETE FROM `player_class_stats` WHERE `Class` = 10;
INSERT INTO `player_class_stats` (`Class`,`Level`,`BaseHP`,`BaseMana`,`Strength`,`Agility`,`Stamina`,`Intellect`,`Spirit`) VALUES
(10, 1,  27,  53, 15, 16, 16, 16, 16),
(10, 2,  33,  73, 16, 16, 16, 17, 17),
(10, 3,  43,  84, 16, 17, 17, 17, 17),
(10, 4,  53,  91, 17, 17, 17, 18, 18),
(10, 5,  65, 100, 17, 18, 18, 18, 18),
(10, 6,  74, 108, 18, 18, 18, 19, 19),
(10, 7,  83, 119, 18, 19, 19, 19, 19),
(10, 8,  95, 129, 19, 19, 19, 20, 20),
(10, 9, 104, 142, 19, 20, 20, 20, 20),
(10,10, 114, 155, 20, 20, 20, 21, 21),
(10,11, 122, 166, 21, 21, 21, 21, 21),
(10,12, 132, 177, 21, 21, 22, 22, 22),
(10,13, 142, 192, 22, 22, 22, 22, 22),
(10,14, 150, 206, 22, 22, 23, 23, 23),
(10,15, 159, 219, 23, 23, 23, 24, 24),
(10,16, 169, 238, 24, 24, 24, 24, 24),
(10,17, 179, 252, 24, 24, 25, 25, 25),
(10,18, 191, 267, 25, 25, 25, 25, 26),
(10,19, 203, 287, 25, 25, 26, 26, 26),
(10,20, 216, 304, 26, 26, 26, 27, 27),
(10,21, 228, 320, 27, 27, 27, 27, 27),
(10,22, 241, 344, 27, 27, 28, 28, 28),
(10,23, 257, 360, 28, 28, 28, 28, 29),
(10,24, 272, 380, 29, 29, 29, 29, 29),
(10,25, 287, 401, 29, 29, 30, 30, 30),
(10,26, 305, 429, 30, 30, 30, 30, 31),
(10,27, 325, 443, 30, 31, 31, 31, 31),
(10,28, 344, 467, 31, 31, 32, 32, 32),
(10,29, 362, 488, 32, 32, 32, 33, 33),
(10,30, 385, 515, 33, 33, 33, 33, 33),
(10,31, 407, 531, 33, 33, 34, 34, 34),
(10,32, 426, 554, 34, 34, 34, 35, 35),
(10,33, 453, 579, 35, 35, 35, 35, 36),
(10,34, 477, 596, 35, 36, 36, 36, 36),
(10,35, 502, 617, 36, 36, 37, 37, 37),
(10,36, 526, 636, 37, 37, 38, 38, 38),
(10,37, 553, 661, 38, 38, 38, 38, 39),
(10,38, 582, 682, 39, 39, 39, 39, 39),
(10,39, 611, 699, 39, 40, 40, 40, 40),
(10,40, 642, 721, 40, 40, 41, 41, 41),
(10,41, 671, 741, 41, 41, 41, 42, 42),
(10,42, 704, 761, 42, 42, 42, 42, 43),
(10,43, 737, 781, 43, 43, 43, 43, 43),
(10,44, 772, 803, 43, 44, 44, 44, 44),
(10,45, 807, 819, 44, 44, 45, 45, 45),
(10,46, 840, 839, 45, 45, 46, 46, 46),
(10,47, 879, 858, 46, 46, 46, 47, 47),
(10,48, 917, 875, 47, 47, 47, 48, 48),
(10,49, 952, 895, 48, 48, 48, 49, 49),
(10,50, 995, 910, 49, 49, 49, 49, 50),
(10,51,1033, 928, 50, 50, 50, 50, 51),
(10,52,1077, 947, 51, 51, 51, 51, 51),
(10,53,1118, 965, 52, 52, 52, 52, 52),
(10,54,1160, 982, 53, 53, 53, 53, 53),
(10,55,1207, 997, 54, 54, 54, 54, 54),
(10,56,1252,1014, 55, 55, 55, 55, 55),
(10,57,1299,1033, 56, 56, 56, 56, 56),
(10,58,1345,1048, 57, 57, 57, 57, 57),
(10,59,1394,1063, 58, 58, 58, 58, 58),
(10,60,1443,1080, 59, 59, 59, 59, 59),
(10,61,1614,1165, 60, 60, 60, 60, 61),
(10,62,1795,1264, 61, 61, 61, 61, 62),
(10,63,1981,1362, 62, 62, 62, 62, 63),
(10,64,2180,1460, 63, 63, 63, 63, 64),
(10,65,2384,1559, 64, 64, 64, 64, 65),
(10,66,2601,1657, 65, 65, 65, 65, 66),
(10,67,2829,1756, 66, 66, 66, 67, 67),
(10,68,3067,1854, 67, 67, 67, 68, 68),
(10,69,3314,1952, 68, 68, 68, 69, 69),
(10,70,3571,2051, 69, 69, 70, 70, 70),
(10,71,3858,2149, 70, 71, 71, 71, 71),
(10,72,4138,2247, 72, 72, 72, 72, 72),
(10,73,4440,2346, 73, 73, 73, 73, 74),
(10,74,4763,2444, 74, 74, 75, 75, 75),
(10,75,5111,2542, 75, 76, 76, 76, 76),
(10,76,5484,2641, 77, 77, 77, 77, 77),
(10,77,5885,2739, 78, 78, 78, 79, 79),
(10,78,6314,2837, 79, 79, 80, 80, 80),
(10,79,6775,2936, 81, 81, 81, 81, 81),
(10,80,7266,3034, 82, 82, 82, 82, 83);
