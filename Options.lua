local addonName, ns = ...

local panel = CreateFrame("Frame", "TitanPanelRaidToolsOptionsPanel")
panel.name = "Titan Panel: Raid Tools"

local function GetDisplayMode()
    return (ns.db and ns.db.DisplayMode) or "SMART"
end

local function SetDisplayMode(mode)
    if ns.db then
        ns.db.DisplayMode = mode
    end
    if TitanPanelButton_UpdateButton then
        TitanPanelButton_UpdateButton("RaidTools")
    end
end

panel:SetScript("OnShow", function(self)
    if self.initialized then return end
    self.initialized = true

    local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 16, -16)
    title:SetText("Titan Panel: Raid Tools")

    local subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText("Configure how Battle Res info is displayed on the Titan Panel button.")

    local dropdown = CreateFrame("Frame", "TitanPanelRaidToolsDisplayModeDropDown", self, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", -16, -24)

    local label = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("BOTTOMLEFT", dropdown, "TOPLEFT", 16, 3)
    label:SetText("Display Mode")

    UIDropDownMenu_Initialize(dropdown, function(frame, level, menuList)
        local function AddOption(text, value)
            local info = UIDropDownMenu_CreateInfo()
            info.text = text
            info.value = value
            info.func = function()
                SetDisplayMode(value)
                UIDropDownMenu_SetSelectedValue(dropdown, value)
            end
            info.checked = (GetDisplayMode() == value)
            UIDropDownMenu_AddButton(info)
        end

        AddOption("Charges Only (B-Rez: X/Y)", "CHARGES")
        AddOption("Charges + Cooldown", "COOLDOWN")
        AddOption("Smart Auto (default)", "SMART")
    end)

    UIDropDownMenu_SetWidth(dropdown, 220)
    UIDropDownMenu_SetSelectedValue(dropdown, GetDisplayMode())
    UIDropDownMenu_JustifyText(dropdown, "LEFT")
end)

panel.okay = function() end
panel.cancel = function() end

if InterfaceOptions_AddCategory then
    InterfaceOptions_AddCategory(panel)
end
