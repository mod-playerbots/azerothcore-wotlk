-- Paragon: widen `paragon_config_statistic`.`type_value` to its ENUM before anything compares
-- strings against it.
--
-- 02_create_config_tables.sql declares the column as `INT NOT NULL DEFAULT 0`, and
-- 08_insert_utility_statistics.sql is what turns it into the ENUM below -- but
-- 07_insert_progression_config.sql already compares it to 'MOVE_SPEED' and friends, one file
-- earlier. Applied in filename order from an empty database, 07 therefore dies with
--
--   ERROR 1292 (22007) at line 143: Truncated incorrect DOUBLE value: 'MOVE_SPEED'
--
-- and the whole character import stops. It never showed up on this realm because the Paragon
-- migrations had only ever been run by hand, in whatever order made them work; the from-zero
-- rebuild on 2026-09-15 is what exposed it.
--
-- The statement is copied verbatim out of 08, which keeps its own copy: nothing has inserted a
-- row into the table at this point, so widening it here is free, and MODIFY COLUMN to a type the
-- column already has is a no-op when 08 repeats it.

ALTER TABLE `acore_ale`.`paragon_config_statistic`
    MODIFY COLUMN `type_value` ENUM(
        'WEAPON_SKILL', 'DEFENSE_SKILL', 'DODGE', 'PARRY', 'BLOCK',
        'HIT_MELEE', 'HIT_RANGED', 'HIT_SPELL',
        'CRIT_MELEE', 'CRIT_RANGED', 'CRIT_SPELL',
        'HIT_TAKEN_MELEE', 'HIT_TAKEN_RANGED', 'HIT_TAKEN_SPELL',
        'CRIT_TAKEN_MELEE', 'CRIT_TAKEN_RANGED', 'CRIT_TAKEN_SPELL',
        'HASTE_MELEE', 'HASTE_RANGED', 'HASTE_SPELL',
        'WEAPON_SKILL_MAINHAND', 'WEAPON_SKILL_OFFHAND', 'WEAPON_SKILL_RANGED',
        'EXPERTISE', 'ARMOR_PENETRATION',
        'STAT_STRENGTH', 'STAT_AGILITY', 'STAT_STAMINA', 'STAT_INTELLECT', 'STAT_SPIRIT',
        'HEALTH', 'MANA', 'RAGE', 'FOCUS', 'ENERGY', 'HAPPINESS', 'RUNE', 'RUNIC_POWER',
        'ARMOR',
        'RESISTANCE_HOLY', 'RESISTANCE_FIRE', 'RESISTANCE_NATURE',
        'RESISTANCE_FROST', 'RESISTANCE_SHADOW', 'RESISTANCE_ARCANE',
        'ATTACK_POWER', 'ATTACK_POWER_RANGED',
        'DAMAGE_MAINHAND', 'DAMAGE_OFFHAND', 'DAMAGE_RANGED',
        'LOOT', 'REPUTATION', 'EXPERIENCE', 'GOLD', 'MOVE_SPEED',
        'CRAFTSMANSHIP', 'SCAVENGER', 'RECOVERY', 'MOUNT_SPEED'
    ) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'STAT_STRENGTH';
