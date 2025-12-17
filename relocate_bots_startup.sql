-- Comprehensive Bot Relocation Script
-- Relocates ALL bots to level-appropriate zones on every server start
-- This ensures bots are ALWAYS in correct zones when they log in

USE acore_characters;

-- Force ALL bots offline before any relocation
UPDATE characters 
SET online = 0 
WHERE account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

START TRANSACTION;

-- ============================================================================
-- LEVEL 80: WotLK Endgame ONLY - Dalaran (Raid Hub)
-- ============================================================================
UPDATE characters 
SET 
    position_x = 5804.15,
    position_y = 624.77,
    position_z = 647.77,
    map = 571,
    zone = 4395,
    orientation = 0
WHERE level = 80
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 71-79: WotLK Leveling - Northrend zones
-- ============================================================================
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 3) = 0 THEN 5804.15
        WHEN MOD(guid, 3) = 1 THEN 2438.81
        ELSE 1951.89
    END,
    position_y = CASE 
        WHEN MOD(guid, 3) = 0 THEN 624.77
        WHEN MOD(guid, 3) = 1 THEN -5630.17
        ELSE -6374.13
    END,
    position_z = CASE 
        WHEN MOD(guid, 3) = 0 THEN 647.77
        WHEN MOD(guid, 3) = 1 THEN 420.64
        ELSE 162.50
    END,
    map = 571,
    zone = CASE 
        WHEN MOD(guid, 3) = 0 THEN 4395
        WHEN MOD(guid, 3) = 1 THEN 3537
        ELSE 495
    END,
    orientation = 0
WHERE level BETWEEN 71 AND 79
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 70: TBC Endgame ONLY - Shattrath (Raid Hub)
-- ============================================================================
UPDATE characters 
SET 
    position_x = -1838.16,
    position_y = 5301.79,
    position_z = -12.43,
    map = 530,
    zone = 3703,
    orientation = 0
WHERE level = 70
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 61-69: TBC Leveling - Outland zones
-- ============================================================================
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 2) = 0 THEN -1838.16
        ELSE -207.32
    END,
    position_y = CASE 
        WHEN MOD(guid, 2) = 0 THEN 5301.79
        ELSE 2035.91
    END,
    position_z = CASE 
        WHEN MOD(guid, 2) = 0 THEN -12.43
        ELSE 96.77
    END,
    map = 530,
    zone = CASE 
        WHEN MOD(guid, 2) = 0 THEN 3703
        ELSE 3483
    END,
    orientation = 0
WHERE level BETWEEN 61 AND 69
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 60: Vanilla Endgame ONLY - Capital Cities (Raid Hubs)
-- ============================================================================
-- Alliance level 60
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 2) = 0 THEN -8833.38
        ELSE -4918.88
    END,
    position_y = CASE 
        WHEN MOD(guid, 2) = 0 THEN 628.63
        ELSE -940.41
    END,
    position_z = CASE 
        WHEN MOD(guid, 2) = 0 THEN 94.00
        ELSE 501.56
    END,
    map = 0,
    zone = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1519
        ELSE 1537
    END,
    orientation = 0
