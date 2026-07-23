--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--=============================================================================

NovaItemButtons = {}

function NovaCreateItemButton(parent, index)
    local button = CreateFrame("Button", "NovaItemButton" .. index, parent)
    button:SetSize(32, 32)
    button:SetFrameLevel(parent:GetFrameLevel() + 2)

    -- Empty slot background
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(button)
    bg:SetTexture("Interface\\PaperDoll\\UI-Backpack-EmptySlot")
    button.bg = bg

    -- Icon Texture
    local icon = button:CreateTexture(nil, "BORDER")
    icon:SetAllPoints(button)
    button.icon = icon

    -- Stack Count
    local count = button:CreateFontString(nil, "OVERLAY", "NumberFontNormal")
    count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
    count:SetJustifyH("RIGHT")
    button.count = count

    -- Mouseover Highlight
    local hl = button:CreateTexture(nil, "HIGHLIGHT")
    hl:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    hl:SetAllPoints(button)
    button:SetHighlightTexture(hl)

    -- Tooltip Display
    button:SetScript("OnEnter", function(self)
        if self.bagID and self.slotID then
            local link = GetContainerItemLink(self.bagID, self.slotID)
            if link then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetBagItem(self.bagID, self.slotID)
                GameTooltip:Show()
            end
        end
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    -- Click & Drag Actions
    button:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    button:SetScript("OnClick", function(self, btn)
        if self.bagID == nil or self.slotID == nil then return end

        if btn == "RightButton" then
            UseContainerItem(self.bagID, self.slotID)
        else
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    button:RegisterForDrag("LeftButton")
    button:SetScript("OnDragStart", function(self)
        if self.bagID ~= nil and self.slotID ~= nil then
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    button:SetScript("OnReceiveDrag", function(self)
        if self.bagID ~= nil and self.slotID ~= nil then
            PickupContainerItem(self.bagID, self.slotID)
        end
    end)

    NovaItemButtons[index] = button
    return button
end
