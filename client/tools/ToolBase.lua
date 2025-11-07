ToolBase = {}
ToolBase.__index = ToolBase


function ToolBase:new(name)
     local self = setmetatable({}, ToolBase)
     self.name = name
     self.action = "none"
     self.range = 1.0
     self.actionTime = 1000
     self.uses = 15

     self.prop = nil


     self.inAnim = false
     self.ptfxLoaded = false

     return self
end

--- @param garden Garden
--- @param cell Cell
function ToolBase:OnUse(garden, cell)
     Logger:Info(("Used tool: %s (action=%s)"):format(self.name, self.action))

end


function ToolBase:onHolding(garden, cell)
     if self.action == "watering" then
          self:OnWatering(garden, cell)
     elseif self.action == "harvest" then
          self:OnHarvest(garden, cell)
     end
end

function ToolBase:OnHoldComplete(garden, cell)
     local plant = garden:GetPlant(cell)

     if not plant then
          Info("No plant to water")
          return
     end

     if self.uses <= 0 then
          Info("Tool is out of uses")
          return
     end

     plant:Water()
     self.uses = math.max(self.uses - 1, 0)

     Functions.unloadPtfxDict("core")
     self.ptfxLoaded = false

     if self.inAnim then
          self.inAnim = false
          ClearPedTasks(cache.ped)

          Functions.unloadAnimDict(Config.Animations.Watering.dict)
     end
end

function ToolBase:OnHoldCancelled(garden, cell)
     if self.inAnim then
          self.inAnim = false
          ClearPedTasks(cache.ped)

          Functions.unloadAnimDict(Config.Animations.Watering.dict)
     end

     if self.ptfxLoaded then
          Functions.unloadPtfxDict("core")
          self.ptfxLoaded = false
     end
end

function ToolBase:OnWatering(garden, cell)

     local plant = garden:GetPlant(cell)

     if not plant then return end

     if not self.ptfxLoaded then
          Functions.loadPtfxDict("core")
          self.ptfxLoaded = true
     end

     if not self.inAnim then
          Functions.loadAnimDict(Config.Animations.Watering.dict)

          TaskPlayAnim(cache.ped, Config.Animations.Watering.dict, Config.Animations.Watering.anim, 8.0, -8.0, -1, 1, 0, false,false,false)

          self.inAnim = true
     end

     local pos = garden.grid:GetCellWorldPos(cell.row, cell.col)

     UseParticleFxAssetNextCall("core")
     local wSplash = StartParticleFxNonLoopedAtCoord("water_splash_vehicle", pos.x,pos.y,pos.z, 0.0,0.0,0.0, 1.0,false,false,false)

end

function ToolBase:OnHarvest(garden, cell)
     local plant = garden:GetPlant(cell)

     if not plant then
          Info("No plant to harvest")
          return
     end

     plant:Harvest()
end

function ToolBase:Equip()

     if DoesEntityExist(self.prop) then
          Functions.destoryProp(self.prop)
     end

     if self.action == "watering" then
          self.prop = Functions.makeProp({
               coords =  vec4(0,0,0,0),
               prop = Config.Props.WateringCan.model
          }, false, true)

          DisableCamCollisionForEntity(self.prop)

          AttachEntityToEntity(self.prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.32, 0, -0.15, 260,0,0, true, true, false, false, 1, true)

     elseif self.action == "harvest" then
          self.prop = Functions.makeProp({
               coords =  vec4(0,0,0,0),
               prop = "prop_paper_bag_small"
          }, false, true)

          DisableCamCollisionForEntity(self.prop)

          AttachEntityToEntity(self.prop, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.32, 0, -0.15, 260,0,0, true, true, false, false, 1, true)

     end

end

function ToolBase:Unequip()
     ActiveTool= nil
     if DoesEntityExist(self.prop) then
          Functions.destoryProp(self.prop)
     end

     ClearPedTasks(cache.ped)
end
