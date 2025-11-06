

local pos = vec4(53.0448, -1894.7394, 21.6000-0.9, 52.7274)

function LoadGardenItems()
     for item, data in pairs(inv:Items()) do
          if data and data.client then
               local cData = data.client

               if cData.mGardening then

                    --- @type Plant
                    local plantData = cData.plantData

                    PlantRegistry:Register(plantData.name, plantData)
                    Logger:Info("Registered plant: " .. plantData.name, plantData)
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
