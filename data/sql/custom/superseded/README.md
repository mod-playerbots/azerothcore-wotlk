# Superseded ClassLess SQL — what was retired, and why

**The files themselves were deleted on 2026-09-15.** This page is the record of what used to be
here, kept because the reasons still matter: every one of these files, if it were ever
reintroduced and applied, would silently revert work that a generator now owns.

The authoritative list lives in code, not here: `tools/classless-web/merge_sql.py` carries an
`EXCLUDED` table naming each retired file and its successor, and prints it into the header of the
merged `db_world/classless.sql` on every run. That list keeps working with the files gone — it is
documentation, never opened.

## Layered loot builds, replaced by a single generated pass

The tome loot table used to be built in layers: a generated base, then a replacement pass, then a
source fix, then the retheme, then a separate file for alt sources. Running any of them after the
generator silently reverted placements.

| file | replaced by |
|---|---|
| classless_rank_loot.sql | classless_tome_loot.sql, then classless_group_loot.sql |
| classless_rank_loot_replace.sql | as above |
| classless_rank_loot_retheme.sql | as above |
| classless_rank_loot_srcfix.sql | as above |
| classless_alt_tomes_loot.sql | as above (alt rows are emitted with the table) |
| classless_tomes_loot.sql | nothing — loot for the retired 60000-61999 line tomes |
| classless_tomes_loot_fix.sql | nothing — a patch on the file above |

Per-row placement itself was retired on 2026-09-13 in favour of the group rule, so
`classless_tome_loot.sql`, `classless_tome_chances.sql` and `classless_tome_conditions.sql` are
superseded in their turn by `classless_group_loot.sql`.

## Patches on generated item columns

`tools/classless-web/rank_items.py` writes every column of `classless_rank_items.sql` itself, so a
second file UPDATEing one of them gave that column two owners.

| file | folded into |
|---|---|
| classless_tome_use_spell_fix.sql | classless_rank_items.sql (emits spellid_1 18282) |
| classless_rank_required_level.sql | classless_rank_items.sql (emits RequiredLevel) |
| classless_tome_quality_floor.sql | classless_rank_items.sql (never emits Quality below 2) |

## One-shot migrations that must never run twice

| file | why |
|---|---|
| rev_1786654338394442900.sql | halved every `%(spell)%` loot chance on **each** run, and it lived in `updates/pending_db_world/`, where the AC updater re-applies a file whose hash changes. Its three jobs are owned by generators now. Also removed from `acore_world.updates`. |
| classless_drop_panel_columns.sql | `DROP COLUMN` on `acore_characters.character_classless`, applied in full and not re-runnable. The table is now exactly the five columns `Server.lua` reads. |
| ahbot_account_character.sql | replaced by `realm_accounts.sql`. It hard-coded the AH bot's character at **guid 1**, which on a realm built from zero belongs to a random bot the manager is actively using — its `ON DUPLICATE KEY UPDATE` would have taken that bot over. |

Two more were retired with their successors: `classless_npc_casts.sql` and
`classless_npc_casts_retire.sql`, both superseded by `classless_npc_showcast.sql`, which owns the
same `smart_scripts` id band and opens with the same unfiltered DELETE; and
`classless_rarebuff_boss_sources.sql`, since the generator now places rare pre-cast buffs on bosses
and nowhere else. `classless_tome_icons.sql` went with them: only npc_casts used the icon auras,
and a creature answers for a median of three groups now, so an icon per line would be a wall of
pictures on every mob.
