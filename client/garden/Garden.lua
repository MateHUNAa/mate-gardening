Garden = {}
Garden.__index = Garden


--- @param center Vector3
--- @param rows number
--- @param cols number
function Garden:new(center, rows, cols)
     local self = setmetatable({}, Garden)

     local size = Config.Grid.cellSize or 0.8
     self.grid = Grid:new(center, rows or 5, cols or 5, size, size, 0.0)
     self.plants = {}


     self.grid.onClick = (function (cell, button)
          self:OnCellClick(cell, button)
     end)

     return self
end


--- @param cell Cell
--- @param button number
function Garden:OnCellClick(cell, button)
     --- @type Plant
     local exists = self.plants[("%s_%s"):format(cell.row, cell.col)]

     if not exists then
          local seed  = GetActiveSeed()
          if not seed then
               Info("Select a seed before planting.")
               return
          end
          self:PlantSeed(seed, cell)
     end

     local tool = ToolRegistry:Get(ActiveTool or "UnknownTool")

     if tool then
          tool:OnUse(self, cell)
     end
end


function Garden:PlantSeed(seedId, cell)
     local plant = Plant:new(seedId, self, cell)
     if not plant then
          Logger:Error("[PlantSeed]: Failed to create plant")
          return false
     end

     self.plants[("%s_%s"):format(cell.row,cell.col)] = plant

     Logger:Info(("Planted %s at %s"):format(seedId, json.encode(cell)))

     return plant
end

function Garden:update()
     self.grid:update()

     for _,plant in pairs(self.plants) do
          if plant then
               plant:update()
          end
     end
end

--- @param cell Cell
function Garden:GetPlant(cell)
     local plant = self.plants[("%s_%s"):format(cell.row, cell.col)]

     return plant or nil
end

function Garden:DestroyPlant(cell)
     local plant = self:GetPlant(cell)

     if not plant then
          Logger:Error("No plant to Destroy")
          return
     end

     plant:Destroy()
     self.plants[("%s_%s"):format(cell.row, cell.col)] = nil
end
