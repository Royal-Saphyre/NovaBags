--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Creates the main Nova window
--=============================================================================

NovaFrame = CreateFrame("Frame", "NovaMainFrame", UIParent)

NovaFrame:SetSize(400, 420)
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



---------------------------------------------------
-- Header (metallic title bar)
---------------------------------------------------

local header = NovaFrame:CreateTexture(nil, "ARTWORK")

header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
header:SetSize(300, 64)
header:SetPoint("TOP", NovaFrame, "TOP", 0, 12)


local title = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")

title:SetPoint("TOP", header, "TOP", 0, -14)
title:SetText("NovaBags")



-- Close button

local close = CreateFrame(
    "Button",
    nil,
    NovaFrame,
    "UIPanelCloseButton"
)

close:SetPoint("TOPRIGHT", -2, -6)


close:SetScript("OnClick", function()
    NovaFrame:Hide()
end)



---------------------------------------------------
-- Scrollable item container
---------------------------------------------------

local ICON_SIZE   = 30
local ICON_SPACING = 34
local ICONS_PER_ROW = 10

local scrollFrame = CreateFrame(
    "ScrollFrame",
    "NovaScrollFrame",
    NovaFrame,
    "UIPanelScrollFrameTemplate"
)

scrollFrame:SetPoint("TOPLEFT", 16, -40)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 16)


local scrollChild = CreateFrame("Frame", "NovaScrollChild", scrollFrame)

scrollChild:SetSize(1, 1)

scrollFrame:SetScrollChild(scrollChild)



---------------------------------------------------
-- Display Items
---------------------------------------------------

function NovaDisplayItems()

    if not NovaItemButtons or not NovaCreateItemButton then

        print("|cffff0000NovaBags error:|r ItemButton.lua did not load. Check that it exists in Interface\\AddOns\\NovaBags and is listed in NovaBags.toc before Core.lua.")

        return

    end


    NovaScanBags()


    print("|cffd4af37Nova|r displaying "..#NovaInventory.." items")


    for i, item in ipairs(NovaInventory) do


        local button = NovaItemButtons[i]


        if not button then

            button = NovaCreateItemButton(
                scrollChild,
                i
            )

        end



        button:SetSize(ICON_SIZE, ICON_SIZE)


        button:SetPoint(
            "TOPLEFT",
            ((i-1) % ICONS_PER_ROW) * ICON_SPACING,
            -math.floor((i-1) / ICONS_PER_ROW) * ICON_SPACING
        )



        local _, _, _, _, _, _, _, _, _, icon =
            GetItemInfo(item.link)


        -- Item may not be in the local cache yet (e.g. never
        -- seen this session). Fall back to a placeholder icon
        -- instead of leaving the texture blank/nil.
        button.icon:SetTexture(
            icon or "Interface\\Icons\\INV_Misc_QuestionMark"
        )


        button.count:SetText(
            item.count
        )


        button.link = item.link


        button:Show()


    end


    -- Hide any leftover buttons from a previous scan that had
    -- more items than the current one (e.g. after using/selling
    -- items), so they don't stick around as "ghost" icons.
    for i = #NovaInventory + 1, #NovaItemButtons do

        NovaItemButtons[i]:Hide()

    end


    -- Resize the scrollable content area to fit however many
    -- rows of items we actually have, so the scrollbar range
    -- is correct (and nothing gets clipped or has dead space).
    local rows = math.max(1, math.ceil(#NovaInventory / ICONS_PER_ROW))

    scrollChild:SetSize(
        ICONS_PER_ROW * ICON_SPACING,
        rows * ICON_SPACING
    )

end



---------------------------------------------------
-- Slash Command
---------------------------------------------------

SLASH_NOVA1 = "/nova"


SlashCmdList["NOVA"] = function()


    if NovaFrame:IsShown() then

        NovaFrame:Hide()


    else

        NovaFrame:Show()

        NovaDisplayItems()

    end


end
