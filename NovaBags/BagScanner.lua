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


    print("|cff00ff00Nova scanning bags...|r")



    for bag = 0,4 do


        local slots = GetContainerNumSlots(bag)


        print("Bag "..bag.." slots: "..slots)



        for slot = 1, slots do


            local texture, count, locked, quality, readable, lootable, link =
            GetContainerItemInfo(
                bag,
                slot
            )



            if link then


                print(
                    "Found item:",
                    link
                )


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



    print(
        "|cff00ff00Nova found "
        ..
        #NovaInventory
        ..
        " items|r"
    )


end
