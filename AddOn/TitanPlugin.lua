local addonName, ns = ...
local Compat = ns.Compat

local TITAN_ID = "RaidTools"
local TITAN_BUTTON = "TitanPanel" .. TITAN_ID .. "Button"

local function IsLeaderOrAssist()
    return UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")
end

local function DoReadyCheckCompat()
    if not IsInGroup() then
        print("|cffffd100[RaidTools]|r You are not in a group.")
        return
    end
    if not IsLeaderOrAssist() then
        print("|cffffd100[RaidTools]|r You must be leader/assistant to start a ready check.")
        return
    end
    if type(DoReadyCheck) == "function" then
        DoReadyCheck()
        return
    end
    if type(RunMacroText) == "function" then
        RunMacroText("/readycheck")
        return
    end
    print("|cffffd100[RaidTools]|r Ready check is not available on this client.")
end

local function HasWorldMarkers()
    return (Compat and Compat.HasWorldMarkers and Compat.HasWorldMarkers()) or false
end

local function PlaceWorldMarker(markerIndex)
    if not IsInGroup() then
        print("|cffffd100[RaidTools]|r You are not in a group.")
        return
    end
    if not IsLeaderOrAssist() then
        print("|cffffd100[RaidTools]|r You must be leader/assistant to place world markers.")
        return
    end
    if InCombatLockdown() then
        print("|cffff0000[RaidTools]|r Cannot place world markers in combat.")
        return
    end
    if not HasWorldMarkers() then
        print("|cffffd100[RaidTools]|r World markers are not supported on this client.")
        return
    end
    if type(RunMacroText) == "function" then
        -- Note: /wm enters placement mode; click the ground to drop it.
        RunMacroText("/wm " .. tostring(markerIndex))
    end
end

local function ClearWorldMarkers()
    if not IsInGroup() then
        print("|cffffd100[RaidTools]|r You are not in a group.")
        return
    end
    if not IsLeaderOrAssist() then
        print("|cffffd100[RaidTools]|r You must be leader/assistant to clear world markers.")
        return
    end
    if InCombatLockdown() then
        print("|cffff0000[RaidTools]|r Cannot clear world markers in combat.")
        return
    end
    if not HasWorldMarkers() then
        print("|cffffd100[RaidTools]|r World markers are not supported on this client.")
        return
    end

    if type(ClearRaidMarker) == "function" then
        ClearRaidMarker()
        return
    end
    if type(RunMacroText) == "function" then
        RunMacroText("/cwm 0")
    end
end

-------------------------------------------------------
-- Titan Button
-------------------------------------------------------
local button = CreateFrame("Button", TITAN_BUTTON, UIParent, "TitanPanelComboTemplate")
button.registry = {
    id = TITAN_ID,
    category = "General",
    version = "1.0.0",
    menuText = "RaidTools",
    buttonTextFunction = "TitanPanelRaidToolsButton_GetButtonText",
    tooltipTitle = "RaidTools",
    tooltipTextFunction = "TitanPanelRaidToolsButton_GetTooltipText",
    icon = "Interface\\AddOns\\TitanPanelRaidTools\\media\\icon",
    iconWidth = 16,
    savedVariables = {
        ShowIcon = 1,
        ShowLabelText = 1,
        ShowColoredText = 1,
    },
}

function TitanPanelRaidToolsButton_GetButtonText(id)
    return "RaidTools"
end

function TitanPanelRaidToolsButton_GetTooltipText()
    return "Right-click: Ready Check & World Markers"
end

-------------------------------------------------------
-- Titan Right-click Menu
-- RaidTools
--  -> ReadyCheck
--  -> World Markers (submenu)
-------------------------------------------------------
function TitanPanelRightClickMenu_PrepareRaidToolsMenu()
    local info
    local level = UIDROPDOWNMENU_MENU_LEVEL
    local value = UIDROPDOWNMENU_MENU_VALUE

    if level == 1 then
        TitanPanelRightClickMenu_AddTitle("RaidTools")

        info = UIDropDownMenu_CreateInfo()
        info.text = "ReadyCheck"
        info.notCheckable = true
        info.func = DoReadyCheckCompat
        UIDropDownMenu_AddButton(info, level)

        info = UIDropDownMenu_CreateInfo()
        info.text = "World Markers"
        info.notCheckable = true
        info.hasArrow = true
        info.value = "WORLD_MARKERS"
        if not HasWorldMarkers() then
            info.disabled = true
        end
        UIDropDownMenu_AddButton(info, level)

        TitanPanelRightClickMenu_AddSpacer()
        TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, TITAN_ID, TITAN_PANEL_MENU_FUNC_HIDE)

    elseif level == 2 and value == "WORLD_MARKERS" then
        local names = { "Star", "Circle", "Diamond", "Triangle", "Moon", "Square", "Cross", "Skull" }

        for i = 1, 8 do
            info = UIDropDownMenu_CreateInfo()
            info.text = names[i]
            info.notCheckable = true
            info.func = function() PlaceWorldMarker(i) end
            UIDropDownMenu_AddButton(info, level)
        end

        TitanPanelRightClickMenu_AddSpacer()

        info = UIDropDownMenu_CreateInfo()
        info.text = "Clear World Markers"
        info.notCheckable = true
        info.func = ClearWorldMarkers
        UIDropDownMenu_AddButton(info, level)
    end
end
