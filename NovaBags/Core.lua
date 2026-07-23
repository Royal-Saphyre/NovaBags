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
400,
420
)


NovaFrame:SetPoint(
"RIGHT",
UIParent,
"RIGHT",
-100,
0
)



NovaFrame:SetBackdrop({

bgFile =
"Interface\\DialogFrame\\UI-DialogBox-Background",

edgeFile =
"Interface\\Tooltips\\UI-Tooltip-Border",

edgeSize = 16,

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



------------------------------------------------
-- HEADER
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
"GameFontNormal"
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
-- SCROLL AREA
------------------------------------------------


local ICON_SIZE = 30
local SPACING = 34
local ROWS = 10



local scroll =
CreateFrame(
"ScrollFrame",
"NovaScrollFrame",
NovaFrame,
"UIPanelScrollFrameTemplate"
)



scroll:SetPoint(
"TOPLEFT",
15,
-45
)


scroll:SetPoint(
"BOTTOMRIGHT",
-30,
15
)



local child =
CreateFrame(
"Frame",
"NovaScrollChild",
scroll
)



scroll:SetScrollChild(
child
)



child:SetSize(
350,
350
)



------------------------------------------------
-- SCAN BUTTON
------------------------------------------------


local scan =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelButtonTemplate"
)



scan:SetSize(
90,
25
)



scan:SetPoint(
"BOTTOMLEFT",
15,
10
)



scan:SetText(
"Scan"
)



scan:SetScript(
"OnClick",
function()


NovaScanBags()

NovaDisplayItems()


end
)



------------------------------------------------
-- DISPLAY ITEMS
------------------------------------------------


function NovaDisplayItems()



for i,item in ipairs(NovaInventory) do



local button =
NovaItemButtons[i]



if not button then


button =
NovaCreateItemButton(
child,
i
)


end



button:SetPoint(
"TOPLEFT",
((i-1)%ROWS)*SPACING,
-math.floor((i-1)/ROWS)*SPACING
)



button.icon:SetTexture(
item.texture or
"Interface\\Icons\\INV_Misc_QuestionMark"
)



button.count:SetText(
item.count
)


button.link =
item.link


button.bagID =
item.bagID


button.slotID =
item.slotID



button:Show()



end



end



------------------------------------------------
-- SLASH COMMAND
------------------------------------------------


SLASH_NOVA1="/nova"


SlashCmdList["NOVA"]=function()


if NovaFrame:IsShown() then

NovaFrame:Hide()

else

NovaFrame:Show()

NovaScanBags()

NovaDisplayItems()

end


end
------------------------------------------------
-- Blizzard bag opening hooks
------------------------------------------------


local oldToggleBackpack = ToggleBackpack


function ToggleBackpack()


    if NovaFrame:IsShown() then

        NovaFrame:Hide()

    else

        NovaFrame:Show()

        NovaScanBags()

        NovaDisplayItems()

    end


end



local oldOpenAllBags = OpenAllBags


function OpenAllBags()


    if NovaFrame:IsShown() then

        NovaFrame:Hide()

    else

        NovaFrame:Show()

        NovaScanBags()

        NovaDisplayItems()

    end


end
