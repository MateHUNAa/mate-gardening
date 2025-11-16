local MaterialBase = require("client.materials.MaterialBase")
local MaterialDirt = setmetatable({}, MaterialBase)
MaterialDirt.__index = MaterialDirt

function MaterialDirt:new()
     local self = MaterialBase:new("dirt")
     self.actionTime = 1000
     self.applying = false
     return setmetatable(self, MaterialDirt)
end

function MaterialDirt:OnApply(garden, cell)
     local cellPos = garden.grid:GetCellWorldPos(cell.row, cell.col) + vec3(0,0,-1)

     self.applying = true

     Functions.MoveTo(cellPos + vec(0,0,1))

     Citizen.CreateThread(function()
          Functions.loadPtfxDict(Config.Ptfx.Dirt.dict)

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
                    local pos = GetOffsetFromEntityInWorldCoords(foundEntity, 0.12, 0.13, -0.12)

                    local xRot, yRot, zRot = RotationToFace(pos, cellPos)

                    local wSplash = StartParticleFxLoopedAtCoord(
                         Config.Ptfx.Dirt.effect,
                         pos.x, pos.y, pos.z,
                         xRot, yRot, zRot,
                         1.0,
                         false, false, false, false
                    )

                    Citizen.Wait(150)
                    StopParticleFxLooped(wSplash, false)
               end
          end
     end)


     Functions.PlayAnimation(PlayerPedId(), {
          dict = "weapons@misc@jerrycan@",
          anim = "fire",
          props = {
               {
                    model = "prop_feed_sack_01",
                    bone = 57005,
                    coords = vector3(0.12, 0.13, -0.12),
                    rotation = vector3(-165.869, -11.212, -32.945)
               }
          },
     }, function()
          garden:PlantDirt(cell)
          Logger:Info(("Applied dirt to cell [%s,%s]"):format(cell.row, cell.col))
          self.applying = false
          Functions.unloadPtfxDict(Config.Ptfx.Dirt.dict)
     end)
end


function RotationToFace(start, dest)
     local dx = dest.x - start.x
     local dy = dest.y - start.y
     local dz = dest.z - start.z

     local dist = math.sqrt(dx * dx + dy * dy + dz * dz)
     if dist == 0 then return 0.0, 0.0, 0.0 end

     dx          /= dist
     dy          /= dist
     dz          /= dist

     local yaw   = math.atan2(dy, dx) * 180.0 / math.pi
     local pitch = -math.atan2(dz, math.sqrt(dx * dx + dy * dy)) * 180.0 / math.pi

     return pitch, 0.0, yaw
end

return MaterialDirt
