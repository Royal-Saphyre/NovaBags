--=============================================================================
-- NovaBags
-- File: BagHooks.lua
--
-- Safely replaces Blizzard bag opening functions and keybindings
--=============================================================================

local function ToggleNova()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end
end

------------------------------------------------
-- Global toggle function for bindings
------------------------------------------------
_G["NovaToggleBags"] = ToggleNova

------------------------------------------------
-- Override Blizzard bag toggles
------------------------------------------------
function ToggleBackpack() ToggleNova() end
function OpenBackpack() NovaFrame:Show() NovaDisplayItems() end
function CloseBackpack() NovaFrame:Hide() end
function ToggleAllBags() ToggleNova() end
function OpenAllBags() NovaFrame:Show() NovaDisplayItems() end
function CloseAllBags() NovaFrame:Hide() end

-- Intercept microbar bag icon clicks (Bag 0 to 4)
hooksecurefunc("ToggleBag", function(bagID)
    ToggleNova()
end)

hooksecurefunc("OpenBag", function(bagID)
    NovaFrame:Show()
    NovaDisplayItems()
end)

------------------------------------------------
-- Force override standard B and Shift+B keys
------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
    -- Hide default Blizzard container frames if they pop up
    for i = 1, NUM_CONTAINER_FRAMES do
        local container = _G["ContainerFrame" .. i]
        if container then
            container:UnregisterAllEvents()
            container:Hide()
        end
    end

    -- Override standard WoW keybindings to point to NovaBags
    SetBinding("B", "NOVA")
    SetBinding("SHIFT-B", "NOVA")
end)
