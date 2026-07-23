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



---------------------------------------------------
-- Header
---------------------------------------------------

local title =
NovaFrame:CreateFontString(
nil,
"OVERLAY",
"GameFontNormal"
)


title:SetPoint(
"TOP",
0,
-20
)


title:SetText(
"NovaBags"
)



---------------------------------------------------
-- Close
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
-5,
-5
)


close:SetScript(
"OnClick",
function()

NovaFrame:Hide()

end)



---------------------------------------------------
-- Container
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
-50
)



local SIZE = 30
local GAP = 34
local PER_ROW = 10



---------------------------------------------------
-- Draw bags
---------------------------------------------------

function NovaDisplayItems()


local index = 1



for bag = 0,4 do



local slots =
GetContainerNumSlots(bag)



for slot = 1,slots do



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
bag


button.slotID =
slot



local texture,count =
GetContainerItemInfo(
bag,
slot
)



button.link =
GetContainerItemLink(
bag,
slot
)



if texture then


button.icon:SetTexture(
texture
)


else


button.icon:SetTexture(
"Interface\\Buttons\\UI-EmptySlot"
)


end



if count and count > 1 then


button.count:SetText(
count
)


else


button.count:SetText(
""
)


end



button:Show()



index=index+1



end


end



end



---------------------------------------------------
-- Open Nova
---------------------------------------------------

function NovaToggle()


if NovaFrame:IsShown() then


NovaFrame:Hide()


else


NovaFrame:Show()

NovaDisplayItems()


end


end



---------------------------------------------------
-- Replace bag key functions
---------------------------------------------------

ToggleBackpack =
NovaToggle


OpenBackpack =
NovaToggle


OpenAllBags =
NovaToggle


ToggleAllBags =
NovaToggle



---------------------------------------------------
-- Hook Blizzard bag buttons
---------------------------------------------------

local hookFrame =
CreateFrame("Frame")


hookFrame:RegisterEvent(
"PLAYER_LOGIN"
)


hookFrame:SetScript(
"OnEvent",
function()



if MainMenuBarBackpackButton then


MainMenuBarBackpackButton:SetScript(
"OnClick",
function()

NovaToggle()

end)


end



for i=0,4 do



local button =
_G["CharacterBag"..i.."Slot"]



if button then



button:SetScript(
"OnClick",
function()

NovaToggle()

end)



end



end



end)



---------------------------------------------------
-- Refresh
---------------------------------------------------

local updater =
CreateFrame("Frame")


updater:RegisterEvent(
"BAG_UPDATE"
)


updater:SetScript(
"OnEvent",
function()


if NovaFrame:IsShown() then

NovaDisplayItems()

end


end)



---------------------------------------------------
-- Slash
---------------------------------------------------

SLASH_NOVA1="/nova"


SlashCmdList["NOVA"]=function()

NovaToggle()

end
