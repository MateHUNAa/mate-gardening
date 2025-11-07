ToolBase = {}
ToolBase.__index = ToolBase


function ToolBase:new(name)
     local self = setmetatable({}, ToolBase)
     self.name = name
     self.action = "none"
     self.range = 1.0
     self.actionTime = 1000
     self.uses = 15

     return self
end

--- @param garden Garden
--- @param cell Cell
function ToolBase:OnUse(garden, cell)
     Logger:Info(("Used tool: %s (action=%s)"):format(self.name, self.action))

     if self.action == "watering" then
          self:OnWater(garden, cell)
     elseif self.action == "harvest" then
          self:OnHarvest(garden, cell)
     end
end


function ToolBase:OnWater(garden, cell)
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
end

function ToolBase:OnHarvest(garden, cell)
     local plant = garden:GetPlant(cell)

     if not plant then
          Info("No plant to harvest")
          return
     end

     plant:Harvest()
end
