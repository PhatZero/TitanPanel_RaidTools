local addonName, ns = ...

-- Core namespace / defaults
ns.db = ns.db or {}
ns.debug = ns.debug or false

local function DebugPrint(...)
    if ns.debug then
        print("|cffffd100[RaidTools]|r", ...)
    end
end

-- Basic load guard: if Titan is truly missing, emit a single warning.
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" and name == addonName then
        if not TitanPanelButton_UpdateButton then
            print("|cffff0000[RaidTools]|r Titan Panel API not found. TitanPanel_RaidTools will be disabled.")
        else
            DebugPrint("Loaded for addon:", addonName)
        end
    end
end)
