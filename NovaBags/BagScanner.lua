--=============================================================================
-- NovaBags
-- File: BagScanner.lua
--
-- Scans player bags
--=============================================================================

NovaInventory = {}


function NovaScanBags()

    NovaInventory = {}


    for bag = 0, 4 do


        local slots = GetContainerNumSlots(bag)


        for slot = 1, slots do


            local link = GetContainerItemLink(
                bag,
                slot
            )


            if link then


                local texture, count =
                GetContainerItemInfo(
                    bag,
                    slot
                )


                table.insert(
                    NovaInventory,
                    {
                        link = link,
                        count = count or 1,
                        bagID = bag,
                        slotID = slot,
                        texture = texture
                    }
                )


            end


        end


    end


end
