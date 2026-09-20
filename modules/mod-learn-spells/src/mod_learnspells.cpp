#include "Player.h"
#include "ScriptMgr.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "AreaTriggerScript.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include <string>
#include "Spell.h"

using namespace std;

enum class SPECS_SKILL_IDS
{
    //RUGO
    ASSASSINATION = 253,
    COMBAT = 38,
    SUBTETLY = 39,
    //HUNTER
    SURVIVAL = 51,
    BEAST_MASTERY = 50,
    MARKSMANSHIP =163,
    // SHAMAN
    ENHANCEMENT = 373,
    ELEMENTAL_COMBAT = 375,
    RESTORATION_SHAMAN =374,
    // PRIEST
    HOLY_PRIEST = 56,
    DISCIPLINE=613,
    SHADOW = 78,
    // PALADIN
    RETRIBUTION = 184,
    PROTECTION_PALADIN =267,
    HOLY_PALADIN = 594,
    // MAGE
    FROST =6,
    FIRE = 8,
    ARCANE=237,
    // WARLOCK
    DEMONOLOGY = 354,
    AFFLICTION =355,
    DESTRUCTION =593,
    // WARRIOR
    PROTECTION_WARRIOR = 257,
    FURY = 256,
    ARMS = 26,
    // DRUID
    RESTORATION_DRUID =573,
    BALANCE =574,
    FERAL_COMBAT = 134,

};

enum class PROFFESSION_SKILL_IDS
{
    BLACKSMITHING = 164,
    LEATHERWORKING = 165,
    ALCHEMY = 171,
    HERBALISM = 182,
    MINING = 186,
    TAILORING = 197,
    ENGINEERING = 202,
    ENCHANTING = 333,
    SKINNING = 393,
    JEWELCRAFTING = 755,
    INSCRIPTION = 773,
    FISHING = 356,
    COOKING = 185,
    FIRST_AID = 129,
};

enum class PROFFESSION_SPELL_IDS
{
    BLACKSMITHING = 2018,
    LEATHERWORKING = 2108,
    ALCHEMY = 2259,
    HERBALISM = 2366,
    MINING = 2575,
    TAILORING = 3908,
    ENGINEERING = 4036,
    ENCHANTING = 7411,
    SKINNING = 8613,
    INSCRIPTION = 45357,
    FISHING = 7620,
    COOKING = 2550,
    FIRST_AID = 3273,
    JEWELCRAFTING = 25229,
};

enum class SKILL_IDS
{
    SWORDS = 43,
    AXES = 44,
    BOWS = 45,
    GUNS = 46,
    MACES = 54,
    TWO_H_SWORDS = 55,
    DEFENSE = 95,
    STAVES = 136,
    TWO_H_MACES = 160,
    TWO_H_AXES = 172,
    DAGGERS = 173,
    THROWN = 176,
    CROSSBOWS = 226,
    WANDS = 228,
    POLEARMS = 229,
    SHIELD = 433,
    FIST_WEAPONS = 473,
    LOCKPICKING = 633,
    MAIL = 413,
    PLATE = 293,
    LEATHER = 414,
    CLOTH = 415,
    DUAL_WIELD = 118
};

enum class SKILL_SPELL_IDS : uint32_t
{
    SWORDS = 201,
    AXES = 196,
    BOWS = 264,
    GUNS = 266,
    MACES = 198,
    TWO_H_SWORDS = 202,
    DEFENSE = 204,
    STAVES = 227,
    TWO_H_MACES = 199,
    TWO_H_AXES = 197,
    DAGGERS = 1180,
    THROWN = 2567,
    CROSSBOWS = 5011,
    WANDS = 5009,
    POLEARMS = 200,
    SHIELD = 9116,
    FIST_WEAPONS = 15590,
    MAIL = 8737,
    PLATE = 750,
    CLOTH = 9078,
    LEATHER = 9077,
    LOCKPICKING = 1804,

    DUAL_WIELD = 674,
    LANGUAGE_COMMON = 668,
    LIBRAM = 27762,
    BLOCK = 107,
    IDOL = 27764,
    UNARMED = 203,
    THROW = 2764,
    PARRY = 3127,
    SHOOT = 5019,
    DODGE = 81,
};

