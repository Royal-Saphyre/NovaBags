--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--=============================================================================

NovaItemButtons = {}


function NovaCreateItemButton(parent,index)


local button =
CreateFrame(
"Button",
"NovaItemButton"..index,
parent
)


button:SetSize(
32,
32
)



button.icon =
button:CreateTexture(
nil,
"BACKGROUND"
)


button.icon:SetAllPoints()



button.count =
button:CreateFontString(
nil,
"OVERLAY"
)


button.count:SetFont(
"Fonts\\FRIZQT__.TTF",
10,
"OUTLINE"
)


button.count:SetPoint(
"BOTTOMRIGHT",
-2,
2
)



button:SetHighlightTexture(
"Interface\\Buttons\\ButtonHilight-Square"
)



button:SetScript(
"OnEnter",
function(self)

if self.link then

GameTooltip:SetOwner(
self,
"ANCHOR_RIGHT"
)

GameTooltip:SetHyperlink(
self.link
)

GameTooltip:Show()

end

end)



button:SetScript(
"OnLeave",
function()

GameTooltip:Hide()

end)



button:RegisterForClicks(
"LeftButtonUp",
"RightButtonUp"
)



button:SetScript(
"OnClick",
function(self,click)


if not self.bagID then return end



if click=="LeftButton" then


PickupContainerItem(
self.bagID,
self.slotID
)



elseif click=="RightButton" then


UseContainerItem(
self.bagID,
self.slotID
)


end


end)



NovaItemButtons[index]=button


return button


end





function NovaUpdateItemButton(button,item)


button.bagID =
item.bagID


button.slotID =
item.slotID


button.link =
item.link



button.icon:SetTexture(
item.texture or
"Interface\\Icons\\INV_Misc_QuestionMark"
)



button.count:SetText(
item.count or 1
)



button:Show()


end
