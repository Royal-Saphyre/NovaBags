--=============================================================================
-- NovaBags
-- File: BagScanner.lua
--
-- Scans player bags
--=============================================================================

NovaInventory = {}


function NovaScanBags()


    wipe(NovaInventory)



    for bag = 0,4 do


        local slots = GetContainerNumSlots(bag)



        for slot = 1, slots do


            local texture, count, locked, quality, readable, lootable, link =
            GetContainerItemInfo(
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
