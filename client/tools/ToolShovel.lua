local ToolBase = require("client.tools.ToolBase")
ToolShovel = setmetatable({}, { __index = ToolBase })
ToolShovel.__index = ToolShovel

function ToolShovel:new()
    local self = ToolBase.new(self, "shovel")
    setmetatable(self, ToolShovel)
    self.action = "dig"

    self.digging = false
    self.prop = false

    self.ptfxLoaded = false
    self.inAnim = false
    return self
end

function ToolShovel:OnHolding(garden, cell, progress)
     garden.grid.holdDuration = self.actionTime

     local plant = garden:GetPlant(cell)

     if not plant then
          garden.grid:resetHold()
          return Error(lang["error"]["no_plant"])
     end

     local plantPos = plant:GetWorldPosition(false)
     local dist = #(GetEntityCoords(cache.ped) - plantPos)

     print(dist)
     if dist > 1.3 then
          Citizen.CreateThread((function ()
               Functions.MoveTo(plant:GetWorldPosition(false))
          end))
          garden.grid:resetHold()
          Logger:Debug("Reseting hold")
          self:OnHoldCancelled()
          return
     end

     if not self.inAnim then
          Functions.loadAnimDict(Config.Animations.Dig.dict)

          TaskPlayAnim(cache.ped, Config.Animations.Dig.dict, Config.Animations.Dig.anim, 8.0, -8.0, -1, 1, 0, false,false,false)

          self.inAnim = true
     end
end

function ToolShovel:OnHoldCancelled()
     if self.inAnim then
          self.inAnim = false
          ClearPedTasks(cache.ped)

          Functions.unloadAnimDict(Config.Animations.Dig.dict)
     end

      if self.ptfxLoaded then
          Functions.unloadPtfxDict("core")
          self.ptfxLoaded = false
     end
end

function ToolShovel:OnHoldComplete(garden, cell)
     self.uses = math.max(self.uses - 1, 0)

     Functions.unloadPtfxDict("core")
     self.ptfxLoaded = false

     if self.inAnim then
          self.inAnim = false
          ClearPedTasks(cache.ped)

          Functions.unloadAnimDict(Config.Animations.Dig.dict)
     end

     garden:DestroyPlant(cell)
end

function ToolShovel:Equip()
     if DoesEntityExist(self.prop) then
          Functions.destoryProp(self.prop)
     end

     self.prop = Functions.makeProp({
          prop = Config.Props.Shovel.model,
          coords = vec4(0,0,0,0)
     }, false,true)

     AttachEntityToEntity(self.prop, cache.ped, GetPedBoneIndex(cache.ped, 28422),
          0,0,0.24,
          0,0,0,
          false, true, false, true, 1, true)
end

function ToolShovel:Unequip()
     if DoesEntityExist(self.prop) then
          Functions.destoryProp(self.prop)
     end
     ClearPedTasks(cache.ped)
end

return ToolShovel
