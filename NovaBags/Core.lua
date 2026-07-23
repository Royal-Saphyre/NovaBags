--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================

NovaFrame = CreateFrame(
    "Frame",
    "NovaMainFrame",
    UIParent
)


NovaFrame:SetSize(
    360,
    420
)


NovaFrame:SetPoint(
    "RIGHT",
    UIParent,
    "RIGHT",
    -40,
    0
)


NovaFrame:SetBackdrop({

    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",

    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",

    edgeSize = 16,

    insets =
    {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    }

})



NovaFrame:SetMovable(true)
NovaFrame:EnableMouse(true)

NovaFrame:RegisterForDrag(
    "LeftButton"
)


NovaFrame:SetScript(
    "OnDragStart",
    function(self)

        self:StartMoving()

    end
)


NovaFrame:SetScript(
    "OnDragStop",
    function(self)

        self:StopMovingOrSizing()

    end
)



NovaFrame:Hide()



---------------------------------------------------
-- Header
---------------------------------------------------

local header = NovaFrame:CreateTexture(
    nil,
    "ARTWORK"
)


header:SetTexture(
    "Interface\\DialogFrame\\UI-DialogBox-Header"
)


header:SetSize(
    300,
    64
)


header:SetPoint(
    "TOP",
    NovaFrame,
    "TOP",
    0,
    12
)



local title = NovaFrame:CreateFontString(
    nil,
    "OVERLAY",
    "GameFontNormal"
)


title:SetPoint(
    "TOP",
    header,
    "TOP",
    0,
    -14
)


title:SetText(
    "NovaBags"
)



---------------------------------------------------
-- Close button
---------------------------------------------------

local close = CreateFrame(
    "Button",
    nil,
    NovaFrame,
    "UIPanelCloseButton"
)


close:SetPoint(
    "TOPRIGHT",
    -2,
    -6
)


close:SetScript(
    "OnClick",
    function()

        NovaFrame:Hide()

    end
)



---------------------------------------------------
-- Bag Grid
---------------------------------------------------

local ICON_SIZE = 30
local SPACING = 34
local PER_ROW = 10


local container = CreateFrame(
    "Frame",
    nil,
    NovaFrame
)


container:SetPoint(
    "TOPLEFT",
    20,
    -45
)



---------------------------------------------------
-- Display Bags
---------------------------------------------------

function NovaDisplayItems()


    NovaScanBags()



    for i,slot in ipairs(NovaInventory) do



        local button =
        NovaItemButtons[i]



        if not button then

            button =
            NovaCreateItemButton(
                container,
                i
            )

        end



        button:SetPoint(
            "TOPLEFT",
            ((i-1)%PER_ROW)*SPACING,
            -math.floor((i-1)/PER_ROW)*SPACING
        )



        button.bagID =
        slot.bagID


        button.slotID =
        slot.slotID



        button.link =
        slot.link



        local _,_,_,_,_,_,_,_,_,icon =
        GetContainerItemInfo(
            slot.bagID,
            slot.slotID
        )



        button.icon:SetTexture(
            icon or
            "Interface\\Icons\\INV_Misc_QuestionMark"
        )



        if slot.count > 1 then

            button.count:SetText(
                slot.count
            )

        else

            button.count:SetText("")

        end



        button:Show()

    end

end





---------------------------------------------------
-- Replace Blizzard bags
---------------------------------------------------

function ToggleBackpack()


    if NovaFrame:IsShown() then

        NovaFrame:Hide()

    else

        NovaFrame:Show()

        NovaDisplayItems()

    end

end




---------------------------------------------------
-- Hide Blizzard bag buttons
---------------------------------------------------

local hide = CreateFrame("Frame")


hide:RegisterEvent(
"PLAYER_LOGIN"
)


hide:SetScript(
"OnEvent",
function()


    if MainMenuBarBackpackButton then

        MainMenuBarBackpackButton:Hide()

    end



    for i=0,NUM_BAG_SLOTS do


        local b =
        _G["CharacterBag"..i.."Slot"]


        if b then

            b:Hide()

        end


    end


end)



---------------------------------------------------
-- Slash command
---------------------------------------------------

SLASH_NOVA1="/nova"


SlashCmdList["NOVA"] =
function()


    ToggleBackpack()


end
