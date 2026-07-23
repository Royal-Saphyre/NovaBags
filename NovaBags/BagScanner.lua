--=============================================================================
-- NovaBags
-- File: BagScanner.lua
--
-- Scans player bags
--=============================================================================

NovaInventory = {}


function NovaScanBags()

    NovaInventory = {}


    local total = 0


    for bag = 0,4 do


        local slots = GetContainerNumSlots(bag)


        print("Nova scanning bag:", bag, "slots:", slots)



        for slot = 1, slots do



            local texture, count =
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



                total = total + 1



                print(
                    "Nova found:",
                    link,
                    "Bag:",
                    bag,
                    "Slot:",
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



    print(
        "|cff00ff00Nova scanned items:|r",
        total
    )


end
