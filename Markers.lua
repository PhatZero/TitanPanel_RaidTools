local addonName, ns = ...

local Markers = {}
ns.Markers = Markers

local frame

-- Create the draggable Raid Tools frame with secure marker + ready check buttons
function Markers:CreateFrame()
    if frame then return end

    -- Main container
    frame = CreateFrame("Frame", "TPRT_RaidToolsFrame", UIParent, "BackdropTemplate")
    frame:SetSize(230, 150)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetFrameStrata("MEDIUM")

    frame:SetBackdrop({
        bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })

    frame:Hide()

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOP", 0, -6)
    title:SetText("Raid Tools")

    -- Close button
    local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    ------------------------------------------------------------
    -- Ready Check secure button
    ------------------------------------------------------------
    local rcButton = CreateFrame("Button", "TPRT_ReadyCheckButton", frame,
        "SecureActionButtonTemplate,UIPanelButtonTemplate")
    rcButton:SetSize(100, 22)
    rcButton:SetPoint("TOPLEFT", 10, -26)
    rcButton:SetText("Ready Check")
    rcButton:SetAttribute("type", "macro")
    rcButton:SetAttribute("macrotext", "/readycheck")

    ------------------------------------------------------------
    -- World marker secure buttons (1-8) using /wm X
    ------------------------------------------------------------
    local labels = { "★", "●", "◆", "▲", "☽", "■", "✚", "☠" }

    for i = 1, 8 do
        local btn = CreateFrame("Button", "TPRT_WorldMarker"..i, frame,
            "SecureActionButtonTemplate,UIPanelButtonTemplate")
        btn:SetSize(24, 24)
        local row = math.floor((i - 1) / 4)
        local col = (i - 1) % 4
        btn:SetPoint("TOPLEFT", 10 + col * 28, -56 - row * 28)
        btn:SetText(labels[i] or tostring(i))
        btn:SetAttribute("type", "macro")
        btn:SetAttribute("macrotext", "/wm "..i)
    end

    -- Clear world markers button
    local clearBtn = CreateFrame("Button", "TPRT_ClearWorldMarkersButton", frame,
        "SecureActionButtonTemplate,UIPanelButtonTemplate")
    clearBtn:SetSize(120, 22)
    clearBtn:SetPoint("BOTTOM", 0, 10)
    clearBtn:SetText("Clear Markers")
    clearBtn:SetAttribute("type", "macro")
    clearBtn:SetAttribute("macrotext", "/cwm 0")
end

function Markers:ToggleFrame()
    if not frame then
        self:CreateFrame()
    end

    if InCombatLockdown() then
        print("|cffff4040[RaidTools]|r Cannot open Raid Tools while in combat.")
        return
    end

    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
    end
end
