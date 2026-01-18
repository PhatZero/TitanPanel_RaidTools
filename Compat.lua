local addonName, ns = ...

ns.Compat = ns.Compat or {}

function ns.Compat.OpenOptions(categoryName)
    categoryName = categoryName or "Raid Tools"
    if Settings and Settings.OpenToCategory then
        Settings.OpenToCategory(categoryName)
        return
    end
    if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory(categoryName)
        InterfaceOptionsFrame_OpenToCategory(categoryName)
        return
    end
    print("|cffffd100[RaidTools]|r Unable to open options on this client.")
end

function ns.Compat.HasWorldMarkers()
    return type(PlaceRaidMarker) == "function" and type(ClearRaidMarker) == "function"
end