vector<pair<PROFFESSION_SKILL_IDS, PROFFESSION_SPELL_IDS>> autoLearnProfessions = {
    {PROFFESSION_SKILL_IDS::BLACKSMITHING, PROFFESSION_SPELL_IDS::BLACKSMITHING},
    {PROFFESSION_SKILL_IDS::LEATHERWORKING, PROFFESSION_SPELL_IDS::LEATHERWORKING},
    {PROFFESSION_SKILL_IDS::ALCHEMY, PROFFESSION_SPELL_IDS::ALCHEMY},
    {PROFFESSION_SKILL_IDS::HERBALISM, PROFFESSION_SPELL_IDS::HERBALISM},
    {PROFFESSION_SKILL_IDS::MINING, PROFFESSION_SPELL_IDS::MINING},
    {PROFFESSION_SKILL_IDS::TAILORING, PROFFESSION_SPELL_IDS::TAILORING},
    {PROFFESSION_SKILL_IDS::ENGINEERING, PROFFESSION_SPELL_IDS::ENGINEERING},
    {PROFFESSION_SKILL_IDS::ENCHANTING, PROFFESSION_SPELL_IDS::ENCHANTING},
    {PROFFESSION_SKILL_IDS::SKINNING, PROFFESSION_SPELL_IDS::SKINNING},
    {PROFFESSION_SKILL_IDS::JEWELCRAFTING, PROFFESSION_SPELL_IDS::JEWELCRAFTING},
    {PROFFESSION_SKILL_IDS::INSCRIPTION, PROFFESSION_SPELL_IDS::INSCRIPTION},
    {PROFFESSION_SKILL_IDS::FISHING, PROFFESSION_SPELL_IDS::FISHING},
    {PROFFESSION_SKILL_IDS::COOKING, PROFFESSION_SPELL_IDS::COOKING},
    {PROFFESSION_SKILL_IDS::FIRST_AID, PROFFESSION_SPELL_IDS::FIRST_AID},
};

// Only what a character cannot function without.
//
// This list used to hold all 23 proficiencies, handed to everyone for free. The other 21
// are now COLLECTED -- ClassLess (lua_scripts/ClassLess/, data/proficiencies.data) drops a
// manual for each of them in the world and re-applies the earned ones on login, using this
// same "SetSkill, learn, then cast every session" recipe. Granting them here as well would
// make that collection meaningless, because a proficiency mask can only be added to and
// never taken away.
//
// These two stay, and must:
//   CLOTH   -- with no armour proficiency at all a character cannot equip ANY armour,
//              not even the shirt it is created wearing.
//   DEFENSE -- this is the defence SKILL rather than a proficiency. Without it a character
//              has no defence rating and is crit by everything.
//
// A character's class-appropriate starting proficiencies are unaffected either way: they
// come from playercreateinfo_spell_custom, which this module does not touch.
vector<pair<SKILL_IDS, SKILL_SPELL_IDS>> autoLearnSkills = {
    {SKILL_IDS::CLOTH, SKILL_SPELL_IDS::CLOTH},
    {SKILL_IDS::DEFENSE, SKILL_SPELL_IDS::DEFENSE},
};

// Every profession rank spell raises the cap to step * 75 (SpellMgr::LoadSpellLearnSkills),
// so a cap is always an exact multiple of this and doubles as the rank number.
constexpr uint16 PROFESSION_RANK_CAP = 75;

// Grants whatever of the classless set the player is currently missing.
//
// This has to be re-applied on every login rather than granted once: Player::_LoadSkills
// deletes any skill that fails GetSkillRaceClassInfo() for the character's race/class
// (unconditionally), and Player::_LoadSpells drops any spell whose skill line fails the
// same check when ValidateSkillLearnedBySpells is on. On a classless server that strips
// Mail (413) and Plate (293) — and their proficiency spells — from most classes on the
// way in, which is why equipping mail failed with "no required proficiency".
static void GrantClasslessDefaults(Player* player)
{
    for (auto const& skills : autoLearnSkills)
    {
        uint16 skillId = static_cast<uint16>(skills.first);
        uint32 spellId = static_cast<uint32>(skills.second);

        if (!player->HasSkill(skillId))
            player->SetSkill(skillId, 5, 1, 5);

        if (!player->HasSpell(spellId))
            player->addSpell(spellId, SPEC_MASK_ALL, true);
    }

    for (auto const& profession : autoLearnProfessions)
    {
        uint16 skillId = static_cast<uint16>(profession.first);
        uint32 spellId = static_cast<uint32>(profession.second);

        if (!player->HasSkill(skillId))
            player->SetSkill(skillId, 1, 1, PROFESSION_RANK_CAP);

        if (!player->HasSpell(spellId))
            player->addSpell(spellId, SPEC_MASK_ALL, true);
    }

    // Find resources custom spell
    if (!player->HasSpell(200000))
        player->addSpell(200000, SPEC_MASK_ALL, true);
}

static bool IsAutoRankedProfession(uint32 skillId)
{
    for (auto const& profession : autoLearnProfessions)
        if (static_cast<uint32>(profession.first) == skillId)
            return true;

    return false;
}

