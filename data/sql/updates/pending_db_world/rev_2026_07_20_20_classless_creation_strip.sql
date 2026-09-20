-- Classless server: make class abilities cost AP instead of being free at creation.
--
-- On this server real players buy every class spell through the ClassLess AP panel,
-- but playercreateinfo_spell_custom still granted the tree spells for free at character
-- creation. This removes only the 163 spells that are purchasable in the AP tree
-- (spells.data / talents.data); proficiencies, racials, languages, stance passives and
-- non-tree ranks are left untouched so they stay free.
--
-- Playerbots are unaffected: PlayerbotFactory::InitClassSpells re-grants their kit.
-- Existing characters are grandfathered (their spellbooks are not modified here).

DELETE FROM `playercreateinfo_spell_custom` WHERE `Spell` IN (
    66, 71, 75, 78, 126, 130, 131, 132, 133, 168, 331, 355, 403, 408, 421, 469, 475, 526, 528, 546, 552, 556, 585,
    635, 676, 686, 687, 688, 691, 697, 698, 712, 768, 783, 871, 883, 921, 982, 1002, 1038, 1044, 1066, 1161, 1462,
    1494, 1515, 1543, 1680, 1706, 1719, 1725, 1752, 1833, 1842, 1860, 1953, 2050, 2062, 2094, 2098, 2139, 2457,
    2458, 2484, 2565, 2641, 2645, 2687, 2782, 2825, 2836, 2842, 2893, 2894, 2973, 3043, 3045, 3411, 3738, 4987,
    5116, 5118, 5176, 5185, 5209, 5225, 5229, 5246, 5384, 5500, 5502, 5697, 5938, 6196, 6197, 6346, 6495, 6795,
    6991, 8143, 8170, 8177, 8946, 9634, 10326, 12051, 12678, 13159, 13161, 13163, 13809, 18499, 18540, 19746,
    19752, 19801, 19878, 19879, 19880, 19882, 19883, 19884, 19885, 20230, 20271, 20608, 20719, 21084, 22570, 22812,
    23920, 25780, 25898, 26679, 27243, 29166, 29858, 29893, 30449, 30451, 30455, 30482, 31224, 31789, 31801, 31884,
    32182, 32223, 32375, 32546, 33076, 33745, 33763, 33786, 34026, 34074, 34428, 34433, 34477, 34600, 36936, 43987,
    45438
);
