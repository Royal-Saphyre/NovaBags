--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================

local SPACING = 36
local COLUMNS = 10

------------------------------------------------
-- Main Frame
------------------------------------------------

NovaFrame = CreateFrame("Frame", "NovaMainFrame", UIParent)
NovaFrame:SetSize(400, 480)
NovaFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)

NovaFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

NovaFrame:SetBackdropColor(0.02, 0.02, 0.02, 0.95)
NovaFrame:SetBackdropBorderColor(0.85, 0.65, 0.15, 1)

NovaFrame:SetMovable(true)
NovaFrame:EnableMouse(true)
NovaFrame:RegisterForDrag("LeftButton")

NovaFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
NovaFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

NovaFrame:Hide()

------------------------------------------------
-- Header & Title
------------------------------------------------

local header = NovaFrame:CreateTexture(nil, "ARTWORK")
header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
header:SetSize(300, 64)
header:SetPoint("TOP", 0, 12)
NovaHeader = header

local logo = NovaFrame:CreateTexture(nil, "OVERLAY")
logo:SetTexture("Interface\\Icons\\INV_Misc_Orb_05")
logo:SetSize(38, 38)
logo:SetPoint("LEFT", header, "LEFT", 35, 0)
NovaLogo = logo

local title = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("CENTER", header, "CENTER", 0, 9)
title:SetText("NovaBags")

------------------------------------------------
-- Close Button
------------------------------------------------

local close = CreateFrame("Button", nil, NovaFrame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -5, -5)
close:SetScript("OnClick", function() NovaFrame:Hide() end)

------------------------------------------------
-- Themes
------------------------------------------------

NovaThemes = {
    Default = { 0.1, 0.1, 0.1, 0.7, 0.7, 0.7, "Interface\\Icons\\INV_Misc_QuestionMark" },
    ObsidianGold = { 0.02, 0.02, 0.02, 0.85, 0.65, 0.15, "Interface\\Icons\\INV_Ingot_05" },
    Shadow = { 0.04, 0.03, 0.06, 0.5, 0.2, 0.8, "Interface\\Icons\\Spell_Shadow_Shadesofdark" },
    Arcane = { 0.08, 0.02, 0.15, 0.5, 0.3, 1, "Interface\\Icons\\Spell_Arcane_Arcane01" },
    Nature = { 0.02, 0.12, 0.04, 0.3, 0.8, 0.3, "Interface\\Icons\\Spell_Nature_NatureBlessing" }
}

function NovaApplyTheme(name)
    local t = NovaThemes[name]
    if not t then return end

    NovaFrame:SetBackdropColor(t[1], t[2], t[3], 0.95)
    NovaFrame:SetBackdropBorderColor(t[4], t[5], t[6], 1)
    NovaHeader:SetVertexColor(t[4], t[5], t[6], 1)
end

local themeOrder = { "Default", "ObsidianGold", "Shadow", "Arcane", "Nature" }

for i, name in ipairs(themeOrder) do
    local b = CreateFrame("Button", nil, NovaFrame)
    b:SetSize(22, 22)
    b:SetPoint("TOPRIGHT", -15 - (i * 25), -15)
    b:SetNormalTexture(NovaThemes[name][7])
    b:SetScript("OnClick", function() NovaApplyTheme(name) end)
end

NovaApplyTheme("ObsidianGold")

------------------------------------------------
-- Slots Creation
------------------------------------------------

NovaSlots = {}

function NovaCreateSlots(amount)
    for i = #NovaSlots + 1, amount do
        local button = NovaCreateItemButton(NovaFrame, i)

        -- Properly padded Grid Calculation anchored inside NovaFrame
        local col = (i - 1) % COLUMNS
        local row = math.floor((i - 1) / COLUMNS)

        local xPos = 20 + (col * SPACING)
        local yPos = -55 - (row * SPACING)

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", NovaFrame, "TOPLEFT", xPos, yPos)

        NovaSlots[i] = button
    end
end

------------------------------------------------
-- Display Items
------------------------------------------------

function NovaDisplayItems()
    NovaScanBags()

    local count = #NovaInventory
    NovaCreateSlots(count)

    for i, button in ipairs(NovaSlots) do
        local item = NovaInventory[i]

        if item then
            button.bagID = item.bagID
            button.slotID = item.slotID
            button.link = item.link

            if item.texture then
                button.icon:SetTexture(item.texture)
                button.icon:Show()
            else
                button.icon:SetTexture(nil)
            end

            button.count:SetText(item.count)
            button:Show()
        else
            button:Hide()
        end
    end
end

------------------------------------------------
-- Scan button
------------------------------------------------

local scan = CreateFrame("Button", nil, NovaFrame, "UIPanelButtonTemplate")
scan:SetSize(80, 22)
scan:SetPoint("BOTTOM", 0, 10)
scan:SetText("Scan")
scan:SetScript("OnClick", NovaDisplayItems)

------------------------------------------------
-- Slash Command
------------------------------------------------

SLASH_NOVA1 = "/nova"
SlashCmdList["NOVA"] = function()
    if NovaFrame:IsShown() then
        NovaFrame:Hide()
    else
        NovaFrame:Show()
        NovaDisplayItems()
    end
end
