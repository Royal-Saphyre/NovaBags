--=============================================================================
-- NovaBags
-- File: BagHooks.lua
-- Safely hooks Blizzard bag toggles
--=============================================================================

local function ToggleNova()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end
end

hooksecurefunc("ToggleBackpack", function()
    ToggleNova()
end)

hooksecurefunc("ToggleBag", function()
    ToggleNova()
end)

hooksecurefunc("OpenAllBags", function()
    NovaFrame:Show()
    NovaDisplayItems()
end)

hooksecurefunc("CloseAllBags", function()
    NovaFrame:Hide()
end)
