RegisterNetEvent("mate-gardening:UnequipAll", function(current)

     if ActiveSeed and ActiveSeed ~= current and ActiveSeed.Unequip then
          Logger:Info("Unequipping Seed", {lSettings = {prefixes = {"UnequipHandler"}, id ="EventsUnequipHandler"}})

         ActiveSeed:Unequip()
     end

     if ActiveTool and ActiveTool ~= current and ActiveTool.Unequip then
          Logger:Info("Unequipping Tool", {lSettings = {prefixes = {"UnequipHandler"}, id ="EventsUnequipHandler"}})

         ActiveTool:Unequip(Garden:GetActiveGarden())
     end

     if ActiveMaterial and ActiveMaterial.name ~= current.name then
          Logger:Info("Unequipping material", {lSettings = {prefixes = {"UnequipHandler"}, id ="EventsUnequipHandler"}})
         ActiveMaterial = nil
     end

end)
