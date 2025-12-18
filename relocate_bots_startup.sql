USE acore_characters;

-- Set all bots offline before relocation
UPDATE characters 
SET online = 0 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);

START TRANSACTION;


-- ============================================================================
-- LEVEL 1
-- ============================================================================

-- Race 1, Level 1 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 1 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 1 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 1 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 1 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 1 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 1 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 1 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 1 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 1 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 1 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 1 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 1 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 1 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 1 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 1 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 1 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 1 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 1 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 1 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 2
-- ============================================================================

-- Race 1, Level 2 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 2 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 2 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 2 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 2 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 2 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 2 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 2 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 2 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 2 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 2 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 2 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 2 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 2 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 2 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 2 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 2 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 2 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 2 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 2 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 3
-- ============================================================================

-- Race 1, Level 3 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 3 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 3 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 3 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 3 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 3 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 3 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 3 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 3 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 3 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 3 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 3 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 3 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 3 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 3 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 3 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 3 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 3 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 3 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 3 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 4
-- ============================================================================

-- Race 1, Level 4 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 4 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 4 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 4 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 4 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 4 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 4 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 4 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 4 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 4 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 4 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 4 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 4 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 4 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 4 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 4 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 4 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 4 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 4 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 4 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 5
-- ============================================================================

-- Race 1, Level 5 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 5 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 5 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 5 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 5 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 5 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 5 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 5 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 5 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 5 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 5 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 5 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 5 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 5 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 5 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 5 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 5 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 5 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 5 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 5 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 6
-- ============================================================================

-- Race 1, Level 6 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 6 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 6 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 6 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 6 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 6 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 6 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 6 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 6 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 6 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 6 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 6 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 6 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 6 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 6 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 6 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 6 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 6 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 6 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 6 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 7
-- ============================================================================

-- Race 1, Level 7 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 7 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 7 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 7 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 7 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 7 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 7 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 7 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 7 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 7 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 7 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 7 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 7 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 7 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 7 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 7 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 7 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 7 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 7 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 7 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 8
-- ============================================================================

-- Race 1, Level 8 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 8 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 8 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 8 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 8 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 8 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 8 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 8 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 8 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 8 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 8 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 8 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 8 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 8 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 8 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 8 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 8 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 8 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 8 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 8 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 9
-- ============================================================================

-- Race 1, Level 9 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 9 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 9 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 9 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 9 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 9 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 9 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 9 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 9 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 9 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 9 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 9 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 9 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 9 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 9 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 9 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 9 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 9 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 9 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 9 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 10
-- ============================================================================

-- Race 1, Level 10 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 10 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 10 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 10 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 10 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 10 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 10 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 10 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 10 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 10 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 10 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 10 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 10 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 10 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 10 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 10 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 10 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 10 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 10 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 10 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 11
-- ============================================================================

-- Race 1, Level 11 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 11 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 11 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 11 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 11 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 11 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 11 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 11 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 11 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 11 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 11 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 11 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 11 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 11 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 11 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 11 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 11 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 11 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 11 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 11 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 12
-- ============================================================================

-- Race 1, Level 12 -> Zone 12
UPDATE characters
SET position_x = -8949.95, position_y = -132.49, position_z = 83.53,
    map = 0, zone = 12, orientation = 0
WHERE level = 12 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 12 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 12 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 12 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 12 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 12 -> Zone 141
UPDATE characters
SET position_x = 10311.30, position_y = 832.46, position_z = 1326.41,
    map = 1, zone = 141, orientation = 0
WHERE level = 12 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 12 -> Zone 85
UPDATE characters
SET position_x = 1681.00, position_y = 1667.75, position_z = 121.04,
    map = 0, zone = 85, orientation = 0
WHERE level = 12 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 12 -> Zone 215
UPDATE characters
SET position_x = -2917.58, position_y = -257.98, position_z = 52.97,
    map = 1, zone = 215, orientation = 0
WHERE level = 12 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 12 -> Zone 1
UPDATE characters
SET position_x = -6240.32, position_y = 331.03, position_z = 382.76,
    map = 0, zone = 1, orientation = 0
