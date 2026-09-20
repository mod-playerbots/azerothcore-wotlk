#!/usr/bin/env python
"""
Generates the ClassLess bounty-quest system from tools/classless-web/groups.json: one quest per
NAMED creature -- the rares and the dungeon bosses.

It used to be one per tome-carrying creature, read out of tomes.data, which worked while a tome
sat on one creature. Under the group rule (2026-09-13) every killable creature in the game carries
something, so "tome-carrying" stopped selecting anything: it would be 9150 bounties, one for every
murloc. A bounty is a pointer -- "go and kill this thing" -- and it is only worth printing for a
target worth naming, so the rares and bosses keep it and the trash does not.

The payout is unchanged and now comes from the groups too: Server.lua's TomesOfCreature reads
CLDB.groupof/groupmembers and hands over one of the target's own tomes.

Outputs:
  lua_scripts/ClassLess/data/bounties.data     -- CLDB.bounties[creatureEntry] = {...}
  data/sql/custom/classless_bounty_items.sql   -- one item_template row per creature (startquest)
  data/sql/custom/classless_bounty_quests.sql  -- one quest_template row per creature (kill x1)

Regenerate whenever tomes.data regenerates -- do not hand-edit the outputs.
"""
import json
import re

SRC_GROUPS = "d:/Servers/wow/tools/classless-web/groups.json"
# Which creatures are worth a bounty. See the module docstring: 901 killable rares and bosses,
# against 5866 trash mobs that also carry tomes now.
BOUNTY_STANDING = ("rare", "boss")
RANKS_TSV = "scratchpad/creature_ranks.tsv"  # entry\trank, dumped from creature_template (see below)
OUT_DATA = "lua_scripts/ClassLess/data/bounties.data"
OUT_ITEMS_SQL = "data/sql/custom/classless_bounty_items.sql"
OUT_QUESTS_SQL = "data/sql/custom/classless_bounty_quests.sql"

ITEM_BASE = 67000    # free: existing custom items stop at 66999 (classless_rank_items.sql)
QUEST_BASE = 901000  # matches the 900000 custom-content block classless_tome_vendors.sql already claims
# The id blocks these outputs own outright. DELETE clears the whole block, not just up to the
# current last id -- the count shrinks whenever tomes move onto fewer creatures, and deleting
# only up to the new maximum leaves the tail of the previous run live in the DB.
#
# Sized with room, not to the current count. The blocks were 2000 and 2000 wide when there
# were 1535 bounties; de-crowding the carriers took the count to 2763 and the item INSERT
# collided with the tail of the previous run that the too-short DELETE had left behind --
# "Duplicate entry '69000'" aborts the whole statement, so 2000 letters silently failed to
# import while their quests succeeded. item_template is free from 67000 to 72999 (63000-66999
# is the tome block, 73000-76999 the retired hint notes) and quest_template from 901000 to
# 906999. The assertion below is the real guard: an overflow must stop the run, not write a
# file whose DELETE cannot cover its own INSERT.
ITEM_BLOCK_END = 72999
QUEST_BLOCK_END = 906999
BOUNTY_DISPLAY_ID = 3093  # stock "Musty Missive" scroll icon -- no new display override needed

# Kills required, by creature_template.rank. This is the deterministic route to a tome:
# Server.lua hands over one of the target's own unread tomes when the bounty completes, so
# these numbers are the ceiling on how long any single tome can take, whatever the loot roll
# does. Elites and rares ask for fewer because each kill costs more.
KILLS = {0: 8, 1: 3, 2: 3, 4: 3, 3: 1}

LINE_RE = re.compile(
    r'^\s*\[(\d+)\]=\{(\d+),"([bcq])",(\d+),"((?:[^"\\]|\\.)*)","((?:[^"\\]|\\.)*)",'
    r'(\d+),(\d+)\},\s*--\s*(.+?)\s*\((?:spell|talent)\)\s*$'
)


def lua_unescape(s):
    r"""Undo the Lua string escaping in a name captured out of tomes.data.

    LINE_RE captures the raw SOURCE text between the quotes, backslashes and all, so a
    creature called Maury "Club Foot" Wilkins arrives here as: Maury \"Club Foot\" Wilkins.
    Writing that straight back out re-escapes the backslash as well as the quote, producing
    \\" -- which ends the Lua string early and makes bounties.data fail to parse. It did:
    the file was unloadable at line 470 and Server.lua had been logging "no bounty data --
    bounty quests are disabled" ever since, disabling all 1656 of them.

    One left-to-right pass, so \\" (an escaped backslash followed by a quote) survives
    correctly rather than being mangled by chained str.replace calls.
    """
    return re.sub(r"\\(.)", r"\1", s)


def sql_escape(s):
    # Names reach here already unescaped by lua_unescape, so only the SQL quote matters.
    return s.replace("'", "''")


