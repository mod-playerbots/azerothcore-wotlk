-- Make elixirs stackable as buffs.
--
-- Elixir exclusivity is enforced purely by spell_group_stack_rules: group 1
-- (Battle Elixir, 77 spells) and group 2 (Guardian Elixir, 76 spells) are each set to
-- stack_rule = 1 (SPELL_GROUP_STACK_RULE_EXCLUSIVE), so only one aura per group can be
-- active at a time. There is no separate SpellSpecific rule -- this table is the only
-- thing blocking it.
--
-- Removing these two rows makes CheckSpellGroupStackRules fall back to DEFAULT (no
-- exclusivity), so different elixirs coexist. Note: same-elixir reapply still only
-- refreshes duration (normal aura behaviour), and flasks now stack with elixirs too,
-- since flasks relied on the same group exclusivity. The spell_group memberships are
-- left intact so this is reversible by re-inserting the two rows.

DELETE FROM `spell_group_stack_rules` WHERE `group_id` IN (1, 2);