WHERE level = 12 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 12 -> Zone 14
UPDATE characters
SET position_x = -618.52, position_y = -4251.70, position_z = 38.72,
    map = 1, zone = 14, orientation = 0
WHERE level = 12 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 12 -> Zone 3430
UPDATE characters
SET position_x = 10349.60, position_y = -6357.29, position_z = 33.13,
    map = 530, zone = 3430, orientation = 0
WHERE level = 12 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 12 -> Zone 3524
UPDATE characters
SET position_x = -3961.67, position_y = -13931.20, position_z = 100.62,
    map = 530, zone = 3524, orientation = 0
WHERE level = 12 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 13
-- ============================================================================

-- Race 1, Level 13 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 13 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 13 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 13 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 13 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 13 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 13 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 13 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 13 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 13 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 13 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 13 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 13 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 13 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 13 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 13 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 13 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 13 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 13 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 13 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 14
-- ============================================================================

-- Race 1, Level 14 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 14 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 14 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 14 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 14 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 14 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 14 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 14 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 14 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 14 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 14 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 14 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 14 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 14 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 14 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 14 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 14 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 14 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 14 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 14 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 15
-- ============================================================================

-- Race 1, Level 15 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 15 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 15 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 15 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 15 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 15 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 15 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 15 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 15 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 15 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 15 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 15 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 15 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 15 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 15 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 15 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 15 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 15 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 15 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 15 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 16
-- ============================================================================

-- Race 1, Level 16 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 16 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 16 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 16 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 16 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 16 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 16 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 16 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 16 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 16 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 16 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 16 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 16 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 16 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 16 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 16 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 16 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 16 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 16 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 16 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 17
-- ============================================================================

-- Race 1, Level 17 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 17 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 17 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 17 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 17 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 17 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 17 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 17 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 17 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 17 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 17 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 17 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 17 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 17 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 17 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 17 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 17 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 17 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 17 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 17 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 18
-- ============================================================================

-- Race 1, Level 18 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 18 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 18 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 18 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 18 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 18 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 18 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 18 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 18 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 18 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 18 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 18 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 18 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 18 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 18 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 18 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 18 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 18 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 18 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 18 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 19
-- ============================================================================

-- Race 1, Level 19 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 19 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 19 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 19 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 19 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 19 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 19 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 19 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 19 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 19 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 19 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 19 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 19 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 19 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 19 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 19 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 19 -> Zone 130
UPDATE characters
SET position_x = 505.13, position_y = 1504.63, position_z = 127.13,
    map = 0, zone = 130, orientation = 0
WHERE level = 19 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 19 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 19 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 20
-- ============================================================================

-- Race 1, Level 20 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 20 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 20 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 20 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 20 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 20 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 20 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 20 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 20 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 20 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 20 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 20 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 20 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 20 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 20 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 20 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 20 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 20 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 20 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 20 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 21
-- ============================================================================

-- Race 1, Level 21 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 21 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 21 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 21 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 21 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 21 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 21 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 21 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 21 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 21 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 21 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 21 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 21 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 21 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 21 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 21 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 21 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 21 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 21 -> Zone 3525
UPDATE characters
SET position_x = -2095.70, position_y = -11841.10, position_z = 51.17,
    map = 530, zone = 3525, orientation = 0
WHERE level = 21 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 22
-- ============================================================================

-- Race 1, Level 22 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 22 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 22 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 22 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 22 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 22 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 22 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 22 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 22 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 22 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 22 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 22 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 22 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 22 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 22 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 22 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 22 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 22 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 22 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 22 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 23
-- ============================================================================

-- Race 1, Level 23 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 23 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 23 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 23 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 23 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 23 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 23 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 23 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 23 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 23 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 23 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 23 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 23 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 23 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 23 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 23 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 23 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 23 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 23 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 23 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 24
-- ============================================================================

-- Race 1, Level 24 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 24 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 24 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 24 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 24 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 24 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 24 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 24 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 24 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 24 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 24 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 24 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 24 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 24 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 24 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 24 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 24 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 24 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 24 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 24 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 25
-- ============================================================================

