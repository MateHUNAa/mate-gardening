ActiveSeed = ""

--- @param seedName string
function SetActiveSeed(seedName)
     local item = inv:Items(seedName)
     local registryName = item.client.plantData.name

     if not item then
          Logger:Error(("No seed found with name: %s"):format(seedName))
          return
     end


     if ActiveSeed and ActiveSeed ~= registryName then
          Info(("Equipped: %s"):format(item.label))
     else
          Info("You put away your seed")
          ActiveSeed = nil
          return
     end

     ActiveSeed = registryName
end


function GetActiveSeed()
	return ActiveSeed
end


exports("handle_seed", function (data, slot, _ )
     if GetActiveSeed() == data.name then
          SetActiveSeed(nil)
     else
          SetActiveSeed(data.name)
     end
end)
