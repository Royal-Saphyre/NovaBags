--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--
-- Real WoW container-style item buttons
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



    -- store reference
    NovaItemButtons[index] = button



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
    -- Click handling
    ------------------------------------------------

    button:RegisterForClicks(
        "LeftButtonUp",
        "RightButtonUp"
    )


    button:SetScript(
        "OnClick",
        function(self, buttonName)


            if not self.bagID then
                return
            end



            if buttonName == "LeftButton" then


                PickupContainerItem(
                    self.bagID,
                    self.slotID
                )



            elseif buttonName == "RightButton" then


                UseContainerItem(
                    self.bagID,
                    self.slotID
                )


            end


        end
    )



    return button

end



------------------------------------------------
-- Update item button
------------------------------------------------

function NovaUpdateItemButton(button, item)


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



    if button.Count then

        button.Count:SetText(
            item.count or 1
        )

    end



    button:Show()


end
