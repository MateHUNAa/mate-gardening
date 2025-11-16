ActiveMaterial = nil

exports("handle_material", function(data, slot)
    if not (data and data.client and data.client.materialData and data.client.materialData.name) then
        Logger:Warning("Invalid material data received", {lSettings = {
            id = "material_handleMaterial",
            prefixes = {"handle_material"}
        }})
        return
    end

    local matName = data.client.materialData.name
    local material = MaterialRegistry:Get(matName)

    if not material then
        Logger:Warning(("Material not registered: %s"):format(matName), {lSettings = {
            id = "material_handleMaterial",
            prefixes = {"handle_material"}
        }})
        return
    end

    if ActiveMaterial and ActiveMaterial.name == matName then
        Logger:Info(("Putting away material: %s"):format(matName), {lSettings = {
            id = "material_handleMaterial",
            prefixes = {"handle_material"}
        }})
        ActiveMaterial = nil
        return
    end

    TriggerEvent("mate-gardening:UnequipAll", material)
    ActiveMaterial = material

    Logger:Info(("Equipped material: %s"):format(matName), {lSettings = {
        id = "material_handleMaterial",
        prefixes = {"handle_material"}
    }})
end)
