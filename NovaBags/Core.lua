--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================

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


-- right side bag position
NovaFrame:SetPoint(
    "RIGHT",
    UIParent,
    "RIGHT",
    -120,
    0
)


NovaFrame:SetBackdrop({

    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",

    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",

    edgeSize = 16,

    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
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
5
)


title:SetText(
"NovaBags"
)



------------------------------------------------
-- Close button
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

NovaThemes = {

Default = {
0.1,0.1,0.1,
0.7,0.7,0.7
},

ObsidianGold = {
0.02,0.02,0.02,
0.85,0.65,0.15
},

Shadow = {
0.04,0.03,0.06,
0.4,0.2,0.8
},

Arcane = {
0.08,0.02,0.15,
0.5,0.3,1
},

Nature = {
0.02,0.12,0.04,
0.3,0.8,0.3
}

}



function NovaApplyTheme(name)


local t =
NovaThemes[name]


if not t then return end



NovaFrame:SetBackdropColor(
t[1],
t[2],
t[3],
0.95
)


NovaFrame:SetBackdropBorderColor(
t[4],
t[5],
t[6],
1
)


NovaHeader:SetVertexColor(
t[4],
t[5],
t[6],
1
)


end



------------------------------------------------
-- Theme buttons
------------------------------------------------

local themeList = {
"Default",
"ObsidianGold",
"Shadow",
"Arcane",
"Nature"
}



for i,name in ipairs(themeList) do


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
-20-(i*25),
-15
)



b:SetNormalTexture(
"Interface\\Icons\\INV_Misc_QuestionMark"
)



b:SetScript(
"OnClick",
function()

NovaApplyTheme(name)

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


local button =
NovaCreateItemButton(
NovaFrame,
i
)


button:SetPoint(
"TOPLEFT",
20 + ((i-1)%COLUMNS)*SPACING,
-55 - math.floor((i-1)/COLUMNS)*SPACING
)


button:Hide()


NovaSlots[i]=button


end



------------------------------------------------
-- Display Items
------------------------------------------------

function NovaDisplayItems()


if not NovaScanBags then

print("NovaBags: Missing scanner")
return

end



NovaScanBags()


print("Nova found:",#NovaInventory)



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

end)



------------------------------------------------
-- Slash command
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
