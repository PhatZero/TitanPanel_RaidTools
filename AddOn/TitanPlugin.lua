local addonName, ns = ...

local ID = "RaidTools"
local BR = ns.BR
local Markers = ns.Markers

function TitanPanelRaidToolsButton_GetButtonText(id)
    local label = "Raid Tools"
    local value = BR:GetDisplayText()
    return label, value
end

function TitanPanelRaidToolsButton_GetTooltipText()
    local lines = {}

    table.insert(lines, "|cffffd100Ready Check|r")
    if ns.readyActive then
        table.insert(lines, string.format("In progress by: |cffffffff%s|r", ns.readyInitiator or "Unknown"))
    end

    if next(ns.readyStatus) then
        table.insert(lines, " ")
        for name, ready in pairs(ns.readyStatus) do
            local icon = ready and "|cff00ff00Ready|r" or "|cffff0000Not Ready|r"
            table.insert(lines, string.format("%s - %s", name, icon))
        end
    else
        table.insert(lines, "No recent ready check data.")
    end

    table.insert(lines, " ")
    local brLines = BR:GetTooltipLines()
    for _, l in ipairs(brLines) do
        table.insert(lines, l)
    end

    table.insert(lines, " ")
    table.insert(lines, "|cffffd100Left-click|r: Ready Check")
    table.insert(lines, "|cffffd100Right-click|r: Markers & Options")

    return table.concat(lines, "\n")
end

function TitanPanelRaidToolsButton_OnClick(self, button)
    if button == "LeftButton" then
        DoReadyCheck()
    elseif button == "RightButton" then
        TitanPanelButton_OnClick(self, button)
    end
end

function TitanPanelRaidToolsButton_RightClickMenu_PrepareMenu(self, level)
    if not level then return end

    if level == 1 then
        TitanPanelRightClickMenu_AddTitle("Raid Tools")

        TitanPanelRightClickMenu_AddCommand("Ready Check", ID, "TitanPanelRaidToolsButton_DoReadyCheck")

        TitanPanelRightClickMenu_AddSpacer()

        TitanPanelRightClickMenu_AddTitle("Raid Target Icons")
        local raidMarkers = {
            { text = "Skull",    id = 8 },
            { text = "Cross",    id = 7 },
            { text = "Square",   id = 6 },
            { text = "Moon",     id = 5 },
            { text = "Triangle", id = 4 },
            { text = "Diamond",  id = 3 },
            { text = "Circle",   id = 2 },
            { text = "Star",     id = 1 },
        }

        for _, m in ipairs(raidMarkers) do
            TitanPanelRightClickMenu_AddCommand(m.text, ID, "TitanPanelRaidToolsButton_SetRaidMarker" .. m.id)
        end

        TitanPanelRightClickMenu_AddSpacer()

        TitanPanelRightClickMenu_AddTitle("World Markers (Raid)")

        for i = 1, 8 do
            TitanPanelRightClickMenu_AddCommand("Marker " .. i, ID, "TitanPanelRaidToolsButton_SetWorldMarker" .. i)
        end

        TitanPanelRightClickMenu_AddCommand("Clear World Markers", ID, "TitanPanelRaidToolsButton_ClearWorldMarkers")

        TitanPanelRightClickMenu_AddSpacer()

        TitanPanelRightClickMenu_AddTitle("Display Mode")

        local current = ns.db.DisplayMode or "SMART"

        local function AddMode(label, value)
            local info = {}
            info.text = label
            info.func = function()
                ns.db.DisplayMode = value
                if TitanPanelButton_UpdateButton then
                    TitanPanelButton_UpdateButton(ID)
                end
            end
            info.checked = (current == value)
            UIDropDownMenu_AddButton(info, level)
        end

        AddMode("Charges Only", "CHARGES")
        AddMode("Charges + Cooldown", "COOLDOWN")
        AddMode("Smart Auto (default)", "SMART")

        TitanPanelRightClickMenu_AddSpacer()

        TitanPanelRightClickMenu_AddCommand("Open Blizzard Options", ID, "TitanPanelRaidToolsButton_OpenOptions")

        TitanPanelRightClickMenu_AddSpacer()
        TitanPanelRightClickMenu_AddToggleIcon(ID)
        TitanPanelRightClickMenu_AddToggleLabelText(ID)
        TitanPanelRightClickMenu_AddToggleColoredText(ID)
        TitanPanelRightClickMenu_AddSpacer()
        TitanPanelRightClickMenu_AddCommand(TITAN_PANEL_MENU_HIDE, ID, TITAN_PANEL_MENU_FUNC_HIDE)
    end
end

function TitanPanelRaidToolsButton_DoReadyCheck()
    DoReadyCheck()
end

for i = 1, 8 do
    _G["TitanPanelRaidToolsButton_SetRaidMarker" .. i] = function()
        Markers:SetRaidMarker(i)
    end
    _G["TitanPanelRaidToolsButton_SetWorldMarker" .. i] = function()
        Markers:SetWorldMarker(i)
    end
end

function TitanPanelRaidToolsButton_ClearWorldMarkers()
    Markers:ClearWorldMarkers()
end

function TitanPanelRaidToolsButton_OpenOptions()
    if InterfaceOptionsFrame then
        InterfaceOptionsFrame_OpenToCategory("Titan Panel: Raid Tools")
        InterfaceOptionsFrame_OpenToCategory("Titan Panel: Raid Tools")
    end
end

function TitanPanelRaidToolsButton_OnLoad(self)
    self.registry = {
        id = ID,
        category = "Combat",
        menuText = "Raid Tools",
        buttonTextFunction = "TitanPanelRaidToolsButton_GetButtonText",
        tooltipTitle = "Raid Tools",
        tooltipTextFunction = "TitanPanelRaidToolsButton_GetTooltipText",
        icon = "Interface\\AddOns\\TitanPanel_RaidTools\\media\\icon",
        iconWidth = 16,
        savedVariables = {
            ShowIcon = 1,
            ShowLabelText = 1,
            ShowColoredText = 1,
        },
    }

    TitanPanelButton_OnLoad(self)
end

function TitanPanelRaidToolsButton_OnEvent(self, event, ...)
end

function TitanPanelRaidToolsButton_OnUpdate(self, elapsed)
end
