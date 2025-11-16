ActiveSeed = nil

--- @param seedName string | nil
function SetActiveSeed(seedName)
    if not seedName then
         if ActiveSeed and ActiveSeed.Unequip then
              ActiveSeed:Unequip()
         end
         ActiveSeed = nil
        Info("You put away your seed")
        return
    end

    local plantData = PlantRegistry:Get(seedName)
    if not plantData then
         Logger:Error(("No plant data found for seed: %s"):format(seedName))
         return
    end

    if ActiveSeed and ActiveSeed.Unequip then
         ActiveSeed:Unequip()
    end

    local seedClass = SeedRegistry:Get(seedName)
    if not seedClass then
         Logger:Warning(("Seed '%s' not registered, useing SeedBase."):format(seedName))
         local SeedBase = require("client.seeds.SeedBase")
         seedClass = SeedBase
    end

    local seed = seedClass:new(seedName)

    TriggerEvent("mate-gardening:UnequipAll", seed)

    ActiveSeed = seed
    if ActiveSeed and ActiveSeed.Equip then
         ActiveSeed:Equip()
    end

    Info(("Equipped seed: %s"):format(seedName))
end

function GetActiveSeed()
    return ActiveSeed
end

exports("handle_seed", function(data, slot, _)
    local registryName = data.client and data.client.plantData and data.client.plantData.name
    if not registryName then return end

    local active = GetActiveSeed()

    if active and active.name == registryName then
        SetActiveSeed(nil)
        return
    end

    SetActiveSeed(registryName)
end)
