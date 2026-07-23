NovaItemButtons = {}


function NovaCreateItemButton(parent,index)


local button =
CreateFrame(
"Button",
"NovaItemButton"..index,
parent
)


button:SetSize(
30,
30
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
-1,
1
)



button:SetHighlightTexture(
"Interface\\Buttons\\ButtonHilight-Square"
)



button:RegisterForClicks(
"LeftButtonUp",
"RightButtonUp"
)



button:SetScript(
"OnClick",
function(self,button)


if not self.bagID then return end



if button=="LeftButton" then


PickupContainerItem(
self.bagID,
self.slotID
)



elseif button=="RightButton" then


UseContainerItem(
self.bagID,
self.slotID
)


end


end)



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



NovaItemButtons[index]=button


return button


end
