--=============================================================================
-- NovaBags
-- File: BagHooks.lua
--=============================================================================

local function ToggleNova()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems(false)
    end
end

local hookFrame = CreateFrame("Frame")
hookFrame:RegisterEvent("PLAYER_LOGIN")
hookFrame:SetScript("OnEvent", function()
    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame" .. i]
        if frame then
            frame:HookScript("OnShow", function(self)
                self:Hide()
                ToggleNova()
            end)
        end
    end
end)

hooksecurefunc("OpenAllBags", function()
    ToggleNova()
end)

hooksecurefunc("CloseAllBags", function()
    NovaFrame:Hide()
end)
