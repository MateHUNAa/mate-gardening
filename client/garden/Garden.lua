Garden = {}
Garden.__index = Garden


--- @param center Vector3
--- @param rows number
--- @param cols number
function Garden:new(center, rows, cols)
     local self = setmetatable({}, Garden)

     Logger:Debug(Config)

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
     local exists = self.plants[("%s_%s"):format(cell.row, cell.col)]

     if not exists then
          self:PlantSeed("tomato", cell)
     else
          Logger:Info("Plant already here: ", exists.id, "Stage: ", exists.stage)
     end
end


function Garden:PlantSeed(seedId, cell)
     local plant = Plant:new(seedId, cell)
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
