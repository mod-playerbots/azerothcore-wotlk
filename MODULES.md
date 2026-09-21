# Installed Modules

Modules present in `modules/`, with their upstream repositories. Branch and commit
reflect the checkout on this machine as of 2026-09-21.

| Module | Repository | Branch | Commit |
| --- | --- | --- | --- |
| Paragon-Anniversary | https://github.com/Grim-Batol/Paragon-Anniversary | `main` | `a3cb1bb` |
| mod-ah-bot-plus | https://github.com/NathanHandley/mod-ah-bot-plus | `master` | `f685832` |
| mod-ale | https://github.com/budasnorbi/mod-eluna (fork of https://github.com/azerothcore/mod-ale) | `master` | `1cb86c9` |
| mod-arac | https://github.com/heyitsbench/mod-arac (fork of https://github.com/azerothcore/mod-arac) | `master` | `3f605e0` |
| mod-dungeon-clear | https://github.com/jrad7/mod-dungeon-clear | `master` | `fe8294f` |
| mod-guild-levels | https://github.com/Old-Man-Warcraft/mod-guild-levels | `main` | `f1ef557` |
| mod-individual-progression | https://github.com/ZhengPeiRu21/mod-individual-progression | `master` | `8b9608e` |
| mod-junk-to-gold | https://github.com/noisiver/mod-junk-to-gold | `master` | `2134690` |
| mod-learn-spells | no separate remote — vendored in this repo (https://github.com/budasnorbi/azerothcore-wotlk-bots, branch `custom`) | `custom` | `76733f2` |
| mod-playerbots | https://github.com/liyunfan1223/mod-playerbots | `master` | `049f3590` |

## What each module does

- **Paragon-Anniversary** — Paragon/Anniversary progression system; serverside is
  feature-complete, clientside UI still in development.
- **mod-ah-bot-plus** — Fork of the auction house bot aiming at a blizzlike AH:
  all configuration in config files (no SQL), inclusion/exclusion listing rules,
  category proportions, stack sizes, customizable pricing, a buying bot, and
  multiple AH bot identities.
- **mod-ale** — ALE (AzerothCore Lua Engine), the Eluna-derived Lua scripting
  engine. Runs Lua scripts from `lua_scripts`.
- **mod-arac** — All Races All Classes. Requires the ARAC client patch plus the
  `arac.sql` world-database query.
- **mod-dungeon-clear** — Autonomous dungeon-clearing mode for mod-playerbots
  tank bots: the tank drives the party boss to boss, clears trash, handles doors
  and scripted events, and routes are generated live from the navigation mesh
  (no waypoints).
- **mod-guild-levels** — Guild experience, 25 guild levels and Cataclysm-style
  perks. Progress stored in `acore_characters`.`guild_progress`; perks enforced
  in C++ (`PlayerScript`, `GuildScript`). Optional UI via mod-ale.
- **mod-individual-progression** — Per-player expansion/tier progression. Catch-up
  mechanics removed so every character replays the journey; works well with
  Playerbots. Also the supported way to gate Draenei/Blood Elf access.
- **mod-junk-to-gold** — Automatically sells gray items as the player loots them.
- **mod-learn-spells** — Teaches class spells automatically on level-up. Local
  module, not tracked as a submodule; source lives in
  `modules/mod-learn-spells/src` (`LS_loader.cpp`, `mod_learnspells.cpp`), AGPLv3.
- **mod-playerbots** — Player bot framework: AI-driven bot characters that group,
  quest, raid and PvP alongside real players.
