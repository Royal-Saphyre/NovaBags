--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Creates the main Nova window
--=============================================================================

NovaFrame = CreateFrame("Frame", "NovaMainFrame", UIParent)

NovaFrame:SetSize(600, 450)
NovaFrame:SetPoint("CENTER")

NovaFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    }
})

NovaFrame:SetMovable(true)
NovaFrame:EnableMouse(true)

NovaFrame:RegisterForDrag("LeftButton")

NovaFrame:SetScript("OnDragStart", function(self)
    self:StartMoving()
end)

NovaFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
end)


NovaFrame:Hide()


-- Close button

local close = CreateFrame(
    "Button",
    nil,
    NovaFrame,
    "UIPanelCloseButton"
)

close:SetPoint("TOPRIGHT", -5, -5)

close:SetScript("OnClick", function()
    NovaFrame:Hide()
end)



-- Slash command

SLASH_NOVA1 = "/nova"

SlashCmdList["NOVA"] = function()

    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end

end

function NovaDisplayItems()

    NovaScanBags()


    for i, item in ipairs(NovaInventory) do

        local button = NovaItemButtons[i]


        if not button then

            button = NovaCreateItemButton(
                NovaFrame,
                i
            )

        end


        button:SetPoint(
            "TOPLEFT",
            30 + ((i-1)%10)*45,
            -60 - math.floor((i-1)/10)*45
        )


        local _, _, _, _, _, _, _, _, _, icon =
            GetItemInfo(item.link)


        button.icon:SetTexture(icon)

        button.count:SetText(
            item.count
        )

        button.link = item.link

        button:Show()

    end

end
