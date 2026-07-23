--=============================================================================
-- NovaBags
-- File: ItemButton.lua
--
-- Creates bag slots
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



    button:RegisterForClicks(
        "LeftButtonUp",
        "RightButtonUp"
    )



    button:RegisterForDrag(
        "LeftButton"
    )



    ---------------------------------------------------
    -- Icon
    ---------------------------------------------------

    button.icon =
    button:CreateTexture(
        nil,
        "ARTWORK"
    )


    button.icon:SetAllPoints()



    ---------------------------------------------------
    -- Count
    ---------------------------------------------------

    button.count =
    button:CreateFontString(
        nil,
        "OVERLAY"
    )


    button.count:SetFont(
        "Fonts\\FRIZQT__.TTF",
        11,
        "OUTLINE"
    )


    button.count:SetPoint(
        "BOTTOMRIGHT",
        -2,
        1
    )



    ---------------------------------------------------
    -- Slot border
    ---------------------------------------------------

    button:SetNormalTexture(
        "Interface\\Buttons\\UI-Quickslot2"
    )


    button:SetHighlightTexture(
        "Interface\\Buttons\\ButtonHilight-Square"
    )



    ---------------------------------------------------
    -- Click
    ---------------------------------------------------

    button:SetScript(
    "OnClick",
    function(self,mouse)


        if not self.bagID then
            return
        end



        if mouse == "LeftButton" then


            PickupContainerItem(
                self.bagID,
                self.slotID
            )


        elseif mouse == "RightButton" then


            UseContainerItem(
                self.bagID,
                self.slotID
            )


        end


    end)



    ---------------------------------------------------
    -- Drag
    ---------------------------------------------------

    button:SetScript(
    "OnDragStart",
    function(self)


        PickupContainerItem(
            self.bagID,
            self.slotID
        )


    end)



    ---------------------------------------------------
    -- Tooltip
    ---------------------------------------------------

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
