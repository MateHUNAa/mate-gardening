ActiveTool = nil

function OnEquipTool(itemName)
     local tool = ToolRegistry:Get(itemName)

     if tool then
          if ActiveTool == itemName then
               ActiveTool = nil
               Logger:Info("Tool unequipped !")
               return
          end

          ActiveTool = itemName
          ActiveSeed = nil
          Logger:Info("Equipped tool: ", itemName)
     else
          Logger:Warning("Tool not registered:", itemName)
     end
end

exports("handle_tool", function (data,slot)
     OnEquipTool(data.client.toolData.name)
end)
