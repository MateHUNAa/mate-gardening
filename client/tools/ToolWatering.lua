local ToolBase = require("client.tools.ToolBase")
ToolWatering = setmetatable({}, { __index = ToolBase })
ToolWatering.__index = ToolWatering

function ToolWatering:new()
    local self = ToolBase.new(self, "watering_can")
    setmetatable(self, ToolWatering)
    self.action = "watering"


    self.ptfxLoaded = false
    self.inAnim = false
    return self
end

function ToolWatering:Equip()
    self.prop = Functions.makeProp({
        coords = vec4(0,0,0,0),
        prop = Config.Props.WateringCan.model
    }, false, true)

    AttachEntityToEntity(self.prop, cache.ped, GetPedBoneIndex(cache.ped, 57005),
        0.32, 0, -0.15, 260, 0, 0, true, true, false, false, 1, true)
end

function ToolWatering:Unequip()
    if DoesEntityExist(self.prop) then
        Functions.destoryProp(self.prop)
    end
    ClearPedTasks(cache.ped)
end

---@param garden Garden
---@param cell Cell
---@param progress number
function ToolWatering:onHolding(garden, cell, progress)
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

function ToolWatering:OnHoldComplete(garden, cell)
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

function ToolWatering:OnHoldCancelled()
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

return ToolWatering