def main():
    creatures = {}  # entry -> {"name", "place", "level"}
    order = []
    doc = json.load(open(SRC_GROUPS, encoding="utf-8"))
    for entry, c in doc["npc"].items():
        if not c["both"] or c["standing"] not in BOUNTY_STANDING:
            continue
        entry = int(entry)
        creatures[entry] = {"name": c["name"], "place": c["zone"], "level": max(1, c["level"])}
        order.append(entry)

    if not creatures:
        raise SystemExit("No bounty targets in " + SRC_GROUPS + " -- has groups.py been run?")

    order.sort()  # stable, deterministic ids regardless of file order

    # creature_template.rank (CreatureEliteType: 0 normal, 1 elite, 2 rareelite, 3 worldboss,
    # 4 rare) -- lets Server.lua weight bounty draws toward rare/elite targets. Dumped from the
    # live world DB rather than parsed out of data/sql/base (which may be stale against custom
    # content changes):
    #   mysql -h127.0.0.1 -P3306 -uacore -pacore acore_world -N \
    #       -e "SELECT entry, `rank` FROM creature_template;" > scratchpad/creature_ranks.tsv
    ranks = {}
    with open(RANKS_TSV, "r", encoding="utf-8") as f:
        for line in f:
            entry_s, rank_s = line.rstrip("\n").split("\t")
            ranks[int(entry_s)] = int(rank_s)

    rows = []
    for i, entry in enumerate(order):
        c = creatures[entry]
        item_id = ITEM_BASE + i
        quest_id = QUEST_BASE + i
        name, place, level = c["name"], c["place"], max(1, c["level"])
        rank = ranks.get(entry, 0)
        rows.append((entry, item_id, quest_id, name, place, level, rank))

    # An id past the block end is not a warning: the file's own DELETE is written from the
    # block, so the overflowing rows would survive one run and then collide with the next
    # INSERT, which aborts the statement and loses every letter in that chunk.
    if rows and (rows[-1][1] > ITEM_BLOCK_END or rows[-1][2] > QUEST_BLOCK_END):
        raise SystemExit(
            "bounty id block overflow: %d bounties need item ids up to %d (block ends %d) "
            "and quest ids up to %d (block ends %d). Widen the block -- and check what else "
            "claims the ids you widen into." % (len(rows), rows[-1][1], ITEM_BLOCK_END,
                                                rows[-1][2], QUEST_BLOCK_END))

    # --- bounties.data (Lua, loaded server-side by Server.lua) ---
    with open(OUT_DATA, "w", encoding="utf-8", newline="\n") as f:
        f.write("--BOUNTIES\n")
        f.write("-- GENERATED by scratchpad/bounty_quests.py -- regenerate, do not hand-edit.\n")
        f.write("--\n")
        f.write("-- One bounty per tome-carrying CREATURE (not per rank -- a creature carrying\n")
        f.write("-- several tomes still gets one quest). Deliberately excludes \"q\" (quest-sourced)\n")
        f.write("-- and \"s\" (starter) rows from tomes.data: neither has a killable creature source.\n")
        f.write("--\n")
        f.write("-- CLDB.bounties[creatureEntry] = { itemId, questId, \"name\", \"place\", level, rank }\n")
        f.write("-- rank is creature_template.rank (CreatureEliteType): 0 normal, 1 elite,\n")
        f.write("-- 2 rareelite, 3 worldboss, 4 rare. Server.lua weights draws toward rank>=1.\n")
        f.write("\n")
        f.write("if CLDB==nil then CLDB={} end\n")
        f.write("if CLDB.bounties==nil then CLDB.bounties={} end\n")
        f.write("\n")
        f.write("CLDB.bounties={\n")
        for entry, item_id, quest_id, name, place, level, rank in rows:
            f.write(
                '    [%d]={%d,%d,"%s","%s",%d,%d},\n'
                % (entry, item_id, quest_id, name.replace('"', '\\"'), place.replace('"', '\\"'), level, rank)
            )
        f.write("}\n")

    # --- item_template: the drop that offers the bounty ---
    with open(OUT_ITEMS_SQL, "w", encoding="utf-8", newline="\n") as f:
        f.write("-- ClassLess bounty items: one per tome-carrying creature. Granted by Server.lua\n")
        f.write("-- on kill (BOUNTY_DROP_CHANCE), restricted to creatures that do NOT themselves\n")
        f.write("-- carry a tome (tomeCarrierEntries) -- the whole point is to send players at\n")
        f.write("-- mobs they would otherwise have no reason to fight.\n")
        f.write("--\n")
        f.write("-- GENERATED by scratchpad/bounty_quests.py -- regenerate, do not hand-edit.\n")
        f.write("--\n")
        f.write("-- Using the item offers the matching bounty quest (startquest); accepting\n")
        f.write("-- consumes it, same as any Blizzard item-started quest. displayid 3093 is the\n")
        f.write("-- stock \"Musty Missive\" scroll icon, reused as-is.\n")
        f.write("\n")
        last_item = ITEM_BASE + len(rows) - 1
        f.write("DELETE FROM `item_template` WHERE `entry` BETWEEN %d AND %d;\n" % (ITEM_BASE, ITEM_BLOCK_END))
        f.write(
            "INSERT INTO `item_template` (entry, class, subclass, name, displayid, Quality, "
            "BuyCount, BuyPrice, SellPrice, InventoryType, ItemLevel, RequiredLevel, maxcount, "
            "stackable, bonding, Material, sheath, startquest, description) VALUES\n"
        )
        for i, (entry, item_id, quest_id, name, place, level, rank) in enumerate(rows):
            item_name = sql_escape("Bounty: " + name)
            desc = sql_escape('A local asks that you deal with "' + name + '"' +
                               ((" in " + place) if place else "") + ".")
            sep = "," if i < len(rows) - 1 else ";"
            f.write(
                "    (%d, 9, 0, '%s', %d, 1, 1, 0, 0, 0, 1, 1, 1, 1, 2, 0, 0, %d, '%s')%s\n"
                % (item_id, item_name, BOUNTY_DISPLAY_ID, quest_id, desc, sep)
            )

    # --- quest_template: kill x1, XP/gold only, no turn-in NPC ---
    with open(OUT_QUESTS_SQL, "w", encoding="utf-8", newline="\n") as f:
        f.write("-- ClassLess bounty quests: one per tome-carrying creature, kill x1, XP/gold\n")
        f.write("-- only -- no item reward, so the tome itself stays the creature's own\n")
        f.write("-- loot-table roll, untouched by this. Rewarded server-side the instant kill\n")
        f.write("-- credit lands (Server.lua's OnCreatureKillForHint, extended) via\n")
        f.write("-- player:RewardQuest() -- there is no turn-in NPC for these, so none is needed.\n")
        f.write("--\n")
        f.write("-- GENERATED by scratchpad/bounty_quests.py -- regenerate, do not hand-edit.\n")
        f.write("\n")
        last_quest = QUEST_BASE + len(rows) - 1
        f.write("DELETE FROM `quest_template` WHERE `ID` BETWEEN %d AND %d;\n" % (QUEST_BASE, QUEST_BLOCK_END))
        f.write(
            "INSERT INTO `quest_template` (ID, QuestType, QuestLevel, MinLevel, AllowableRaces, "
            "RewardXPDifficulty, RewardMoney, StartItem, RequiredNpcOrGo1, RequiredNpcOrGoCount1, "
            "LogTitle, LogDescription, QuestDescription, ObjectiveText1, QuestCompletionLog) VALUES\n"
        )
        for i, (entry, item_id, quest_id, name, place, level, rank) in enumerate(rows):
            need = KILLS.get(rank, 8)
            log_title = sql_escape("Bounty: " + name)
            log_desc = sql_escape('"' + name + '" has been causing trouble' +
                                   ((" in " + place) if place else "") +
                                   ". Thin them out and whatever lore they carry is yours.")
            obj_text = sql_escape(("Slay " + name + ".") if need == 1
                                  else ("Slay %d x %s." % (need, name)))
            complete_log = sql_escape("The bounty is settled -- claim what they carried.")
            money = level * 200  # 2 silver/level -- a modest side-incentive, not core questing income
            sep = "," if i < len(rows) - 1 else ";"
            f.write(
                "    (%d, 2, %d, 1, 0, 2, %d, %d, %d, %d, '%s', '%s', '%s', '%s', '%s')%s\n"
                % (quest_id, level, money, item_id, entry, need, log_title, log_desc, log_desc,
                   obj_text, complete_log, sep)
            )

        # quest_template_addon.ProvidedItemCount is what the engine actually reads as
        # StartItemCount (ObjectMgr::LoadQuests, ~line 5476) -- a quest with StartItem set
        # but no addon row here logs "StartItemCount = 0, set to 1 but need fix in DB" for
        # every single load. Self-heals in memory either way, but 1739 of them is log spam.
        f.write("\n")
        f.write("DELETE FROM `quest_template_addon` WHERE `ID` BETWEEN %d AND %d;\n" % (QUEST_BASE, QUEST_BLOCK_END))
        # SpecialFlags 1 = QUEST_SPECIAL_FLAGS_REPEATABLE. A creature can carry several tomes
        # and each completion hands over one, so the quest has to be takeable again -- every
        # further bounty item for the same target is another guaranteed book.
        f.write("INSERT INTO `quest_template_addon` (ID, ProvidedItemCount, SpecialFlags) VALUES\n")
        for i, (entry, item_id, quest_id, name, place, level, rank) in enumerate(rows):
            sep = "," if i < len(rows) - 1 else ";"
            f.write("    (%d, 1, 1)%s\n" % (quest_id, sep))

    print("wrote %d bounties (items %d-%d, quests %d-%d) to %s, %s, %s" % (
        len(rows), ITEM_BASE, ITEM_BASE + len(rows) - 1, QUEST_BASE, QUEST_BASE + len(rows) - 1,
        OUT_DATA, OUT_ITEMS_SQL, OUT_QUESTS_SQL))


if __name__ == "__main__":
    main()
