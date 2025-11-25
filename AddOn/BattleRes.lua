local addonName, ns = ...

local BR = {}
ns.BR = BR

BR.charges = 0
BR.maxCharges = 0
BR.cooldownRemaining = 0
BR.cooldownDuration = 0

function BR:Refresh()
    local charges, maxCharges, start, duration = C_Encounter.GetBattleResurrections()
    if not charges or not maxCharges then
        self.charges = 0
        self.maxCharges = 0
        self.cooldownRemaining = 0
        self.cooldownDuration = 0
        return
    end

    self.charges = charges
    self.maxCharges = maxCharges
    self.cooldownDuration = duration or 0

    if start and duration and duration > 0 then
        local ends = start + duration
        local remaining = ends - GetTime()
        self.cooldownRemaining = remaining > 0 and remaining or 0
    else
        self.cooldownRemaining = 0
    end
end

local function FormatTime(seconds)
    seconds = math.floor(seconds or 0)
    if seconds <= 0 then
        return "0s"
    end
    if seconds < 60 then
        return seconds .. "s"
    end
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    if s > 0 then
        return string.format("%dm %ds", m, s)
    else
        return string.format("%dm", m)
    end
end

function BR:GetCharges()
    self:Refresh()
    return self.charges, self.maxCharges
end

function BR:GetCooldown()
    self:Refresh()
    return self.cooldownRemaining, self.cooldownDuration
end

function BR:GetDisplayText()
    self:Refresh()

    local mode = (ns.db and ns.db.DisplayMode) or "SMART"
    local charges, maxCharges = self.charges, self.maxCharges
    local cdRemaining = self.cooldownRemaining

    if maxCharges == 0 then
        return "B-Rez: N/A"
    end

    local base = string.format("B-Rez: %d/%d", charges, maxCharges)

    if mode == "CHARGES" then
        return base
    elseif mode == "COOLDOWN" then
        if cdRemaining > 0 then
            return string.format("%s (%s)", base, FormatTime(cdRemaining))
        else
            return base .. " (Ready)"
        end
    else -- SMART
        if charges >= maxCharges or cdRemaining <= 0 then
            return base
        else
            return string.format("%s (%s)", base, FormatTime(cdRemaining))
        end
    end
end

function BR:GetTooltipLines()
    self:Refresh()
    local charges, maxCharges = self.charges, self.maxCharges
    local cdRemaining, cdDuration = self.cooldownRemaining, self.cooldownDuration

    local lines = {}

    if maxCharges == 0 then
        table.insert(lines, "|cffffd100Battle Resurrections|r")
        table.insert(lines, "Not active for this encounter or instance.")
        return lines
    end

    table.insert(lines, "|cffffd100Battle Resurrections|r")
    table.insert(lines, string.format("Charges: |cffffffff%d|r / |cffffffff%d|r", charges, maxCharges))

    if cdDuration and cdDuration > 0 then
        table.insert(lines, string.format("Recharge: |cffffffff%s|r", FormatTime(cdDuration)))
    end

    if cdRemaining and cdRemaining > 0 then
        table.insert(lines, string.format("Next charge in: |cffffffff%s|r", FormatTime(cdRemaining)))
    else
        table.insert(lines, "Next charge: |cffffffffReady|r")
    end

    return lines
end

local f = CreateFrame("Frame")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

f:SetScript("OnEvent", function()
    BR:Refresh()
end)
