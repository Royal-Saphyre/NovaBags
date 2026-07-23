--=============================================================================
-- NovaBags
-- File: NovaBags.lua
-- Main addon entry point
--=============================================================================

local addonName = "NovaBags"
local frame = CreateFrame("Frame")

frame:RegisterEvent("PLAYER_LOGIN")

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        print("|cffd4af37NovaBags|r loaded successfully!")
    end
end)