// Teaches the next rank spell (Apprentice -> Journeyman -> ... -> Grand Master) once the
// player has filled the cap the current rank granted, so professions never need a trainer.
//
// Only the spell has to be learned: Player::_addSpell reads the spell's SPELL_EFFECT_SKILL
// node and raises the cap to step * 75 itself. Returns true when a rank was granted, so
// callers can loop a character that is several ranks behind.
static bool GrantNextProfessionRank(Player* player, uint32 skillId)
{
    uint16 const value = player->GetPureSkillValue(skillId);
    uint16 const maxValue = player->GetPureMaxSkillValue(skillId);

    if (!value || value < maxValue)
        return false;

    // The current rank is derived from the cap rather than from GetSkillStep(): character_skills
    // persists only value/max, and the step _LoadSkills rebuilds from them is 0 for every cap
    // above 75 — its tier loop compares SkillTiers::Value[skillStep] instead of Value[i], so
    // with skillStep still 0 only the first tier (75) can ever match. Trusting that step would
    // make every relog above rank 1 re-apply the rank-1 cap and knock the profession back to 75.
    uint32 const currentStep = maxValue / PROFESSION_RANK_CAP;

    // GetSkillRankSpells is ordered by step, so the first entry above the current step is
    // the next rank.
    for (uint32 rankSpell : sSpellMgr->GetSkillRankSpells(skillId))
    {
        SpellLearnSkillNode const* node = sSpellMgr->GetSpellLearnSkill(rankSpell);
        if (!node || node->step <= currentStep)
            continue;

        if (player->HasSpell(rankSpell))
        {
            // Spell known but the cap was never applied — happens when _LoadSkills drops
            // the skill line for the character's race/class and GrantClasslessDefaults
            // re-adds it at step 1. Re-sync instead of leaving the player stuck.
            player->SetSkill(node->skill, node->step, value, node->maxvalue);
        }
        else
        {
            player->learnSpell(rankSpell);
        }

        return true;
    }

    return false;
}

class LearnClasslessDefaults : public PlayerScript
{
public:
    LearnClasslessDefaults() : PlayerScript("LearnClasslessDefaults") {

    }
    // Granted at character creation rather than first login: the player is not in world
    // yet, so neither addSpell nor the skill-reward spells learned inside SetSkill send
    // SMSG_LEARNED_SPELL. That packet is what makes the client auto-place a spell on the
    // first free action button. The spells reach the client in the initial spell list.
    void OnPlayerCreate (Player *player) override
    {
            if(player->GetSession()->IsBot()){
                return;
            }

            GrantClasslessDefaults(player);

            // OnPlayerCreate fires from the completion callback of the character-creation
            // transaction (CharacterHandler.cpp), i.e. after the character has already been
            // written, and the Player is destroyed immediately afterwards. Without an
            // explicit save everything granted above is discarded.
            player->SaveToDB(false, false);
    }

    void OnPlayerLogin(Player* player) override
    {
        if (player->GetSession()->IsBot())
        {
            return;
        }

        GrantClasslessDefaults(player);

        // Weapon/armour proficiency is not persisted — Player::m_ArmorProficiency and
        // m_WeaponProficiency are set only by SPELL_EFFECT_PROFICIENCY, so the proficiency
        // spells must actually be cast each session, not merely be known.
        for (auto const& skills : autoLearnSkills)
        {
            player->CastSpell(player, static_cast<uint32>(skills.second), true);
        }

        // A character already sitting at its cap never fires OnPlayerUpdateSkill again --
        // UpdateSkill and UpdateSkillPro both bail out on value >= max before reaching the
        // hook -- so anything parked at a rank boundary has to be caught up here. Bounded
        // rather than while(true) so a rank that fails to apply cannot spin.
        for (auto const& profession : autoLearnProfessions)
        {
            uint32 skillId = static_cast<uint32>(profession.first);

            for (uint8 rank = 0; rank < MAX_SKILL_STEP; ++rank)
                if (!GrantNextProfessionRank(player, skillId))
                    break;
        }
    }

    // Fires only on an actual skill gain, with newValue already clamped to the cap, so
    // reaching the cap is exactly newValue == max.
    //
    // Calling learnSpell here re-enters SetSkill while UpdateSkill/UpdateSkillPro are still
    // on the stack. That is safe because both fire this hook as their last statement before
    // returning and do not touch their mSkillStatus iterator afterwards -- SetSkill can
    // rehash that map.
    void OnPlayerUpdateSkill(Player* player, uint32 skillId, uint32 /*value*/, uint32 /*max*/, uint32 /*step*/, uint32 /*newValue*/) override
    {
        if (player->GetSession()->IsBot())
        {
            return;
        }

        if (!IsAutoRankedProfession(skillId))
        {
            return;
        }

        GrantNextProfessionRank(player, skillId);
    }
};

void AddSC_LearnAllSpells()
{
    new LearnClasslessDefaults();
}