WHERE level = 60
  AND race IN (1, 3, 4, 7, 11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde level 60
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1569.59
        ELSE 1633.75
    END,
    position_y = CASE 
        WHEN MOD(guid, 2) = 0 THEN -4397.63
        ELSE 240.08
    END,
    position_z = CASE 
        WHEN MOD(guid, 2) = 0 THEN 16.06
        ELSE -43.10
    END,
    map = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1
        ELSE 0
    END,
    zone = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1637
        ELSE 1497
    END,
    orientation = 0
WHERE level = 60
  AND race IN (2, 5, 6, 8, 10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 50-59: Vanilla Pre-Endgame - Capital Cities
-- ============================================================================
-- Alliance 50-59
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 2) = 0 THEN -8833.38
        ELSE -4918.88
    END,
    position_y = CASE 
        WHEN MOD(guid, 2) = 0 THEN 628.63
        ELSE -940.41
    END,
    position_z = CASE 
        WHEN MOD(guid, 2) = 0 THEN 94.00
        ELSE 501.56
    END,
    map = 0,
    zone = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1519
        ELSE 1537
    END,
    orientation = 0
WHERE level BETWEEN 50 AND 59
  AND race IN (1, 3, 4, 7, 11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde 50-59
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1569.59
        ELSE 1633.75
    END,
    position_y = CASE 
        WHEN MOD(guid, 2) = 0 THEN -4397.63
        ELSE 240.08
    END,
    position_z = CASE 
        WHEN MOD(guid, 2) = 0 THEN 16.06
        ELSE -43.10
    END,
    map = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1
        ELSE 0
    END,
    zone = CASE 
        WHEN MOD(guid, 2) = 0 THEN 1637
        ELSE 1497
    END,
    orientation = 0
WHERE level BETWEEN 50 AND 59
  AND race IN (2, 5, 6, 8, 10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 40-49: Vanilla High - Capital Cities
-- ============================================================================
-- Alliance 40-49
UPDATE characters 
SET position_x=-8833.38, position_y=622.52, position_z=94.06, map=0, zone=1519, orientation=0
WHERE level BETWEEN 40 AND 49 AND race IN (1,3,4,7,11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde 40-49
UPDATE characters 
SET position_x=1569.59, position_y=-4397.63, position_z=16.06, map=1, zone=1637, orientation=0
WHERE level BETWEEN 40 AND 49 AND race IN (2,5,6,8,10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 30-39: Vanilla Mid-High - Capital Cities
-- ============================================================================
-- Alliance 30-39
UPDATE characters 
SET position_x=-8833.38, position_y=622.52, position_z=94.06, map=0, zone=1519, orientation=0
WHERE level BETWEEN 30 AND 39 AND race IN (1,3,4,7,11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde 30-39
UPDATE characters 
SET position_x=1569.59, position_y=-4397.63, position_z=16.06, map=1, zone=1637, orientation=0
WHERE level BETWEEN 30 AND 39 AND race IN (2,5,6,8,10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 20-29: Vanilla Mid - Multiple towns
-- ============================================================================
-- Alliance 20-29
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 10) < 4 THEN -8833.38
        WHEN MOD(guid, 10) < 7 THEN -4918.88
        ELSE 9951.52
    END,
    position_y = CASE 
        WHEN MOD(guid, 10) < 4 THEN 622.52
        WHEN MOD(guid, 10) < 7 THEN -940.41
        ELSE 2280.45
    END,
    position_z = CASE 
        WHEN MOD(guid, 10) < 4 THEN 94.06
        WHEN MOD(guid, 10) < 7 THEN 501.56
        ELSE 1341.39
    END,
    map = CASE 
        WHEN MOD(guid, 10) < 7 THEN 0
        ELSE 1
    END,
    zone = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1519
        WHEN MOD(guid, 10) < 7 THEN 1537
        ELSE 1657
    END,
    orientation = 0
WHERE level BETWEEN 20 AND 29 AND race IN (1,3,4,7,11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde 20-29
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1569.59
        WHEN MOD(guid, 10) < 7 THEN 1633.75
        ELSE -1278.62
    END,
    position_y = CASE 
        WHEN MOD(guid, 10) < 4 THEN -4397.63
        WHEN MOD(guid, 10) < 7 THEN 240.08
        ELSE 122.91
    END,
    position_z = CASE 
        WHEN MOD(guid, 10) < 4 THEN 16.06
        WHEN MOD(guid, 10) < 7 THEN -43.10
        ELSE 131.35
    END,
    map = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1
        WHEN MOD(guid, 10) < 7 THEN 0
        ELSE 1
    END,
    zone = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1637
        WHEN MOD(guid, 10) < 7 THEN 1497
        ELSE 1638
    END,
    orientation = 0
WHERE level BETWEEN 20 AND 29 AND race IN (2,5,6,8,10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 10-19: Vanilla Low - Multiple towns
-- ============================================================================
-- Alliance 10-19
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 10) < 4 THEN -10628.69
        WHEN MOD(guid, 10) < 7 THEN -5420.52
        ELSE 6463.25
    END,
    position_y = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1055.96
        WHEN MOD(guid, 10) < 7 THEN -2894.23
        ELSE 683.24
    END,
    position_z = CASE 
        WHEN MOD(guid, 10) < 4 THEN 36.24
        WHEN MOD(guid, 10) < 7 THEN 347.57
        ELSE 8.92
    END,
    map = CASE 
        WHEN MOD(guid, 10) < 7 THEN 0
        ELSE 1
    END,
    zone = CASE 
        WHEN MOD(guid, 10) < 4 THEN 40
        WHEN MOD(guid, 10) < 7 THEN 38
        ELSE 148
    END,
    orientation = 0
WHERE level BETWEEN 10 AND 19 AND race IN (1,3,4,7,11)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Horde 10-19
UPDATE characters 
SET 
    position_x = CASE 
        WHEN MOD(guid, 10) < 4 THEN -450.95
        WHEN MOD(guid, 10) < 7 THEN 508.94
        ELSE 7595.73
    END,
    position_y = CASE 
        WHEN MOD(guid, 10) < 4 THEN -2643.28
        WHEN MOD(guid, 10) < 7 THEN 1483.69
        ELSE -6795.31
    END,
    position_z = CASE 
        WHEN MOD(guid, 10) < 4 THEN 96.23
        WHEN MOD(guid, 10) < 7 THEN 124.43
        ELSE 84.45
    END,
    map = CASE 
        WHEN MOD(guid, 10) < 4 THEN 1
        WHEN MOD(guid, 10) < 7 THEN 0
        ELSE 530
    END,
    zone = CASE 
        WHEN MOD(guid, 10) < 4 THEN 17
        WHEN MOD(guid, 10) < 7 THEN 130
        ELSE 3433
    END,
    orientation = 0
WHERE level BETWEEN 10 AND 19 AND race IN (2,5,6,8,10)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- ============================================================================
-- LEVEL 1-9: Starting zones by race
-- ============================================================================
-- Human -> Northshire Abbey (Elwynn Forest)
UPDATE characters 
SET position_x=-8949.95, position_y=-132.49, position_z=83.53, map=0, zone=12, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=1 
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Dwarf/Gnome -> Coldridge Valley (Dun Morogh)
UPDATE characters 
SET position_x=-6240.32, position_y=331.03, position_z=382.76, map=0, zone=1, orientation=0
WHERE level BETWEEN 1 AND 9 AND race IN (3,7)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Night Elf -> Shadowglen (Teldrassil)
UPDATE characters 
SET position_x=10311.30, position_y=832.46, position_z=1326.41, map=1, zone=141, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=4
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Draenei -> Ammen Vale (Azuremyst Isle)
UPDATE characters 
SET position_x=-3961.67, position_y=-13931.20, position_z=100.62, map=530, zone=3524, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=11
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Orc/Troll -> Valley of Trials (Durotar)
UPDATE characters 
SET position_x=-618.52, position_y=-4251.70, position_z=38.72, map=1, zone=14, orientation=0
WHERE level BETWEEN 1 AND 9 AND race IN (2,8)
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Undead -> Deathknell (Tirisfal Glades)
UPDATE characters 
SET position_x=1676.72, position_y=1678.08, position_z=121.67, map=0, zone=85, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=5
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Tauren -> Camp Narache (Mulgore)
UPDATE characters 
SET position_x=-2917.58, position_y=-257.98, position_z=52.97, map=1, zone=215, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=6
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

-- Blood Elf -> Sunstrider Isle (Eversong Woods)
UPDATE characters 
SET position_x=10349.60, position_y=-6357.29, position_z=33.13, map=530, zone=3430, orientation=0
WHERE level BETWEEN 1 AND 9 AND race=10
  AND account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');

COMMIT;

-- Report results
SELECT 'Bot Relocation Complete - All bots placed in level-appropriate zones' as status, 
       NOW() as timestamp,
       COUNT(*) as total_bots_relocated 
FROM characters 
WHERE account IN (SELECT id FROM acore_auth.account WHERE username LIKE 'RNDBOT%');
