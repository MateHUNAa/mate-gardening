

local pos = vec4(53.0448, -1894.7394, 21.6000-0.9, 52.7274)

function LoadGardenItems()
     if not inv or not inv.Items then
          Logger:Error("ox_inventory not found, skipping garden items loading.")
          return
     end

     for item, data in pairs(inv:Items()) do
          if data and data.client then
               local cData = data.client

               if cData.mGardening then

                    --- @type PlantData
                    local plantData = cData.plantData

                    if plantData and plantData.name then
                         PlantRegistry:Register(plantData.name, plantData)
                         Logger:Info("Registered plant: " .. plantData.name, plantData)
                    else
                         Logger:Error(("Skipped ^s (missing planyData or name)"):format(item))
                    end

               end
          end
     end
end

Citizen.CreateThread(function (threadId)
     while not ESX.IsPlayerLoaded() do
          Wait(250)
     end
     LoadGardenItems()

	local garden = Garden:new(pos.xyz, 5,5)

     while true do
          Wait(0)
          garden:update()
	end
end)
