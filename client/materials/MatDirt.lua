local MaterialBase = require("client.materials.MaterialBase")
local MaterialDirt = setmetatable({}, MaterialBase)
MaterialDirt.__index = MaterialDirt

Logger:SuppressLog("material_dirt")

function MaterialDirt:new()
     local self = MaterialBase:new("dirt")
     self.actionTime = 1000
     self.applying = false
     return setmetatable(self, MaterialDirt)
end

function MaterialDirt:DrawParticle(cellPos)
     Citizen.CreateThread(function()
          local ptfxLoaded = Functions.loadPtfxDict(Config.Ptfx.Dirt.dict)
          if not ptfxLoaded then
               self.applying = false
               Logger:Error("Failed to load particle effect dictionary")
               return
          end

          local function FindAttachedEntity(ped, model)
               local coords = GetEntityCoords(ped)
               model = GetHashKey(model)

               for _, obj in ipairs(GetGamePool('CObject')) do
                    if GetEntityModel(obj) == model then
                         if IsEntityAttachedToEntity(obj, ped) then
                              return obj
                         end
                    end
               end
               return nil
          end

          local foundEntity = nil

          while self.applying do
               UseParticleFxAssetNextCall(Config.Ptfx.Dirt.dict)

               if not foundEntity then
                    local entity = FindAttachedEntity(cache.ped, Config.Props.Dirt.model)
                    if entity then
                         foundEntity = entity
                    end
               end

               if foundEntity then

                    local pos = GetOffsetFromEntityInWorldCoords(foundEntity, 0.0,0.0,0.7)

                    local wSplash = StartParticleFxLoopedAtCoord(
                         Config.Ptfx.Dirt.effect,
                         pos.x, pos.y, pos.z,
                         180.0, 0.0, 0.0,
                         2.0,
                         false, false, false, false
                    )

                    Citizen.Wait(150)
                    StopParticleFxLooped(wSplash, false)
               end
          end
     end)
end

function MaterialDirt:OnApply(garden, cell)
     local cellPos = garden.grid:GetCellWorldPos(cell.row, cell.col)

     local dist = #(GetEntityCoords(cache.ped) - cellPos)

     if dist >= 1.3 then
          Citizen.CreateThread(function()
               Functions.MoveTo(cellPos)
          end)
     end

     while dist >= 1.3 do
          Citizen.Wait(0)
          dist = #(GetEntityCoords(cache.ped) - cellPos)
     end

     self.applying = true

     local prop = Functions.makeProp({
          prop = Config.Props.Dirt.model,
          coords = vec4(0,0,0,0)
     }, false, true)

     AttachEntityToEntity(prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.12, 0.13, -0.12, -165.869, -11.212, -32.945, true, true, false, true, 1, true)

     self:DrawParticle(cellPos)

      if Functions.progressBar({
          time = self.actionTime,
          label = lang["info"]["applying_dirt"],
          dict = Config.Animations.Dirt.dict,
          anim = Config.Animations.Dirt.anim
     }) then
          garden:PlantDirt(cell)
          Logger:Info(("Applied dirt to cell [%s,%s]"):format(cell.row, cell.col), {lSettings = {
               id = "material_dirt",
               prefixes = {"Material"},
               subPrefix = "DIRT"
          }})
          self.applying = false
          Functions.unloadPtfxDict(Config.Ptfx.Dirt.dict)
          Functions.destoryProp(prop)
      end

end

return MaterialDirt
