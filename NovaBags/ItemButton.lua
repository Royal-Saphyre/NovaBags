--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--
-- Blizzard-style item buttons
--=============================================================================

NovaItemButtons = {}


local ITEM_SIZE = 30


function NovaCreateItemButton(parent, index)


    local button = CreateFrame(
        "Button",
        "NovaItemButton"..index,
        parent,
        "ContainerFrameItemButtonTemplate"
    )


    button:SetSize(
        ITEM_SIZE,
        ITEM_SIZE
    )


    button:SetID(index)



    ------------------------------------------------
    -- Count text
    ------------------------------------------------

    if not button.Count then


        button.Count =
        button:CreateFontString(
            nil,
            "OVERLAY"
        )


        button.Count:SetFont(
            "Fonts\\FRIZQT__.TTF",
            10,
            "OUTLINE"
        )


        button.Count:SetPoint(
            "BOTTOMRIGHT",
            -2,
            2
        )


    end



    ------------------------------------------------
    -- Tooltip
    ------------------------------------------------

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



    ------------------------------------------------
    -- Save reference
    ------------------------------------------------

    NovaItemButtons[index] = button


    return button


end



------------------------------------------------
-- Update item data
------------------------------------------------

function NovaUpdateItemButton(button, item)


    button.bagID =
    item.bagID


    button.slotID =
    item.slotID



    button.link =
    item.link



    -- Required by Blizzard container buttons

    button:SetID(
        item.slotID
    )



    if button.icon then


        button.icon:SetTexture(
            item.texture or
            "Interface\\Icons\\INV_Misc_QuestionMark"
        )


    end



    if button.Count then


        button.Count:SetText(
            item.count or 1
        )


    end



    button:Show()


end
