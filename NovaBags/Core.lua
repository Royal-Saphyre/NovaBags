--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================


local ICON_SIZE = 32
local SPACING = 36
local COLUMNS = 10
local TOTAL_SLOTS = 100


------------------------------------------------
-- Main Frame
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
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    }

})


NovaFrame:SetMovable(true)
NovaFrame:EnableMouse(true)
NovaFrame:RegisterForDrag("LeftButton")


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


NovaHeader = header



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
-2
)


title:SetText(
"NovaBags"
)


title:SetJustifyH(
"CENTER"
)


title:SetJustifyV(
"MIDDLE"
)



------------------------------------------------
-- Close
------------------------------------------------

local close =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelCloseButton"
)


close:SetPoint(
"TOPRIGHT",
-5,
-5
)


close:SetScript(
"OnClick",
function()

NovaFrame:Hide()

end)



------------------------------------------------
-- Themes
------------------------------------------------

local themes = {


Default={
0.1,0.1,0.1,1,
0.7,0.7,0.7
},


ObsidianGold={
0.02,0.02,0.02,1,
0.85,0.65,0.15
},


Shadow={
0.04,0.03,0.06,1,
0.4,0.2,0.8
},


Arcane={
0.08,0.02,0.15,1,
0.5,0.3,1
},


Nature={
0.02,0.12,0.04,1,
0.3,0.8,0.3
}


}



local themeNames =
{
"Default",
"ObsidianGold",
"Shadow",
"Arcane",
"Nature"
}



function NovaApplyTheme(name)


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
1
)



if NovaHeader then

NovaHeader:SetVertexColor(
t[5],
t[6],
t[7],
1
)

end


end



for i,name in ipairs(themeNames) do


local button =
CreateFrame(
"Button",
nil,
NovaFrame
)


button:SetSize(
22,
22
)


button:SetPoint(
"TOPRIGHT",
-20 - (i*25),
-15
)



button:SetNormalTexture(
"Interface\\Icons\\INV_Misc_QuestionMark"
)



button:SetScript(
"OnClick",
function()

NovaApplyTheme(name)

end)



button:SetScript(
"OnEnter",
function(self)

GameTooltip:SetOwner(
self,
"ANCHOR_RIGHT"
)

GameTooltip:SetText(name)

GameTooltip:Show()

end)


button:SetScript(
"OnLeave",
function()

GameTooltip:Hide()

end)



end



NovaApplyTheme(
"ObsidianGold"
)



------------------------------------------------
-- Item Slots
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



slot:Hide()



NovaSlots[i]=slot


end



------------------------------------------------
-- Display Items
------------------------------------------------

function NovaDisplayItems()


if not NovaScanBags then

print("NovaBags: Scanner missing")
return

end



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


button:SetID(
item.slotID
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

end)



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
