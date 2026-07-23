--=============================================================================
-- NovaBags
-- File: ItemButton.lua
-- Clean custom item button implementation
--=============================================================================

NovaItemButtons = {}

function NovaCreateItemButton(parent, index)
    local button = CreateFrame("Button", "NovaItemButton" .. index, parent)
    button:SetSize(32, 32)
    button:SetFrameLevel(parent:GetFrameLevel() + 5)

    -- Icon texture
    local icon = button:CreateTexture(nil, "BORDER")
    icon:SetAllPoints(button)
    button.icon = icon

    -- Stack Count text
    local count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    count:SetJustifyH("RIGHT")
    button.count = count

    -- Mouseover highlight texture
    local hl = button:CreateTexture(nil, "HIGHLIGHT")
    hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    hl:SetAllPoints(button)
    button:SetHighlightTexture(hl)

    -- Tooltip handlers
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

    -- Click & Drag interaction
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, btn)
        if not self.bagID or not self.slotID then return end

        if btn == "RightButton" then
            UseContainerItem(self.bagID, self.slotID)
        else
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
