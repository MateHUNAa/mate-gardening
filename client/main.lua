local pos = vec4(53.0448, -1894.7394, 21.6000-0.9, 52.7274)

Logger:SuppressLog("plantStatus") -- PlantStatus change logs
Logger:SuppressLog("g-init") -- Garden Initialization logs
Logger:SuppressLog("Plant:SpawnModel") -- Garden Initialization logs

Citizen.CreateThread(function (threadId)
     while not ESX.IsPlayerLoaded() do
          Wait(250)
     end

     LoadGardenItems()
     LoadGardenTools()
     LoadGardenMaterials()

	local garden = Garden:new(pos.xyz, 5,5)
	-- Wrong Impl, remove later
	Garden.activeGarden = garden
    	garden.dui = lib.dui:new({
          url = ("nui://%s/html/index.html"):format(cache.resource),
          width = 512,
          height = 512,
     })

     Wait(150)

     garden.dui:sendMessage({
          action = "buildGrid",
          data = {
               rows = garden.grid.rows,
               cols = garden.grid.cols
          }
     })

     garden.dui:sendMessage({
          action = "toggleGrid",
          data = true
     })

     while true do
          Wait(0)
          garden:update()
	end
end)


function LoadGardenMaterials()
     if not inv or not inv.Items then
          Logger:Error("ox_inventory not found, skipping garden materials loading.")
          return
     end

     for item, data in pairs(inv:Items()) do
          local cData = data.client

          if not cData then
               goto continue
          end

          if not cData.mGardening or not cData.materialData or next(cData.materialData) == nil then
               goto continue
          end

          local matData = cData.materialData
          local matName = matData.name or item

          local matClass = MaterialRegistry:GetClass(matName)
          if not matClass then
               Logger:Warn(("No material class found for '%s'"):format(matName))
               goto continue
          end

          local material = matClass:new(matName)
          material.actionTime = matData.actionTime or 1000

          MaterialRegistry:Register(matName, material)
          Logger:Info(("Loaded material '%s'"):format(matName), {lSettings = { id = "g-init"}})


          ::continue::
     end
end

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
                         Logger:Info("Registered plant: " .. plantData.name, {lSettings = {id = "g-init"}})

                         -- Register seed
                         local SeedBase = require("client.seeds.SeedBase")

                         if not SeedRegistry:Get(plantData.name) then
                              local seed = SeedBase:new(plantData.name)
                              seed.name = plantData.name
                              seed.model = plantData.model
                              seed.growthTime = plantData.growthTime
                              seed.stages = plantData.stages
                              seed.yield = plantData.yield

                              SeedRegistry:Register(plantData.name, SeedBase)
                              Logger:Info(("Registered seed: %s"):format(plantData.name), {lSettings = {id = "g-init"}})
                         end
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
                    Logger:Info(("Registered tool: %s (action=%s)"):format(tool.name, tool.action) , {lSettings = {id = "g-init"}})
               end
          end
     end
end
