local addonName, ns = ...

local Markers = {}
ns.Markers = Markers

function Markers:SetRaidMarker(markerID)
    if not UnitExists("target") then
        print("|cffff4040[RaidTools]|r No target selected.")
        return
    end

    if not IsInGroup() then
        print("|cffff4040[RaidTools]|r You must be in a group to set raid icons.")
        return
    end

    if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
        print("|cffff4040[RaidTools]|r Only leader or assist can set raid icons.")
        return
    end

    SetRaidTarget("target", markerID)
end

function Markers:SetWorldMarker(id)
    if not IsInGroup() then
        print("|cffff4040[RaidTools]|r You must be in a group to place world markers.")
        return
    end
    if not IsInRaid() then
        print("|cffff4040[RaidTools]|r World markers require a raid group.")
        return
    end
    if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
        print("|cffff4040[RaidTools]|r Only leader or assist can place world markers.")
        return
    end

    PlaceRaidMarker(id)
end

function Markers:ClearWorldMarkers()
    if not IsInGroup() then
        print("|cffff4040[RaidTools]|r You must be in a group to clear world markers.")
        return
    end
    if not IsInRaid() then
        print("|cffff4040[RaidTools]|r World markers require a raid group.")
        return
    end
    if not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player") then
        print("|cffff4040[RaidTools]|r Only leader or assist can clear world markers.")
        return
    end

    ClearRaidMarker()
end
