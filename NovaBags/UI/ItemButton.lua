--=============================================================================
-- NovaBags
-- File: UI/ItemButton.lua
--
-- Creates item buttons
--=============================================================================

NovaItemButtons = {}


function NovaCreateItemButton(parent, index)

    local button = CreateFrame(
        "Button",
        nil,
        parent
    )


    button:SetSize(40,40)


    button.icon = button:CreateTexture(nil,"BACKGROUND")

    button.icon:SetAllPoints()

    
    button.count = button:CreateFontString(
        nil,
        "OVERLAY"
    )

    button.count:SetPoint(
        "BOTTOMRIGHT",
        -2,
        2
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

        end
    )


    button:SetScript(
        "OnLeave",
        function()

            GameTooltip:Hide()

        end
    )


    NovaItemButtons[index] = button


    return button

end
