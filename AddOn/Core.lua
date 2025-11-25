local addonName, ns = ...

-- Simple namespace table
_G[addonName] = ns or {}
ns = _G[addonName]

-- SavedVariables
TitanPanelRaidToolsDB = TitanPanelRaidToolsDB or {}

local defaults = {
    DisplayMode = "SMART",   -- SMART | CHARGES | COOLDOWN
}

local function ApplyDefaults()
    for k, v in pairs(defaults) do
        if TitanPanelRaidToolsDB[k] == nil then
            TitanPanelRaidToolsDB[k] = v
        end
    end
end

ns.db = TitanPanelRaidToolsDB

-- Ready check tracking
ns.readyStatus = {}
ns.readyActive = false
ns.readyStarted = 0
ns.readyInitiator = nil

local events = CreateFrame("Frame")

events:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            ApplyDefaults()
        end

    elseif event == "READY_CHECK" then
        local initiator = ...
        wipe(ns.readyStatus)
        ns.readyActive = true
        ns.readyInitiator = initiator
        ns.readyStarted = GetTime()

    elseif event == "READY_CHECK_CONFIRM" then
        local unit, isReady = ...
        local name = unit and UnitName(unit) or unit
        if name then
            ns.readyStatus[name] = isReady and true or false
        end

    elseif event == "READY_CHECK_FINISHED" then
        ns.readyActive = false

    end
end)

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("READY_CHECK")
events:RegisterEvent("READY_CHECK_CONFIRM")
events:RegisterEvent("READY_CHECK_FINISHED")
