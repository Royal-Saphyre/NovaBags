--=============================================================================
-- NovaBags
-- File: BagScanner.lua
--
-- Handles reading player bags
--=============================================================================

NovaInventory = {}


function NovaScanBags()

    NovaInventory = {}

    for bag = 0, 4 do

        local slots = GetContainerNumSlots(bag)

        for slot = 1, slots do

            local texture, count = GetContainerItemInfo(bag, slot)
            local link = GetContainerItemLink(bag, slot)

            if link then

                table.insert(
                    NovaInventory,
                    {
                        bag = bag,
                        slot = slot,
                        link = link,
                        count = count or 1
                    }
                )

            end

        end
    end


    print("|cffd4af37Nova|r found "..#NovaInventory.." items.")

end

SLASH_NOVASCAN1 = "/novascan"

SlashCmdList["NOVASCAN"] = function()

    NovaScanBags()

end
