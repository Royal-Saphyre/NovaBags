--=============================================================================
-- NovaBags
-- File: Core.lua
--
-- Main NovaBags window
--=============================================================================


NovaFrame = CreateFrame(
    "Frame",
    "NovaMainFrame",
    UIParent
)


NovaFrame:SetSize(
    360,
    420
)


NovaFrame:SetPoint(
    "RIGHT",
    UIParent,
    "RIGHT",
    -40,
    0
)



NovaFrame:SetBackdrop({

    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",

    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",

    edgeSize = 16,

    insets =
    {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
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
-- Header
---------------------------------------------------

local header =
NovaFrame:CreateTexture(
nil,
"ARTWORK"
)


header:SetTexture(
"Interface\\DialogFrame\\UI-DialogBox-Header"
)


header:SetSize(
300,
64
)


header:SetPoint(
"TOP",
NovaFrame,
"TOP",
0,
12
)



local title =
NovaFrame:CreateFontString(
nil,
"OVERLAY",
"GameFontNormal"
)


title:SetPoint(
"TOP",
header,
"TOP",
0,
-14
)


title:SetText(
"NovaBags"
)



---------------------------------------------------
-- Close Button
---------------------------------------------------

local close =
CreateFrame(
"Button",
nil,
NovaFrame,
"UIPanelCloseButton"
)


close:SetPoint(
"TOPRIGHT",
-2,
-6
)


close:SetScript(
"OnClick",
function()

NovaFrame:Hide()

end)



---------------------------------------------------
-- Bag Slot Container
---------------------------------------------------

local holder =
CreateFrame(
"Frame",
nil,
NovaFrame
)


holder:SetPoint(
"TOPLEFT",
20,
-50
)



---------------------------------------------------
-- Bag Slot Settings
---------------------------------------------------

local SLOT_SIZE = 30
local SLOT_SPACE = 34
local SLOTS_PER_ROW = 10



---------------------------------------------------
-- Display Bag Slots
---------------------------------------------------

function NovaDisplayItems()


    local index = 1



    for bag = 0,4 do


        local slots =
        GetContainerNumSlots(bag)



        for slot = 1,slots do



            local button =
            NovaItemButtons[index]



            if not button then


                button =
                NovaCreateItemButton(
                    holder,
                    index
                )


            end



            button:SetSize(
                SLOT_SIZE,
                SLOT_SIZE
            )



            button:SetPoint(
                "TOPLEFT",
                ((index-1)%SLOTS_PER_ROW) * SLOT_SPACE,
                -math.floor((index-1)/SLOTS_PER_ROW) * SLOT_SPACE
            )



            button.bagID =
            bag


            button.slotID =
            slot



            local texture,count =
            GetContainerItemInfo(
                bag,
                slot
            )



            local link =
            GetContainerItemLink(
                bag,
                slot
            )



            button.link =
            link



            if texture then



                button.icon:SetTexture(
                    texture
                )



                if count and count > 1 then

                    button.count:SetText(
                        count
                    )

                else

                    button.count:SetText("")

                end



            else



                button.icon:SetTexture(
                    "Interface\\Buttons\\UI-EmptySlot"
                )



                button.count:SetText("")



            end



            button:Show()



            index = index + 1



        end


    end



    for i = index,#NovaItemButtons do

        NovaItemButtons[i]:Hide()

    end



end



---------------------------------------------------
-- Open NovaBags instead of Blizzard bags
---------------------------------------------------

function NovaToggle()


    if NovaFrame:IsShown() then


        NovaFrame:Hide()


    else


        NovaFrame:Show()

        NovaDisplayItems()


    end


end



function ToggleBackpack()

    NovaToggle()

end



function OpenBackpack()

    NovaToggle()

end



function OpenAllBags()

    NovaToggle()

end



function ToggleAllBags()

    NovaToggle()

end



---------------------------------------------------
-- Refresh when bags update
---------------------------------------------------

local update =
CreateFrame("Frame")



update:RegisterEvent(
"BAG_UPDATE"
)



update:SetScript(
"OnEvent",
function()


    if NovaFrame:IsShown() then

        NovaDisplayItems()

    end


end)



---------------------------------------------------
-- Slash Command
---------------------------------------------------

SLASH_NOVA1 = "/nova"



SlashCmdList["NOVA"] =
function()

    NovaToggle()

end
