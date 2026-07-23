--=============================================================================
-- NovaBags
-- File: Core.lua
--=============================================================================

local SPACING = 36
local COLUMNS = 9

------------------------------------------------
-- Main Frame
------------------------------------------------

NovaFrame = CreateFrame("Frame", "NovaMainFrame", UIParent)
NovaFrame:SetSize(370, 420)
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
-- Header & Title (Fixed Position Inside Banner)
------------------------------------------------

local header = NovaFrame:CreateTexture(nil, "ARTWORK")
header:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Header")
header:SetSize(260, 50)
header:SetPoint("TOP", 0, 10)
NovaHeader = header

local title = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", header, "TOP", 10, -18)
title:SetText("NovaBags")

local logo = NovaFrame:CreateTexture(nil, "OVERLAY")
logo:SetTexture("Interface\\Icons\\Ability_Druid_Starfall")
logo:SetSize(20, 20)
logo:SetPoint("RIGHT", title, "LEFT", -6, 0)
NovaLogo = logo

------------------------------------------------
-- Close Button
------------------------------------------------

local close = CreateFrame("Button", nil, NovaFrame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -5, -5)
close:SetScript("OnClick", function() NovaFrame:Hide() end)

------------------------------------------------
-- Scroll Container & Child Content Frame
------------------------------------------------

local scrollFrame = CreateFrame("ScrollFrame", "NovaBagScrollFrame", NovaFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", NovaFrame, "TOPLEFT", 15, -45)
scrollFrame:SetPoint("BOTTOMRIGHT", NovaFrame, "BOTTOMRIGHT", -35, 45)

local scrollChild = CreateFrame("Frame", "NovaBagScrollChild", scrollFrame)
scrollChild:SetSize(320, 1)
scrollFrame:SetScrollChild(scrollChild)

scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local current = self:GetVerticalScroll()
    local maxScroll = self:GetVerticalScrollRange()
    local newScroll = current - (delta * 30)

    if newScroll < 0 then newScroll = 0 end
    if newScroll > maxScroll then newScroll = maxScroll end

    self:SetVerticalScroll(newScroll)
end)

------------------------------------------------
-- Themes
------------------------------------------------

NovaThemes = {
    Default      = { 0.10, 0.10, 0.10, 0.70, 0.70, 0.70, "Interface\\Icons\\INV_Misc_QuestionMark" },
    ObsidianGold = { 0.02, 0.02, 0.02, 0.85, 0.65, 0.15, "Interface\\Icons\\INV_Ingot_05" },
    Shadow       = { 0.04, 0.03, 0.06, 0.50, 0.20, 0.80, "Interface\\Icons\\Spell_Shadow_Shadesofdark" },
    Arcane       = { 0.08, 0.02, 0.15, 0.50, 0.30, 1.00, "Interface\\Icons\\Spell_Arcane_Arcane01" },
    Starfire     = { 0.02, 0.08, 0.18, 0.20, 0.60, 1.00, "Interface\\Icons\\Spell_Arcane_StarFire" }
}

function NovaApplyTheme(name)
    local t = NovaThemes[name]
    if not t then return end

    NovaFrame:SetBackdropColor(t[1], t[2], t[3], 0.95)
    NovaFrame:SetBackdropBorderColor(t[4], t[5], t[6], 1)
    NovaHeader:SetVertexColor(t[4], t[5], t[6], 1)
end

local themeOrder = { "Default", "ObsidianGold", "Shadow", "Arcane", "Starfire" }

local themeFooterLabel = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
themeFooterLabel:SetPoint("BOTTOMLEFT", 15, 16)
themeFooterLabel:SetText("Themes:")

for i, name in ipairs(themeOrder) do
    local b = CreateFrame("Button", nil, NovaFrame)
    b:SetSize(20, 20)
    b:SetPoint("BOTTOMLEFT", 60 + ((i - 1) * 24), 12)
    b:SetNormalTexture(NovaThemes[name][7])
    b:SetScript("OnClick", function() NovaApplyTheme(name) end)
end

NovaApplyTheme("ObsidianGold")

------------------------------------------------
-- Slots Creation & Dynamic Scroll Height
------------------------------------------------

NovaSlots = {}

function NovaCreateSlots(amount)
    for i = #NovaSlots + 1, amount do
        local button = NovaCreateItemButton(scrollChild, i)

        local col = (i - 1) % COLUMNS
        local row = math.floor((i - 1) / COLUMNS)

        local xPos = (col * SPACING)
        local yPos = -(row * SPACING)

        button:ClearAllPoints()
        button:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", xPos, yPos)

        NovaSlots[i] = button
    end

    local totalRows = math.ceil(amount / COLUMNS)
    scrollChild:SetHeight(math.max(totalRows * SPACING, 10))
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
            button.bagID = nil
            button.slotID = nil
            button.link = nil
            button.icon:SetTexture(nil)
            button.count:SetText("")
            button:Hide()
        end
    end
end

------------------------------------------------
-- Real Physical Bag Sorting Engine
------------------------------------------------

local isSorting = false

function NovaSortBagsPhysical()
    if isSorting or CursorHasItem() then return end
    isSorting = true

    NovaScanBags()

    -- Map out ideal target positions
    local sortedList = {}
    for i, item in ipairs(NovaInventory) do
        table.insert(sortedList, item)
    end

    table.sort(sortedList, function(a, b)
        if a.hasItem ~= b.hasItem then
            return a.hasItem and not b.hasItem
        end
        if not a.hasItem and not b.hasItem then
            return false
        end

        local _, _, qA = GetItemInfo(a.link or "")
        local _, _, qB = GetItemInfo(b.link or "")
        qA = qA or -1
        qB = qB or -1

        if qA ~= qB then
            return qA > qB
        end
        return (a.link or "") < (b.link or "")
    end)

    -- Move items sequentially to physical target slots
    local moves = 0
    for i, targetItem in ipairs(sortedList) do
        local currentSlot = NovaInventory[i]
        if targetItem.hasItem and (targetItem.bagID ~= currentSlot.bagID or targetItem.slotID ~= currentSlot.slotID) then
            PickupContainerItem(targetItem.bagID, targetItem.slotID)
            PickupContainerItem(currentSlot.bagID, currentSlot.slotID)
            moves = moves + 1

            if moves > 8 then break end -- Process in chunks to prevent server throttle
        end
    end

    isSorting = false
    NovaDisplayItems()
end

------------------------------------------------
-- Footer Action Buttons
------------------------------------------------

local scan = CreateFrame("Button", nil, NovaFrame, "UIPanelButtonTemplate")
scan:SetSize(50, 20)
scan:SetPoint("BOTTOMRIGHT", -15, 12)
scan:SetText("Scan")
scan:SetScript("OnClick", function() NovaDisplayItems() end)

local sortBtn = CreateFrame("Button", nil, NovaFrame, "UIPanelButtonTemplate")
sortBtn:SetSize(50, 20)
sortBtn:SetPoint("RIGHT", scan, "LEFT", -4, 0)
sortBtn:SetText("Sort")
sortBtn:SetScript("OnClick", function() NovaSortBagsPhysical() end)

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
