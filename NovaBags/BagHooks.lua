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

-- Suppress default containers and cleanly toggle NovaBags on/off
local hookFrame = CreateFrame("Frame")
hookFrame:RegisterEvent("PLAYER_LOGIN")
hookFrame:SetScript("OnEvent", function()
    for i = 1, NUM_CONTAINER_FRAMES do
        local frame = _G["ContainerFrame" .. i]
        if frame then
            frame:HookScript("OnShow", function(self)
                self:Hide()
                -- Toggles closed if open, otherwise opens and refreshes
                ToggleNova()
            end)
        end
    end
end)

-- Hook keyboard bag triggers to respect the toggle state
hooksecurefunc("OpenAllBags", function()
    ToggleNova()
end)

hooksecurefunc("CloseAllBags", function()
    NovaFrame:Hide()
end)
