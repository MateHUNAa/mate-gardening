ActiveTool = nil
ActiveToolName = nil

--- Equip or unequip a tool by name.
---@param itemName string
function OnEquipTool(itemName)
    local tool = ToolRegistry:Get(itemName)

    if not tool then
        Logger:Warning(("Tool not registered: %s"):format(itemName))
        return
    end


    if ActiveToolName == itemName then
        if ActiveTool and ActiveTool.Unequip then
            ActiveTool:Unequip(Garden:GetActiveGarden())
        end
        ActiveTool = nil
        ActiveToolName = nil
        return
    end

    TriggerEvent("mate-gardening:UnequipAll", tool)

    if ActiveTool and ActiveTool.Unequip then
        ActiveTool:Unequip()
    end

    ActiveTool = tool
    ActiveToolName = itemName

    if ActiveTool.Equip then
        ActiveTool:Equip()
    end

    if ActiveSeed and ActiveSeed.Unequip then
         ActiveSeed:Unequip()
    end

    -- Logger:Info(("Equipped tool: %s"):format(itemName))
end

exports("handle_tool", function(data, slot)
    if data and data.client and data.client.toolData and data.client.toolData.name then
        OnEquipTool(data.client.toolData.name)
    else
        Logger:Warning("Invalid tool data received")
    end
end)
