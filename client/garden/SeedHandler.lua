ActiveSeed = nil

--- @param seedName string | nil
function SetActiveSeed(seedName)
    if not seedName then
        ActiveSeed = nil
        Info("You put away your seed")
        return
    end

    local item = inv:Items(seedName)
    if not item then
        Logger:Error(("No seed found with name: %s"):format(seedName))
        ActiveSeed = nil
        return
    end

    local plantData = item.client and item.client.plantData
    local registryName = plantData and plantData.name or nil

    if not registryName then
        Logger:Error(("Seed '%s' has no valid plantData"):format(seedName))
        ActiveSeed = nil
        return
    end

    if ActiveSeed == registryName then
        ActiveSeed = nil
        Info("You put away your seed")
    else
        ActiveSeed = registryName
        ActiveTool = nil
        Info(("Equipped: %s"):format(item.label))
    end
end

function GetActiveSeed()
    return ActiveSeed
end

exports("handle_seed", function(data, slot, _)
    local registryName = data.client and data.client.plantData and data.client.plantData.name
    if not registryName then return end

    if GetActiveSeed() == registryName then
        SetActiveSeed(nil)
    else
        SetActiveSeed(data.name)
    end
end)