-- Race 1, Level 25 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 25 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 25 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 25 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 25 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 25 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 25 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 25 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 25 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 25 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 25 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 25 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 25 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 25 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 25 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 25 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 25 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 25 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 25 -> Zone 1519
UPDATE characters
SET position_x = -8867.13, position_y = 566.31, position_z = 101.8,
    map = 0, zone = 1519, orientation = 0
WHERE level = 25 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 26
-- ============================================================================

-- Race 1, Level 26 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 26 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 26 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 26 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 26 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 26 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 26 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 26 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 26 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 26 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 26 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 26 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 26 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 26 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 26 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 26 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 26 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 26 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 26 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 26 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 27
-- ============================================================================

-- Race 1, Level 27 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 27 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 27 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 27 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 27 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 27 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 27 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 27 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 27 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 27 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 27 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 27 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 27 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 27 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 27 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 27 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 27 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 27 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 27 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 27 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 28
-- ============================================================================

-- Race 1, Level 28 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 28 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 28 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 28 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 28 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 28 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 28 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 28 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 28 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 28 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 28 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 28 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 28 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 28 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 28 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 28 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 28 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 28 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 28 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 28 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 29
-- ============================================================================

-- Race 1, Level 29 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 29 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 29 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 29 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 29 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 29 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 29 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 29 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 29 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 29 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 29 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 29 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 29 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 29 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 29 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 29 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 29 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 29 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 29 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 29 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 30
-- ============================================================================

-- Race 1, Level 30 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 30 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 30 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 30 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 30 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 30 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 30 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 30 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 30 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 30 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 30 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 30 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 30 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 30 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 30 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 30 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 30 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 30 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 30 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 30 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 31
-- ============================================================================

-- Race 1, Level 31 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 31 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 31 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 31 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 31 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 31 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 31 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 31 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 31 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 31 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 31 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 31 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 31 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 31 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 31 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 31 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 31 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 31 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 31 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 31 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 32
-- ============================================================================

-- Race 1, Level 32 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 32 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 32 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 32 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 32 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 32 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 32 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 32 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 32 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 32 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 32 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 32 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 32 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 32 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 32 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 32 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 32 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 32 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 32 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 32 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 33
-- ============================================================================

-- Race 1, Level 33 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 33 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 33 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 33 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 33 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 33 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 33 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 33 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 33 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 33 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 33 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 33 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 33 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 33 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 33 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 33 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 33 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 33 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 33 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 33 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 34
-- ============================================================================

-- Race 1, Level 34 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 34 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 34 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 34 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 34 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 34 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 34 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 34 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 34 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 34 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 34 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 34 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 34 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 34 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 34 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 34 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 34 -> Zone 267
UPDATE characters
SET position_x = -385.80, position_y = -511.74, position_z = 53.63,
    map = 0, zone = 267, orientation = 0
WHERE level = 34 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 34 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 34 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 35
-- ============================================================================

-- Race 1, Level 35 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 35 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 35 -> Zone 1637
UPDATE characters
SET position_x = 1646.61, position_y = -4349.95, position_z = 26.8,
    map = 1, zone = 1637, orientation = 0
WHERE level = 35 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 35 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 35 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 35 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 35 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 35 -> Zone 1637
UPDATE characters
SET position_x = 1646.61, position_y = -4349.95, position_z = 26.8,
    map = 1, zone = 1637, orientation = 0
WHERE level = 35 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 35 -> Zone 1637
UPDATE characters
SET position_x = 1646.61, position_y = -4349.95, position_z = 26.8,
    map = 1, zone = 1637, orientation = 0
WHERE level = 35 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 35 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 35 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 35 -> Zone 1637
UPDATE characters
SET position_x = 1646.61, position_y = -4349.95, position_z = 26.8,
    map = 1, zone = 1637, orientation = 0
WHERE level = 35 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 35 -> Zone 1637
UPDATE characters
SET position_x = 1646.61, position_y = -4349.95, position_z = 26.8,
    map = 1, zone = 1637, orientation = 0
WHERE level = 35 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 35 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 35 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 36
-- ============================================================================

