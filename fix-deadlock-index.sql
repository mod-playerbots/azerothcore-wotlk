-- Fix for character_pet deadlock issues
-- Date: 2025-12-31
-- Description: Adds composite index to reduce deadlock probability

USE acore_characters;

-- Check if index exists, create if not
SELECT CONCAT('Creating composite index idx_owner_slot on character_pet table...') AS Status;

-- Create the composite index if it doesn't exist
CREATE INDEX IF NOT EXISTS idx_owner_slot ON character_pet(owner, slot);

-- Verify the index was created
SHOW INDEX FROM character_pet WHERE Key_name = 'idx_owner_slot';

SELECT CONCAT('Index optimization complete!') AS Status;
