ToolBase = {}
ToolBase.__index = ToolBase

--- @alias ToolAction "watering" | "fertilizing" | "pruning" | "harvest"

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

     if plant then
          plant:Water()
     end
end

function ToolBase:OnHarvest(garden, cell)
     Logger:Info(("Harvesting cell: %s"):format(cell.id))
end