-- Race 1, Level 36 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 36 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 36 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 36 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 36 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 36 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 36 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 36 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 36 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 36 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 36 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 36 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 36 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 36 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 36 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 36 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 36 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 36 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 36 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 36 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 37
-- ============================================================================

-- Race 1, Level 37 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 37 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 37 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 37 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 37 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 37 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 37 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 37 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 37 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 37 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 37 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 37 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 37 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 37 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 37 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 37 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 37 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 37 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 37 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 37 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 38
-- ============================================================================

-- Race 1, Level 38 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 38 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 38 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 38 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 38 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 38 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 38 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 38 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 38 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 38 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 38 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 38 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 38 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 38 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 38 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 38 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 38 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 38 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 38 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 38 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 39
-- ============================================================================

-- Race 1, Level 39 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 39 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 39 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 39 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 39 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 39 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 39 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 39 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 39 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 39 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 39 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 39 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 39 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 39 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 39 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 39 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 39 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 39 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 39 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 39 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 40
-- ============================================================================

-- Race 1, Level 40 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 40 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 40 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 40 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 40 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 40 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 40 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 40 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 40 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 40 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 40 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 40 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 40 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 40 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 40 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 40 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 40 -> Zone 3487
UPDATE characters
SET position_x = 9674.32, position_y = -7349.3, position_z = 15.24,
    map = 530, zone = 3487, orientation = 0
WHERE level = 40 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 40 -> Zone 1657
UPDATE characters
SET position_x = 9968.73, position_y = 2459.63, position_z = 1323.81,
    map = 1, zone = 1657, orientation = 0
WHERE level = 40 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 41
-- ============================================================================

-- Race 1, Level 41 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 41 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 41 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 41 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 41 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 41 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 41 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 41 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 41 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 41 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 41 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 41 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 41 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 41 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 41 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 41 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 41 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 41 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 41 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 41 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 42
-- ============================================================================

-- Race 1, Level 42 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 42 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 42 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 42 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 42 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 42 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 42 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 42 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 42 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 42 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 42 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 42 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 42 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 42 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 42 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 42 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 42 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 42 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 42 -> Zone 45
UPDATE characters
SET position_x = -1513.99, position_y = -2627.51, position_z = 41.34,
    map = 0, zone = 45, orientation = 0
WHERE level = 42 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 43
-- ============================================================================

-- Race 1, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 43 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 43 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 44
-- ============================================================================

-- Race 1, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 44 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 44 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 45
-- ============================================================================

-- Race 1, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 45 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 45 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 46
-- ============================================================================

-- Race 1, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 46 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 46 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 47
-- ============================================================================

-- Race 1, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 47 -> Zone 33
UPDATE characters
SET position_x = -11921.70, position_y = -59.54, position_z = 39.73,
    map = 0, zone = 33, orientation = 0
WHERE level = 47 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 48
-- ============================================================================

-- Race 1, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 48 -> Zone 51
UPDATE characters
SET position_x = -6686.33, position_y = -1193.93, position_z = 240.02,
    map = 0, zone = 51, orientation = 0
WHERE level = 48 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 49
-- ============================================================================

-- Race 1, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 49 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 49 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 50
-- ============================================================================

-- Race 1, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 50 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 50 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 51
-- ============================================================================

-- Race 1, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 51 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 51 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 52
-- ============================================================================

-- Race 1, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 52 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 52 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 53
-- ============================================================================

-- Race 1, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 53 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 53 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 54
-- ============================================================================

-- Race 1, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 54 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 54 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 55
-- ============================================================================

-- Race 1, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 55 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 55 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 56
-- ============================================================================

-- Race 1, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 56 -> Zone 490
UPDATE characters
SET position_x = -6291.55, position_y = -1158.62, position_z = -258.17,
    map = 1, zone = 490, orientation = 0
WHERE level = 56 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 57
-- ============================================================================

-- Race 1, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 57 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 57 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 58
-- ============================================================================

-- Race 1, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 58 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 58 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 59
-- ============================================================================

-- Race 1, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 59 -> Zone 1377
UPDATE characters
SET position_x = -7181.67, position_y = 1653.26, position_z = 4.48,
    map = 1, zone = 1377, orientation = 0
WHERE level = 59 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 60
-- ============================================================================

