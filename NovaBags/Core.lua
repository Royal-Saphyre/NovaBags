--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Creates the main Nova window
--=============================================================================

print("Core.lua loaded")
print("NovaItemButtons =", NovaItemButtons)
print("NovaCreateItemButton =", NovaCreateItemButton)


---------------------------------------------------
-- Main Window
---------------------------------------------------

NovaFrame = CreateFrame(
    "Frame",
    "NovaMainFrame",
    UIParent
)

NovaFrame:SetSize(600, 450)
NovaFrame:SetPoint("CENTER")


NovaFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 24,
    insets = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8
    }
})


NovaFrame:SetMovable(true)
NovaFrame:EnableMouse(true)

NovaFrame:RegisterForDrag(
    "LeftButton"
)


NovaFrame:SetScript(
    "OnDragStart",
    function(self)
        self:StartMoving()
    end
)


NovaFrame:SetScript(
    "OnDragStop",
    function(self)
        self:StopMovingOrSizing()
    end
)


NovaFrame:Hide()



---------------------------------------------------
-- Nova Header
---------------------------------------------------

local header = CreateFrame(
    "Frame",
    nil,
    NovaFrame
)

header:SetSize(
    600,
    70
)

header:SetPoint(
    "TOP",
    NovaFrame,
    "TOP",
    0,
    0
)



-- Starburst Logo

local logo = header:CreateTexture(
    nil,
    "ARTWORK"
)

logo:SetSize(
    55,
    55
)

logo:SetPoint(
    "LEFT",
    25,
    0
)


logo:SetTexture(
    "Interface\\Icons\\Spell_Shadow_Twilight"
)



-- NovaBags Title

local title = header:CreateFontString(
    nil,
    "OVERLAY"
)


title:SetFont(
    "Fonts\\FRIZQT__.TTF",
    28,
    "OUTLINE"
)


title:SetPoint(
    "LEFT",
    logo,
    "RIGHT",
    15,
    0
)


title:SetText(
    "|cff00ccffNova|rBags"
)



---------------------------------------------------
-- Close Button
---------------------------------------------------

local close = CreateFrame(
    "Button",
    nil,
    NovaFrame,
    "UIPanelCloseButton"
)

close:SetPoint(
    "TOPRIGHT",
    -5,
    -5
)


close:SetScript(
    "OnClick",
    function()
        NovaFrame:Hide()
    end
)



---------------------------------------------------
-- Display Items
---------------------------------------------------

function NovaDisplayItems()

    NovaScanBags()


    print(
        "|cffd4af37Nova|r displaying "..#NovaInventory.." items"
    )


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
            -80 - math.floor((i-1)/10)*45
        )



        local _, _, _, _, _, _, _, _, _, icon =
            GetItemInfo(item.link)



        button.icon:SetTexture(
            icon
        )


        button.count:SetText(
            item.count
        )


        button.link = item.link


        button:Show()


    end

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
