--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Main NovaBags window
--=============================================================================


local ICON_SIZE = 32
local SPACING = 36
local COLUMNS = 10
local TOTAL_SLOTS = 100


------------------------------------------------
-- Frame
------------------------------------------------

NovaFrame = CreateFrame(
    "Frame",
    "NovaMainFrame",
    UIParent
)


NovaFrame:SetSize(
    410,
    430
)


NovaFrame:SetPoint(
    "RIGHT",
    UIParent,
    "RIGHT",
    -120,
    0
)



NovaFrame:SetBackdrop({

    bgFile =
    "Interface\\Tooltips\\UI-Tooltip-Background",

    edgeFile =
    "Interface\\Tooltips\\UI-Tooltip-Border",

    edgeSize = 16,

    insets = {
        left=6,
        right=6,
        top=6,
        bottom=6
    }

})



NovaFrame:SetBackdropColor(
    0.02,
    0.02,
    0.02,
    0.95
)


NovaFrame:SetBackdropBorderColor(
    0.85,
    0.65,
    0.15,
    1
)



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



------------------------------------------------
-- Header
------------------------------------------------


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
0,
12
)



local title =
NovaFrame:CreateFontString(
nil,
"OVERLAY",
"GameFontNormalLarge"
)



title:SetPoint(
"CENTER",
header,
"CENTER",
0,
2
)


title:SetText(
"NovaBags"
)



------------------------------------------------
-- Theme buttons
------------------------------------------------


local themes = {

Default={
0.1,0.1,0.1,1,
0.7,0.7,0.7,1
},

ObsidianGold={
0.02,0.02,0.02,1,
0.85,0.65,0.15,1
},

Shadow={
0.03,0.03,0.05,1,
0.3,0.3,0.35,1
},

Arcane={
0.08,0.02,0.15,1,
0.6,0.2,1,1
},

Nature={
0.02,0.12,0.04,1,
0.3,0.8,0.3,1
}

}



local themeOrder = {

"Default",
"ObsidianGold",
"Shadow",
"Arcane",
"Nature"

}



local function ApplyTheme(name)


local t =
themes[name]


NovaFrame:SetBackdropColor(
t[1],
t[2],
t[3],
t[4]
)


NovaFrame:SetBackdropBorderColor(
t[5],
t[6],
t[7],
t[8]
)


end




for i,name in ipairs(themeOrder) do


local b =
CreateFrame(
"Button",
nil,
NovaFrame
)


b:SetSize(
22,
22
)


b:SetPoint(
"TOPRIGHT",
-20-(i*24),
-12
)



b:SetNormalTexture(
"Interface\\Icons\\INV_Misc_QuestionMark"
)



b:SetScript(
"OnClick",
function()

ApplyTheme(name)

end
)



b:SetScript(
"OnEnter",
function(self)

GameTooltip:SetOwner(
self,
"ANCHOR_RIGHT"
)

GameTooltip:SetText(
name
)

GameTooltip:Show()

end
)



b:SetScript(
"OnLeave",
function()

GameTooltip:Hide()

end
)



end



ApplyTheme(
"ObsidianGold"
)



------------------------------------------------
-- Slots
------------------------------------------------


NovaSlots = {}



for i=1,TOTAL_SLOTS do


local slot =
NovaCreateItemButton(
NovaFrame,
i
)


slot:SetPoint(
"TOPLEFT",
20 + ((i-1)%COLUMNS)*SPACING,
-55 - math.floor((i-1)/COLUMNS)*SPACING
)



NovaSlots[i]=slot


end




------------------------------------------------
-- Display items
------------------------------------------------


function NovaDisplayItems()


NovaScanBags()



for i=1,TOTAL_SLOTS do


local button =
NovaSlots[i]


local item =
NovaInventory[i]


if item then


NovaUpdateItemButton(
button,
item
)


else


button:Hide()


end



end



end




------------------------------------------------
-- Scan button
------------------------------------------------


local scan =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelButtonTemplate"
)


scan:SetSize(
80,
22
)


scan:SetPoint(
"BOTTOM",
0,
10
)


scan:SetText(
"Scan"
)



scan:SetScript(
"OnClick",
function()


NovaDisplayItems()


end
)




------------------------------------------------
-- Slash
------------------------------------------------


SLASH_NOVA1="/nova"


SlashCmdList["NOVA"]=function()


if NovaFrame:IsShown() then


NovaFrame:Hide()


else


NovaFrame:Show()

NovaDisplayItems()


end


end




------------------------------------------------
-- Safe bag hooks
------------------------------------------------


function ToggleBackpack()


if NovaFrame:IsShown() then

NovaFrame:Hide()

else

NovaFrame:Show()

NovaDisplayItems()

end

end



function OpenAllBags()


ToggleBackpack()

end
