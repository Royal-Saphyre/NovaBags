--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Main NovaBags window
--=============================================================================


---------------------------------------------------
-- Theme Settings
---------------------------------------------------

NovaTheme = {

    HeaderColor = {
        r = 1,
        g = 1,
        b = 1,
        a = 1
    }

}



---------------------------------------------------
-- Main Frame
---------------------------------------------------

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

end)



NovaFrame:SetScript(
"OnDragStop",
function(self)

    self:StopMovingOrSizing()

end)



NovaFrame:Hide()



---------------------------------------------------
-- Metallic Header
---------------------------------------------------

local header =
NovaFrame:CreateTexture(
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



header:SetVertexColor(
NovaTheme.HeaderColor.r,
NovaTheme.HeaderColor.g,
NovaTheme.HeaderColor.b,
NovaTheme.HeaderColor.a
)



local title =
NovaFrame:CreateFontString(
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
-- Close Button
---------------------------------------------------

local close =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelCloseButton"
)


close:SetPoint(
"TOPRIGHT",
-3,
-6
)



close:SetScript(
"OnClick",
function()

    NovaFrame:Hide()

end)



---------------------------------------------------
-- Scan Button
---------------------------------------------------

local scanButton =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelButtonTemplate"
)


scanButton:SetSize(
90,
22
)


scanButton:SetPoint(
"TOPLEFT",
15,
-35
)


scanButton:SetText(
"Scan Bags"
)



scanButton:SetScript(
"OnClick",
function()

    NovaScanBags()

    NovaDisplayItems()

end)



---------------------------------------------------
-- Item Container
---------------------------------------------------

local holder =
CreateFrame(
"Frame",
nil,
NovaFrame
)


holder:SetPoint(
"TOPLEFT",
20,
-70
)



local GAP = 34

local PER_ROW = 10



---------------------------------------------------
-- Display Items
---------------------------------------------------

function NovaDisplayItems()


    local index = 1



    for _,item in ipairs(NovaInventory) do



        local button =
        NovaItemButtons[index]



        if not button then


            button =
            NovaCreateItemButton(
                holder,
                index
            )


        end



        button:SetPoint(
            "TOPLEFT",
            ((index-1)%PER_ROW)*GAP,
            -math.floor((index-1)/PER_ROW)*GAP
        )



        button.bagID =
        item.bagID



        button.slotID =
        item.slotID



        button.link =
        item.link



        button.icon:SetTexture(
            item.texture
            or
            "Interface\\Icons\\INV_Misc_QuestionMark"
        )



        if item.count and item.count > 1 then


            button.count:SetText(
                item.count
            )


        else


            button.count:SetText(
                ""
            )


        end



        button:Show()



        index = index + 1


    end



    for i=index,#NovaItemButtons do

        NovaItemButtons[i]:Hide()

    end


end



---------------------------------------------------
-- Toggle Nova
---------------------------------------------------

function NovaToggle()


    if NovaFrame:IsShown() then


        NovaFrame:Hide()


    else


        NovaFrame:Show()

        NovaScanBags()

        NovaDisplayItems()


    end


end



---------------------------------------------------
-- Replace Blizzard Bag Opening
---------------------------------------------------

function ToggleBackpack()

    NovaToggle()

end



function OpenBackpack()

    NovaToggle()

end



function OpenAllBags()

    NovaToggle()

end



function ToggleAllBags()

    NovaToggle()

end



---------------------------------------------------
-- Refresh when bags change
---------------------------------------------------

local update =
CreateFrame("Frame")


update:RegisterEvent(
"BAG_UPDATE"
)



update:SetScript(
"OnEvent",
function()


    if NovaFrame:IsShown() then

        NovaScanBags()

        NovaDisplayItems()

    end


end)



---------------------------------------------------
-- Slash Command
---------------------------------------------------

SLASH_NOVA1 = "/nova"



SlashCmdList["NOVA"] =
function()

    NovaToggle()

end
