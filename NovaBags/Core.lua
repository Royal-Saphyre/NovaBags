--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================


NovaFrame =
CreateFrame(
"Frame",
"NovaMainFrame",
UIParent
)



NovaFrame:SetSize(
380,
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

bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",

edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",

edgeSize=16,

insets={
left=5,
right=5,
top=5,
bottom=5
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
-- Header
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
0,
12
)



local title =
NovaFrame:CreateFontString(
nil,
"OVERLAY",
"GameFontNormal"
)


title:SetPoint(
"TOP",
0,
-14
)


title:SetText(
"NovaBags"
)



---------------------------------------------------
-- Scan Button
---------------------------------------------------

local scan =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelButtonTemplate"
)



scan:SetSize(
90,
22
)


scan:SetPoint(
"TOPLEFT",
15,
-35
)


scan:SetText(
"Scan"
)



scan:SetScript(
"OnClick",
function()

NovaScanBags()

NovaDisplayItems()

end)



---------------------------------------------------
-- Slot Holder
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



local SIZE = 38

local PERROW = 9



---------------------------------------------------
-- Display
---------------------------------------------------

function NovaDisplayItems()



local index=1



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
((index-1)%PERROW)*SIZE,
-math.floor((index-1)/PERROW)*SIZE
)



button.bagID=item.bagID

button.slotID=item.slotID

button.link=item.link



button.icon:SetTexture(
item.texture
or
"Interface\\Icons\\INV_Misc_QuestionMark"
)



if item.count>1 then

button.count:SetText(
item.count
)

else

button.count:SetText(
""
)

end



button:Show()



index=index+1



end



for i=index,#NovaItemButtons do

NovaItemButtons[i]:Hide()

end



end



---------------------------------------------------
-- Open / Close
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
-- Safe Blizzard replacements
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
-- Slash
---------------------------------------------------

SLASH_NOVA1="/nova"


SlashCmdList["NOVA"]=function()

NovaToggle()

end
