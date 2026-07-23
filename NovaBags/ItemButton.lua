--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--=============================================================================

NovaItemButtons = {}

function NovaCreateItemButton(parent, index)
    local name = "NovaItemButton" .. index
    -- Inherit the standard WotLK item button template
    local button = CreateFrame("Button", name, parent, "ContainerFrameItemButtonTemplate")

    button:SetSize(32, 32)
    button:SetFrameLevel(parent:GetFrameLevel() + 2)

    -- Reference icon and count directly from the WoW template
    button.icon = _G[name .. "IconTexture"]
    button.count = _G[name .. "Count"]

    -- Hook Tooltip handling for 3.3.5a
    button:SetScript("OnEnter", function(self)
        if self.bagID and self.slotID then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetBagItem(self.bagID, self.slotID)
            GameTooltip:Show()
        end
    end)

    button:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Item interaction (Right-Click to use/equip, Left-Click to pick up)
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, buttonPressed)
        if not self.bagID or not self.slotID then return end

        if buttonPressed == "RightButton" then
            UseContainerItem(self.bagID, self.slotID)
        elseif buttonPressed == "LeftButton" then
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        if self.bagID and self.slotID then
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    button:SetScript("OnReceiveDrag", function(self)
        if self.bagID and self.slotID then
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    NovaItemButtons[index] = button
    return button
end
