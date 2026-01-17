
local addonName, ns = ...

local BR = {}
ns.BR = BR

BR.charges = 0
BR.maxCharges = 0
BR.cooldownRemaining = 0
BR.cooldownDuration = 0
BR.source = "NONE"
BR.spellName = nil

------------------------------------------------------
-- Retail spell-charge API wrappers (War Within)
------------------------------------------------------
local function RetailGetCharges(spellID)
    if C_Spell and C_Spell.GetSpellCharges then
        local charges, maxCharges, start, duration = C_Spell.GetSpellCharges(spellID)
        return charges, maxCharges, start, duration
    end
    return nil, nil, nil, nil
end

local function RetailGetCooldown(spellID)
    if C_Spell and C_Spell.GetSpellCooldown then
        local start, duration = C_Spell.GetSpellCooldown(spellID)
        return start, duration
    end
    return nil, nil
end

local function RetailGetSpellName(spellID)
    if C_Spell and C_Spell.GetSpellInfo then
        local info = C_Spell.GetSpellInfo(spellID)
        if info and info.name then
            return info.name
        end
    end
    return "Battle Rez"
end

------------------------------------------------------
-- Time formatting
------------------------------------------------------
local function FormatTime(sec)
    sec = math.floor(sec or 0)
    if sec <= 0 then return "0s" end
    if sec < 60 then return sec .. "s" end
    local m = math.floor(sec / 60)
    local s = sec % 60
    if s > 0 then
        return string.format("%dm %ds", m, s)
    else
        return string.format("%dm", m)
    end
end

------------------------------------------------------
-- Battle Rez spell IDs per class
------------------------------------------------------
local CLASS_BREZ_SPELL = {
    DRUID       = 20484,   -- Rebirth
    WARLOCK     = 20707,   -- Soulstone
    DEATHKNIGHT = 61999,   -- Raise Ally
    PALADIN     = 391054,  -- Intercession
}

------------------------------------------------------
-- Refresh logic (Auto mode, War Within safe)
------------------------------------------------------
function BR:Refresh()
    self.charges = 0
    self.maxCharges = 0
    self.cooldownRemaining = 0
    self.cooldownDuration = 0
    self.source = "NONE"
    self.spellName = nil

    --------------------------------------------------
    -- 1) Try raid encounter pool if available
    --------------------------------------------------
    if C_Encounter and C_Encounter.GetBattleResurrections and IsEncounterInProgress() then
        local c, m, start, dur = C_Encounter.GetBattleResurrections()
        if m and m > 0 then
            self.source = "ENCOUNTER"
            self.charges = c or 0
            self.maxCharges = m or 0

            if start and dur and dur > 0 then
                local ends = start + dur
                local remain = ends - GetTime()
                self.cooldownDuration = dur
                self.cooldownRemaining = remain > 0 and remain or 0
            end
            return
        end
    end

    --------------------------------------------------
    -- 2) Fall back to class spell charges
    --------------------------------------------------
    local _, class = UnitClass("player")
    local spellID = CLASS_BREZ_SPELL[class or ""]

    if not spellID then
        -- This class has no battle res at all
        self.source = "NONE"
        return
    end

    local charges, maxCharges, start, duration = RetailGetCharges(spellID)

    --------------------------------------------------
    -- No charges → use cooldown only
    --------------------------------------------------
    if not charges and not maxCharges then
        local cdStart, cdDur = RetailGetCooldown(spellID)
        if cdStart and cdDur and cdDur > 0 then
            self.charges = 0
            self.maxCharges = 1
            self.cooldownDuration = cdDur
            local r = (cdStart + cdDur) - GetTime()
            self.cooldownRemaining = r > 0 and r or 0
        else
            self.charges = 1
            self.maxCharges = 1
        end

        self.source = "CLASS"
        self.spellName = RetailGetSpellName(spellID)
        return
    end

    --------------------------------------------------
    -- Normal charge system
    --------------------------------------------------
    self.charges = charges or 0
    self.maxCharges = maxCharges or 0
    self.source = "CLASS"
    self.spellName = RetailGetSpellName(spellID)

    if start and duration and duration > 0 then
        self.cooldownDuration = duration
        local r = (start + duration) - GetTime()
        self.cooldownRemaining = r > 0 and r or 0
    end
end

------------------------------------------------------
-- Public API for Titan plugin
------------------------------------------------------
function BR:GetDisplayText()
    self:Refresh()

    if self.maxCharges == 0 then
        return "B-Rez: N/A"
    end

    local base = string.format("B-Rez: %d/%d", self.charges, self.maxCharges)

    if self.cooldownRemaining > 0 then
        return string.format("%s (%s)", base, FormatTime(self.cooldownRemaining))
    end

    return base
end

function BR:GetTooltipLines()
    self:Refresh()
    local lines = {}

    if self.maxCharges == 0 then
        table.insert(lines, "|cffffd100Battle Resurrections|r")
        table.insert(lines, "Not available.")
        return lines
    end

    if self.source == "ENCOUNTER" then
        table.insert(lines, "|cffffd100Battle Resurrections (Raid)|r")
    else
        table.insert(lines, string.format("|cffffd100%s|r", self.spellName or "Battle Rez"))
    end

    table.insert(lines, string.format("Charges: %d/%d", self.charges, self.maxCharges))

    if self.cooldownDuration > 0 then
        table.insert(lines, "Recharge: " .. FormatTime(self.cooldownDuration))
    end

    if self.cooldownRemaining > 0 then
        table.insert(lines, "Next charge in: " .. FormatTime(self.cooldownRemaining))
    else
        table.insert(lines, "Next charge: Ready")
    end

    table.insert(lines, "Source: " .. (self.source == "ENCOUNTER" and "Raid encounter pool" or "Class spell charges"))

    return lines
end

------------------------------------------------------
-- Event handler
------------------------------------------------------
local f = CreateFrame("Frame")
f:RegisterEvent("SPELL_UPDATE_CHARGES")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("ENCOUNTER_START")
f:RegisterEvent("ENCOUNTER_END")

f:SetScript("OnEvent", function()
    BR:Refresh()
end)
