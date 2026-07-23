--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--
-- Creates Nova item buttons
--=============================================================================

-- Storage for all item buttons
NovaItemButtons = {}

-- Create one item button
function NovaCreateItemButton(parent, index)

    local button = CreateFrame(
        "Button",
        "NovaItemButton"..index,
        parent
    )

    -- Size
    button:SetSize(40, 40)

    -- Icon
    button.icon = button:CreateTexture(
        nil,
        "BACKGROUND"
    )

    button.icon:SetAllPoints()

    -- Count text
    button.count = button:CreateFontString(
        nil,
        "OVERLAY"
    )

    button.count:SetFont(
        "Fonts\\FRIZQT__.TTF",
        12,
        "OUTLINE"
    )

    button.count:SetPoint(
        "BOTTOMRIGHT",
        -2,
        2
    )

    -- Highlight effect
    button:SetHighlightTexture(
        "Interface\\Buttons\\ButtonHilight-Square"
    )

    -- Tooltip
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

        end
    )

    button:SetScript(
        "OnLeave",
        function()

            GameTooltip:Hide()

        end
    )

    -- Save reference
    NovaItemButtons[index] = button

    return button

end
