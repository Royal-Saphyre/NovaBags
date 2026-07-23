--=============================================================================
-- NovaBags
-- File: BagHooks.lua
-- Safely suppresses Blizzard default containers and handles toggling
--=============================================================================

local function ToggleNova()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end
end

-- Suppress default Blizzard container frames completely without triggering taint
local hookFrame = CreateFrame("Frame")
hookFrame:RegisterEvent("PLAYER_LOGIN")
hookFrame:SetScript("OnEvent", function()
    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame" .. i]
        if frame then
            frame:HookScript("OnShow", function(self)
                self:Hide()
                if not NovaFrame:IsShown() then
                    NovaFrame:Show()
                    NovaDisplayItems()
                end
            end)
        end
    end
end)

-- Hook keyboard bag triggers
hooksecurefunc("OpenAllBags", function()
    NovaFrame:Show()
    NovaDisplayItems()
end)

hooksecurefunc("CloseAllBags", function()
    NovaFrame:Hide()
end)
