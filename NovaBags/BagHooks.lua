--=============================================================================
-- NovaBags
-- File: BagHooks.lua
--
-- Safely replaces Blizzard bag opening functions
--=============================================================================


local NovaOriginal = {}



------------------------------------------------
-- Save Blizzard functions
------------------------------------------------

NovaOriginal.ToggleBackpack = ToggleBackpack
NovaOriginal.OpenBackpack = OpenBackpack
NovaOriginal.CloseBackpack = CloseBackpack
NovaOriginal.OpenAllBags = OpenAllBags
NovaOriginal.CloseAllBags = CloseAllBags
NovaOriginal.ToggleAllBags = ToggleAllBags



------------------------------------------------
-- Toggle Nova
------------------------------------------------

function NovaToggleBags()

    if NovaFrame:IsShown() then

        NovaFrame:Hide()

    else

        NovaFrame:Show()

        NovaDisplayItems()

    end

end



------------------------------------------------
-- Replace Blizzard bag functions
------------------------------------------------

function ToggleBackpack()

    NovaToggleBags()

end



function OpenBackpack()

    if not NovaFrame:IsShown() then

        NovaFrame:Show()

        NovaDisplayItems()

    end

end



function CloseBackpack()

    NovaFrame:Hide()

end



function ToggleAllBags()

    NovaToggleBags()

end



function OpenAllBags()

    if not NovaFrame:IsShown() then

        NovaFrame:Show()

        NovaDisplayItems()

    end

end



function CloseAllBags()

    NovaFrame:Hide()

end



------------------------------------------------
-- Hide Blizzard container frames
-- only when they appear naturally
------------------------------------------------

local eventFrame =
CreateFrame(
"Frame"
)


eventFrame:RegisterEvent(
"BAG_OPEN"
)


eventFrame:RegisterEvent(
"PLAYER_LOGIN"
)



eventFrame:SetScript(
"OnEvent",
function()


for i=1, NUM_CONTAINER_FRAMES do


    local frame =
    _G["ContainerFrame"..i]


    if frame then

        frame:Hide()

    end


end



end)



------------------------------------------------
-- Bind B key
------------------------------------------------

hooksecurefunc(
"ToggleBackpack",
function()

    if NovaFrame then

        NovaFrame:Show()

        NovaDisplayItems()

    end

end)
