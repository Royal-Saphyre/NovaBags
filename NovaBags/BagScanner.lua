--=============================================================================
-- NovaBags
-- File: BagScanner.lua
--
-- Scans player bags
--=============================================================================

print("|cff00ff00BagScanner.lua loaded|r")


NovaInventory = {}


function NovaScanBags()


    wipe(NovaInventory)


    for bag = 0,4 do


        local slots = GetContainerNumSlots(bag)


        for slot = 1, slots do


            local texture, count, locked, quality =
            GetContainerItemInfo(
                bag,
                slot
            )


            local link =
            GetContainerItemLink(
                bag,
                slot
            )


            if link then


                table.insert(
                    NovaInventory,
                    {

                        bagID = bag,

                        slotID = slot,

                        link = link,

                        count = count or 1,

                        texture = texture

                    }
                )


            end


        end


    end


end
