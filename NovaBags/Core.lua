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
NovaFrame:SetSize(370, 440)
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
header:SetSize(260, 50)
header:SetPoint("TOP", 0, 10)
NovaHeader = header

local title = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOP", header, "TOP", 10, -10)
title:SetText("NovaBags")

local logo = NovaFrame:CreateTexture(nil, "OVERLAY")
logo:SetTexture("Interface\\Icons\\Ability_Druid_Starfall")
logo:SetSize(20, 20)
logo:SetPoint("RIGHT", title, "LEFT", -6, 0)
NovaLogo = logo

------------------------------------------------
-- Close Button (Top-Right Above Emblem)
------------------------------------------------

local close = CreateFrame("Button", nil, NovaFrame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", NovaFrame, "TOPRIGHT", 5, 5)
close:SetFrameLevel(NovaFrame:GetFrameLevel() + 10)
close:SetScript("OnClick", function() NovaFrame:Hide() end)

------------------------------------------------
-- Corner Emblems
------------------------------------------------

local leftCorner = NovaFrame:CreateTexture(nil, "OVERLAY")
leftCorner:SetSize(42, 42)
leftCorner:SetPoint("TOPLEFT", NovaFrame, "TOPLEFT", 2, -2)

local rightCorner = NovaFrame:CreateTexture(nil, "OVERLAY")
rightCorner:SetSize(42, 42)
rightCorner:SetPoint("TOPRIGHT", NovaFrame, "TOPRIGHT", -2, -2)
rightCorner:SetTexCoord(1, 0, 0, 1)

-- Pulse VFX Animation
local animGroup = NovaFrame:CreateAnimationGroup()
animGroup:SetLooping("REPEAT")

local fadeOut = animGroup:CreateAnimation("Alpha")
fadeOut:SetChange(-0.30)
fadeOut:SetDuration(1.2)
fadeOut:SetOrder(1)

local fadeIn = animGroup:CreateAnimation("Alpha")
fadeIn:SetChange(0.30)
fadeIn:SetDuration(1.2)
fadeIn:SetOrder(2)

animGroup:Play()

------------------------------------------------
-- Themes (Bottom Left)
------------------------------------------------

local EMBLEM_LION    = "Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Human"
local EMBLEM_DRAGON  = "Interface\\MainMenuBar\\UI-MainMenuBar-EndCap-Dwarf"
local EMBLEM_DWARF   = "Interface\\FrameXML\\UI-Frame-Dwarf-Corner"
local EMBLEM_ELF     = "Interface\\FrameXML\\UI-Frame-NightElf-Corner"
local EMBLEM_WING    = "Interface\\TutorialFrame\\UI-TutorialFrame-LevelUp"

NovaThemes = {
    Default      = { 0.10, 0.10, 0.10, 0.70, 0.70, 0.70, "Interface\\Icons\\INV_Misc_QuestionMark", EMBLEM_LION },
    ObsidianGold = { 0.02, 0.02, 0.02, 0.85, 0.65, 0.15, "Interface\\Icons\\INV_Ingot_05",           EMBLEM_DRAGON },
    Shadow       = { 0.04, 0.03, 0.06, 0.50, 0.20, 0.80, "Interface\\Icons\\Spell_Shadow_Shadesofdark", EMBLEM_ELF },
    Arcane       = { 0.08, 0.02, 0.15, 0.50, 0.30, 1.00, "Interface\\Icons\\Spell_Arcane_Arcane01",     EMBLEM_DWARF },
    Starfire     = { 0.02, 0.08, 0.18, 0.20, 0.60, 1.00, "Interface\\Icons\\Spell_Arcane_StarFire",     EMBLEM_WING }
}

NovaCurrentTheme = "ObsidianGold"

local themeLabel = NovaFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
themeLabel:SetPoint("BOTTOMLEFT", 15, 14)
themeLabel:SetText("Themes:")

local themeOrder = { "Default", "ObsidianGold", "Shadow", "Arcane", "Starfire" }

for i, name in ipairs(themeOrder) do
    local b = CreateFrame("Button", nil, NovaFrame)
    b:SetSize(16, 16)
    b:SetPoint("BOTTOMLEFT", 60 + ((i - 1) * 20), 12)
    b:SetNormalTexture(NovaThemes[name][7])
    b:SetScript("OnClick", function() NovaApplyTheme(name) end)
end

function NovaApplyTheme(name)
    local t = NovaThemes[name]
    if not t then return end

    NovaCurrentTheme = name

    NovaFrame:SetBackdropColor(t[1], t[2], t[3], 0.95)
    NovaFrame:SetBackdropBorderColor(t[4], t[5], t[6], 1)
    NovaHeader:SetVertexColor(t[4], t[5], t[6], 1)

    leftCorner:SetTexture(t[8])
    rightCorner:SetTexture(t[8])

    leftCorner:SetVertexColor(t[4], t[5], t[6], 1)
    rightCorner:SetVertexColor(t[4], t[5], t[6], 1)

    if NovaSlots then
        for _, btn in ipairs(NovaSlots) do
            if btn and btn.bg then
                btn.bg:SetVertexColor(t[4], t[5], t[6], 0.8)
            end
        end
    end
end

------------------------------------------------
-- Money Display Frame (Positioned Right of Themes)
------------------------------------------------

local moneyFrame = CreateFrame("Frame", "NovaMoneyFrame", NovaFrame)
moneyFrame:SetSize(110, 20)
moneyFrame:SetPoint("BOTTOMLEFT", 170, 12)

local moneyText = moneyFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
moneyText:SetPoint("LEFT", moneyFrame, "LEFT", 0, 0)

function NovaUpdateMoney()
    local totalCopper = GetMoney()
    local gold = math.floor(totalCopper / 10000)
    local silver = math.floor((totalCopper % 10000) / 100)
    local copper = totalCopper % 100

    local str = ""
    if gold > 0 then
        str = str .. gold .. "|cffffd700g|r "
    end
    if silver > 0 or gold > 0 then
        str = str .. silver .. "|cffc7c7c1s|r "
    end
    str = str .. copper .. "|cffdda0ddc|r"

    moneyText:SetText(str)
end

local moneyEvents = CreateFrame("Frame")
moneyEvents:RegisterEvent("PLAYER_MONEY")
moneyEvents:RegisterEvent("PLAYER_ENTERING_WORLD")
moneyEvents:SetScript("OnEvent", function()
    NovaUpdateMoney()
end)

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
-- Slots Creation
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

    NovaApplyTheme(NovaCurrentTheme)
    NovaUpdateMoney()
end

------------------------------------------------
-- Real Physical Bag Sorting Engine
------------------------------------------------

local isSorting = false

function NovaSortBagsPhysical()
    if isSorting or CursorHasItem() then return end
    isSorting = true

    NovaScanBags()

    local targetOrder = {}
    for i, item in ipairs(NovaInventory) do
        table.insert(targetOrder, item)
    end

    table.sort(targetOrder, function(a, b)
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

    local currentLayout = {}
    for i, item in ipairs(NovaInventory) do
        currentLayout[i] = {
            bagID = item.bagID,
            slotID = item.slotID,
            link = item.link,
            hasItem = item.hasItem
        }
    end

    for targetIndex, targetItem in ipairs(targetOrder) do
        if targetItem.hasItem then
            local currentPos = nil
            for idx, liveItem in ipairs(currentLayout) do
                if liveItem.bagID == targetItem.bagID and liveItem.slotID == targetItem.slotID then
                    currentPos = idx
                    break
                end
            end

            if currentPos and currentPos ~= targetIndex then
                local destSlot = currentLayout[targetIndex]
                local srcSlot = currentLayout[currentPos]

                PickupContainerItem(srcSlot.bagID, srcSlot.slotID)
                PickupContainerItem(destSlot.bagID, destSlot.slotID)

                currentLayout[targetIndex], currentLayout[currentPos] = currentLayout[currentPos], currentLayout[targetIndex]
            end
        end
    end

    isSorting = false
    NovaDisplayItems()
end

------------------------------------------------
-- Footer Action Buttons
------------------------------------------------

local scan = CreateFrame("Button", nil, NovaFrame, "UIPanelButtonTemplate")
scan:SetSize(45, 20)
scan:SetPoint("BOTTOMRIGHT", -10, 12)
scan:SetText("Scan")
scan:SetScript("OnClick", function() NovaDisplayItems() end)

local sortBtn = CreateFrame("Button", nil, NovaFrame, "UIPanelButtonTemplate")
sortBtn:SetSize(45, 20)
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
