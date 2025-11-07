ActiveTool = nil

function OnEquipTool(itemName)
     local tool = ToolRegistry:Get(itemName)

     if tool then
          if ActiveTool == itemName then
               ActiveTool = nil
               Logger:Info("Tool unequipped !")
               tool:Unequip()
               return
          end

          ActiveTool = itemName
          ActiveSeed = nil
          Logger:Info("Equipped tool: ", itemName)
          tool:Equip()
     else
          Logger:Warning("Tool not registered:", itemName)
     end
end

exports("handle_tool", function (data,slot)
     OnEquipTool(data.client.toolData.name)
end)
