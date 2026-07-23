--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================

NovaTheme = {

    HeaderColor = {
        r = 1,
        g = 1,
        b = 1,
        a = 1
    }

}



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

    insets = {
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



-- Theme ready color

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
-- Item Holder
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
-55
)



local GAP = 34
local PER_ROW = 10



---------------------------------------------------
-- Display
---------------------------------------------------

function NovaDisplayItems()

for _,item in ipairs(NovaInventory) do

NovaScanBags()



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



if item.count > 1 then


button.count:SetText(
item.count
)


else


button.count:SetText(
"")


end



button:Show()



index=index+1



end



end



---------------------------------------------------
-- Open
---------------------------------------------------

function NovaToggle()


if NovaFrame:IsShown() then


NovaFrame:Hide()


else


NovaFrame:Show()

NovaDisplayItems()


end


end



ToggleBackpack =
NovaToggle


OpenBackpack =
NovaToggle


OpenAllBags =
NovaToggle


ToggleAllBags =
NovaToggle



---------------------------------------------------
-- Blizzard Buttons
---------------------------------------------------

local hook =
CreateFrame("Frame")

hook:RegisterEvent(
"PLAYER_LOGIN"
)


hook:SetScript(
"OnEvent",
function()


for i=0,4 do


local b =
_G["CharacterBag"..i.."Slot"]


if b then


b:SetScript(
"OnClick",
function()

NovaToggle()

end)


end


end


end)



---------------------------------------------------
-- Updates
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

NovaDisplayItems()

end


end)
