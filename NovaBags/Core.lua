--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Main NovaBags window
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
-2,
-6
)



close:SetScript(
"OnClick",
function()

NovaFrame:Hide()

end)



---------------------------------------------------
-- Item area
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
local SPACE = 34
local ROWS = 10



---------------------------------------------------
-- Display
---------------------------------------------------

function NovaDisplayItems()


NovaScanBags()



for i,item in ipairs(NovaInventory) do



local button =
NovaItemButtons[i]



if not button then


button =
NovaCreateItemButton(
holder,
i
)


end



button:SetPoint(
"TOPLEFT",
((i-1)%ROWS)*SPACE,
-math.floor((i-1)/ROWS)*SPACE
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

button.count:SetText("")

end



button:Show()



end



end



---------------------------------------------------
-- Replace Blizzard opening
---------------------------------------------------

function NovaToggle()


if NovaFrame:IsShown() then


NovaFrame:Hide()


else


NovaFrame:Show()

NovaDisplayItems()


end


end



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
-- Update when bags change
---------------------------------------------------

local event =
CreateFrame("Frame")


event:RegisterEvent(
"BAG_UPDATE"
)



event:SetScript(
"OnEvent",
function()


if NovaFrame:IsShown() then

NovaDisplayItems()

end


end)



---------------------------------------------------
-- Slash command
---------------------------------------------------

SLASH_NOVA1="/nova"


SlashCmdList["NOVA"] =
function()

NovaToggle()

end
