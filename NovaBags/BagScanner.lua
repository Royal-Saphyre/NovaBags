--=============================================================================
-- NovaBags
-- File: BagScanner.lua
-- Scans player bags for 3.3.5a
--=============================================================================

NovaInventory = {}

function NovaScanBags()
    wipe(NovaInventory)

    for bag = 0, 4 do
        local slots = GetContainerNumSlots(bag)
        if slots and slots > 0 then
            for slot = 1, slots do
                local texture, count, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)

                table.insert(NovaInventory, {
                    bagID = bag,
                    slotID = slot,
                    link = link,
                    count = (count and count > 1) and count or "",
                    texture = texture
                })
            end
        end
    end
end

local scanner = CreateFrame("Frame")
scanner:RegisterEvent("BAG_UPDATE")
scanner:SetScript("OnEvent", function()
    if NovaFrame and NovaFrame:IsShown() then
        NovaDisplayItems()
    end
end)
