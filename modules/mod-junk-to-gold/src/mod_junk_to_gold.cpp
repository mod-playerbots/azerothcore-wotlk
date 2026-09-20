#include "Chat.h"
#include "Player.h"
#include "ScriptMgr.h"

// Below this level a grey item that can be WORN is left in the bag instead of being sold.
//
// Grey is only junk to a character that already has better. At level 1 to 10 it is the gear: a
// new character owns a shirt and whatever it was created with, and the first grey bracer off a
// kobold is a real upgrade. Selling it for the few copper it is worth took the upgrade away
// before the player ever saw it, which is the opposite of what this module is for.
//
// 11 and not a rounder number because the request was "1-10 kozott" -- the whole of the first ten
// levels, so the cut is above level 10.
constexpr uint8 KEEP_GREY_GEAR_BELOW_LEVEL = 11;

class JunkToGold : public PlayerScript
{
public:
    JunkToGold() : PlayerScript("JunkToGold") {}

    void OnPlayerLootItem(Player* player, Item* item, uint32 count, ObjectGuid /*lootguid*/) override
    {
        if (!item || !item->GetTemplate())
        {
            return;
        }

        if (item->GetTemplate()->Quality != ITEM_QUALITY_POOR)
        {
            return;
        }

        if (player->GetLevel() < KEEP_GREY_GEAR_BELOW_LEVEL && IsWearable(item->GetTemplate()))
        {
            return;
        }

        SendTransactionInformation(player, item, count);
        player->ModifyMoney(item->GetTemplate()->SellPrice * count);
        player->DestroyItem(item->GetBagSlot(), item->GetSlot(), true);
    }

private:
    // Armour and weapons, and only ones that occupy a slot. InventoryType is the test that keeps
    // this to actual equipment: it is NON_EQUIP for the grey items that merely sit in the same
    // classes without being wearable, and those stay sellable at every level.
    static bool IsWearable(ItemTemplate const* proto)
    {
        if (proto->InventoryType == INVTYPE_NON_EQUIP)
        {
            return false;
        }

        return proto->Class == ITEM_CLASS_ARMOR || proto->Class == ITEM_CLASS_WEAPON;
    }

    void SendTransactionInformation(Player* player, Item* item, uint32 count)
    {
        std::string name;
        if (count > 1)
        {
            name = Acore::StringFormat("|cff9d9d9d|Hitem:{}::::::::80:::::|h[{}]|h|rx{}", item->GetTemplate()->ItemId, item->GetTemplate()->Name1, count);
        }
        else
        {
            name = Acore::StringFormat("|cff9d9d9d|Hitem:{}::::::::80:::::|h[{}]|h|r", item->GetTemplate()->ItemId, item->GetTemplate()->Name1);
        }

        uint32 money = item->GetTemplate()->SellPrice * count;
        uint32 gold = money / GOLD;
        uint32 silver = (money % GOLD) / SILVER;
        uint32 copper = (money % GOLD) % SILVER;

        std::string info;
        if (money < SILVER)
        {
            info = Acore::StringFormat("{} sold for {} copper.", name, copper);
        }
        else if (money < GOLD)
        {
            if (copper > 0)
            {
                info = Acore::StringFormat("{} sold for {} silver and {} copper.", name, silver, copper);
            }
            else
            {
                info = Acore::StringFormat("{} sold for {} silver.", name, silver);
            }
        }
        else
        {
            if (copper > 0 && silver > 0)
            {
                info = Acore::StringFormat("{} sold for {} gold, {} silver and {} copper.", name, gold, silver, copper);
            }
            else if (copper > 0)
            {
                info = Acore::StringFormat("{} sold for {} gold and {} copper.", name, gold, copper);
            }
            else if (silver > 0)
            {
                info = Acore::StringFormat("{} sold for {} gold and {} silver.", name, gold, silver);
            }
            else
            {
                info = Acore::StringFormat("{} sold for {} gold.", name, gold);
            }
        }

        ChatHandler(player->GetSession()).SendSysMessage(info);
    }
};

void Addmod_junk_to_goldScripts()
{
    new JunkToGold();
}
