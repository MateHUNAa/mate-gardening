local ToolBase = require("client.tools.ToolBase")
ToolHarvest = setmetatable({}, { __index = ToolBase })
ToolHarvest.__index = ToolHarvest

function ToolHarvest:new()
    local self = ToolBase.new(self, "harvester")
    setmetatable(self, ToolHarvest)
    self.action = "harvest"

    self.ptfxLoaded = false
    self.inAnim = false
    self.harvesting = false
    return self
end

--- @param garden Garden
--- @param cell Cell
function ToolHarvest:OnUse(garden, cell)
     if self.harvesting then
          return false
     end

     local plant = garden:GetPlant(cell)
     if not plant then
          return Error(lang["error"]["no_plant"])
     end

     if not plant:isFullyGrown() then
          return Error(lang["error"]["not_fully_grown"])
     end

     Functions.MoveTo(plant:GetWorldPosition(false))

     self.harvesting = true
     if Functions.progressBar({
          label = lang["info"]["harvesting"],
          time = self.actionTime or 2000,
          task = 'WORLD_HUMAN_GARDENER_PLANT'
     }) then
          plant:Harvest()

          ClearPedTasks(cache.ped)
          self.harvesting = false
     end

end


return ToolHarvest
