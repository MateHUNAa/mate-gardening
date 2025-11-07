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
                         Logger:Info("Registered plant: " .. plantData.name)
                    end

               end
          end
     end
end

function LoadGardenTools()
     for item,data in pairs(inv:Items()) do
          if data and data.client then
               local cData = data.client

               if cData.mGardening and cData.toolData then
                    local toolData = cData.toolData
                    local action = toolData.action or "none"

                    local toolClass = ToolRegistry:GetClass(action) or ToolBase
                    local tool = toolClass:new(toolData.name)

                    tool.action = toolData.action
                    tool.actionTime = toolData.actionTime or 1500
                    tool.uses = toolData.uses or 10

                    ToolRegistry:Register(tool.name, tool)
                    Logger:Info(("Registered tool: %s (action=%s)"):format(tool.name, tool.action))
               end
          end
     end
end

Citizen.CreateThread(function (threadId)
     while not ESX.IsPlayerLoaded() do
          Wait(250)
     end

     LoadGardenItems()
     LoadGardenTools()

	local garden = Garden:new(pos.xyz, 5,5)

     while true do
          Wait(0)
          garden:update()
	end
end)
