--=============================================================================
-- NovaBags
-- File: BagHooks.lua
--=============================================================================

local function ToggleNova()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end
end

-- Suppress default containers and trigger NovaBags
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

hooksecurefunc("OpenAllBags", function()
    NovaFrame:Show()
    NovaDisplayItems()
end)

hooksecurefunc("CloseAllBags", function()
    NovaFrame:Hide()
end)
