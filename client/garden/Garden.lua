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

     self.grid.onHolding = function (cell, progress)
          self:OnCellHolding(cell, progress)
     end

     self.grid.onHoldComplete = function (cell)
          self:OnCellHoldComplete(cell)
     end

     self.grid.onHoldCancelled = function (cell)
          self:OnCellHoldCancelled(cell)
     end

     return self
end


--- @param cell Cell
--- @param button number
function Garden:OnCellClick(cell, button)
     local plant = self:GetPlant(cell)

     if not plant then
          local seed = GetActiveSeed()

          if not seed then
               return Info(lang["info"]["need_seed_for_plant"])
          end

          if not seed.OnPlant then
               return Logger:Error(("Seed '%s' does not implement OnPlant()"):format(seed.name or "UnknownSeed"))
          end

          seed:OnPlant(self, cell)
          return
     end

     if ActiveTool then
          if ActiveTool.OnUse then
               ActiveTool:OnUse(self, cell)
          else
               Logger:Warning(("Tool '%s' does not implement OnUse()"):format(ActiveTool.name))
          end
     else
          Info(lang["info"]["no_active_tool"])
     end
end

function Garden:OnCellHoldComplete(cell)
     if ActiveTool then
          ActiveTool:OnHoldComplete(self, cell)
     end
end

function Garden:OnCellHolding(cell, progress)
     if ActiveTool then
          ActiveTool:OnHolding(self, cell, progress)
     end
end

function Garden:OnCellHoldCancelled(cell)
     if ActiveTool then
          ActiveTool:OnHoldCancelled(self, cell)
     end
end


function Garden:PlantSeed(seedId, cell)
     local exists = self:GetPlant(cell)
     if exists then
          Logger:Debug(("Seed already planted at %s"):format(json.encode(cell)))
          Error(lang["error"]["seed_already_planted"])
          return false
     end

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

     return plant or false
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
