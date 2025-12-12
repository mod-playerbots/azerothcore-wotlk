-- Bot Relocation Script - Runs on Server Startup
-- This ensures bots spawn in appropriate zones for their level

USE acore_characters;

-- 1. HIGH LEVEL BOTS (70-80) -> Dalaran (Northrend)
UPDATE characters 
SET 
    position_x = 5804.15,
    position_y = 624.77,
    position_z = 647.77,
    map = 571,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 70 AND 80
  AND online = 0
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- 2. MID-HIGH LEVEL BOTS (50-69) -> Shattrath (Outland)
UPDATE characters 
SET 
    position_x = -1838.16,
    position_y = 5301.79,
    position_z = -12.43,
    map = 530,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 50 AND 69
  AND online = 0
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- 3. MID LEVEL BOTS (20-49) -> Capital Cities by Faction
-- Alliance (races 1,3,4,7,11,22) -> Stormwind
UPDATE characters 
SET 
    position_x = -8833.38,
    position_y = 628.63,
    position_z = 94.00,
    map = 0,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 20 AND 49
  AND online = 0
  AND race IN (1, 3, 4, 7, 11, 22)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde (races 2,5,6,8,9,10) -> Orgrimmar
UPDATE characters 
SET 
    position_x = 1633.75,
    position_y = -4440.09,
    position_z = 15.43,
    map = 1,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 20 AND 49
  AND online = 0
  AND race IN (2, 5, 6, 8, 9, 10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- 4. LOW LEVEL BOTS (10-19) -> Appropriate Low-Level Towns
-- Alliance -> Goldshire
UPDATE characters 
SET 
    position_x = -9449.06,
    position_y = 64.83,
    position_z = 56.24,
    map = 0,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 10 AND 19
  AND online = 0
  AND race IN (1, 3, 4, 7, 11, 22)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde -> Razor Hill
UPDATE characters 
SET 
    position_x = 258.68,
    position_y = -4775.42,
    position_z = 10.10,
    map = 1,
    zone = 0,
    orientation = 0
WHERE level BETWEEN 10 AND 19
  AND online = 0
  AND race IN (2, 5, 6, 8, 9, 10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Log results
SELECT 
    'Bot Relocation Complete' as status,
    NOW() as timestamp,
    COUNT(*) as total_bots_relocated
FROM characters 
WHERE account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%')
  AND online = 0;
