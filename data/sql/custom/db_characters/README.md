# Paragon schema and configuration

Files 01-14 are copies of `modules/Paragon-Anniversary/sql/`, kept here because AzerothCore's
updater scans `data/sql/custom/**` and the module's own `sql/` directory is not applied by
anything. They run in filename order, which is also dependency order: 01-05 build the schema and
triggers in `acore_ale`, 06-07 insert the configuration, 08-14 are the migrations on top of it.

**01-06 used to be the only ones here.** 07-14 were applied by hand and never written into the
automated tree, so a realm built from zero came up with 18 rows in `paragon_config` instead of 31
— missing the progression config, the utility statistics, the bonus-stat lock and merge, the
recovery removal, the reordering, and the level-60 XP gate. Copied in on 2026-09-15.

**`11-13-2026_Example_Data.sql` was REMOVED on 2026-09-15 and must not come back.** It is the
module's sample dump, and it was actively destructive in this position:

  * it opens `USE acore_ale` and then `DROP TABLE IF EXISTS` on all ten Paragon tables,
  * its filename sorts between `10_merge_bonus_into_other.sql` and `11_remove_recovery.sql`
    (`-` is 0x2D, `_` is 0x5F), so on a from-zero install it dropped everything 06-10 had just
    inserted and left 11-14 running against empty tables,
  * it recreates the ten tables but **none of the two triggers** `05_create_triggers.sql` makes,
    because DROP TABLE takes a table's triggers with it,
  * and it carries zero `INSERT INTO paragon_config` rows, so it never supplied the data it
    destroyed.

Nothing is lost by its absence: 02, 03 and 04 create all ten tables themselves, fully qualified as
`acore_ale`.`...` and guarded with IF NOT EXISTS.

`character_classless.sql` is unrelated to Paragon — it is the ClassLess per-character table.
