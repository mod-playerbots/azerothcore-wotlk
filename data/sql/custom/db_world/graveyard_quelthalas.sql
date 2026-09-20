-- Zone 2037 "Quel'thalas" (map 0) is the vanilla placeholder zone north of the
-- Eastern Plaguelands. Stock AzerothCore ships no graveyard_zone row for it, so
-- anything that dies there logs:
--   Table `graveyard_zone` incomplete: Zone 2037 Team N does not have a linked graveyard.
-- Link it to the nearest existing graveyard, Eastern Plaguelands / Stratholme
-- (game_graveyard.ID 1449 at 3340, -3230, 143 on map 0), for both factions
-- (Faction 0 = any team).

DELETE FROM `graveyard_zone` WHERE `GhostZone` = 2037;
INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Faction`, `Comment`) VALUES
(1449, 2037, 0, "Quel'thalas (map 0 placeholder zone) -> Eastern Plaguelands, Stratholme");