-- Race 1, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 60 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 60 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 61
-- ============================================================================

-- Race 1, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 61 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 61 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 62
-- ============================================================================

-- Race 1, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 62 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 62 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 63
-- ============================================================================

-- Race 1, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 63 -> Zone 3521
UPDATE characters
SET position_x = 254.93, position_y = 7862.00, position_z = 22.44,
    map = 530, zone = 3521, orientation = 0
WHERE level = 63 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 64
-- ============================================================================

-- Race 1, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 64 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 64 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 65
-- ============================================================================

-- Race 1, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 65 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 65 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 66
-- ============================================================================

-- Race 1, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 66 -> Zone 3522
UPDATE characters
SET position_x = 2029.75, position_y = 4425.37, position_z = 156.97,
    map = 530, zone = 3522, orientation = 0
WHERE level = 66 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 67
-- ============================================================================

-- Race 1, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 67 -> Zone 3523
UPDATE characters
SET position_x = 3087.22, position_y = 3681.85, position_z = 143.20,
    map = 530, zone = 3523, orientation = 0
WHERE level = 67 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 68
-- ============================================================================

-- Race 1, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 68 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 68 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 69
-- ============================================================================

-- Race 1, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 69 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 69 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 70
-- ============================================================================

-- Race 1, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 70 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 70 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 71
-- ============================================================================

-- Race 1, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 71 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 71 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 72
-- ============================================================================

-- Race 1, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 72 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 72 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 73
-- ============================================================================

-- Race 1, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 73 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 73 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 74
-- ============================================================================

-- Race 1, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 74 -> Zone 495
UPDATE characters
SET position_x = 682.00, position_y = -3978.00, position_z = 230.16,
    map = 571, zone = 495, orientation = 0
WHERE level = 74 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 75
-- ============================================================================

-- Race 1, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 75 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 75 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 76
-- ============================================================================

-- Race 1, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 76 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 76 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 77
-- ============================================================================

-- Race 1, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 77 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 77 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 78
-- ============================================================================

-- Race 1, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 78 -> Zone 4395
UPDATE characters
SET position_x = 5804.15, position_y = 624.77, position_z = 647.77,
    map = 571, zone = 4395, orientation = 0
WHERE level = 78 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 79
-- ============================================================================

-- Race 1, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 79 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 79 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- ============================================================================
-- LEVEL 80
-- ============================================================================

-- Race 1, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 1
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 2, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 2
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 3, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 3
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 4, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 4
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 5, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 5
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 6, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 6
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 7, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 7
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 8, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 8
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 10, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 10
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


-- Race 11, Level 80 -> Zone 4197
UPDATE characters
SET position_x = 5132.66, position_y = 2840.52, position_z = 408.5,
    map = 571, zone = 4197, orientation = 0
WHERE level = 80 AND race = 11
  AND guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);


COMMIT;

-- ============================================================================
-- VERIFICATION
-- ============================================================================

SELECT 'Config-Driven Bot Relocation V11 Complete' as status, 
       NOW() as timestamp,
       COUNT(*) as total_bots
FROM characters 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0);

-- Distribution by level bracket
SELECT 
    CASE 
        WHEN level BETWEEN 1 AND 9 THEN '1-9'
        WHEN level BETWEEN 10 AND 19 THEN '10-19'
        WHEN level BETWEEN 20 AND 29 THEN '20-29'
        WHEN level BETWEEN 30 AND 39 THEN '30-39'
        WHEN level BETWEEN 40 AND 49 THEN '40-49'
        WHEN level BETWEEN 50 AND 59 THEN '50-59'
        WHEN level = 60 THEN '60'
        WHEN level BETWEEN 61 AND 69 THEN '61-69'
        WHEN level = 70 THEN '70'
        WHEN level BETWEEN 71 AND 79 THEN '71-79'
        WHEN level = 80 THEN '80'
    END as level_bracket,
    COUNT(*) as bot_count
FROM characters 
WHERE guid IN (SELECT DISTINCT bot FROM acore_playerbots.playerbots_random_bots WHERE bot > 0)
GROUP BY level_bracket
ORDER BY MIN(level);

