Garden = {}
Garden.__index = Garden
Garden.activeGarden = nil

--- @param center Vector3
--- @param rows number
--- @param cols number
function Garden:new(center, rows, cols)
     local self = setmetatable({}, Garden)

     local size = Config.Grid.cellSize or 0.8
     self.grid = Grid:new(center, rows or 5, cols or 5, size, size, 0.0)
     self.worldPos = center
     self.plants = {}
     self.dirt = {}

     self.lastHoveredCell = nil

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

     self.hoverThread = false
     self.grid.onHover = (function(cell)
          if not cell or type(cell) ~= "table" then return end
          if self.hoverThread then return end

          self.hoverThread = true
          Citizen.CreateThread(function()
               self:OnHover(cell)
               Wait(150)
               self.hoverThread = false
          end)
     end)

     self.dui = nil

     return self
end


--- TODO: Removed this in the future, wrong implementation not handeling multiple Grids.
--- Returns the active garden instance.
--- @return Garden
function Garden:GetActiveGarden()
     return Garden.activeGarden
end

function Garden:OnHover(cell)
     if ActiveTool?.action ~= "inspect" or false then
          return
     end

     local function toggleOldStatus()
          if self.lastHoveredCell then
               local oldPlant = self:GetPlant(self.lastHoveredCell)
               if oldPlant then
                    oldPlant:ToggleStatus()
                    self.lastHoveredCell = nil
               end
          end
     end

     if self.lastHoveredCell ~= cell then
          local plant = self:GetPlant(cell)
          if plant then
               plant:ToggleStatus()

               toggleOldStatus()

               self.lastHoveredCell = cell
          else
               toggleOldStatus()
          end
     end
end

--- @param cell Cell
--- @param button number
function Garden:OnCellClick(cell, button)
     local plant = self:GetPlant(cell)
     local hasDirt = self:GetDirt(cell)

     if ActiveMaterial then
          if ActiveMaterial.OnApply then
               ActiveMaterial:OnApply(self, cell)
               return
          end
     end

     if not plant and hasDirt then
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

--- @param cell Cell
function Garden:PlantDirt(cell)
     local dirt = self:GetDirt(cell)

     if dirt then
          Error(lang["error"]["already_dirt"])
          return false
     end

     self.dirt[("%s_%s"):format(cell.row,cell.col)] = true

     local index = (self.grid.rows - 1 - cell.row) * self.grid.cols + cell.col

     self.dui:sendMessage({
       action = "setCell",
       data = {
            index = index,
            useImage = true
       }
     })

     Logger:Info(("Put dirt at %s"):format(json.encode(cell)), {lSettings= {
          id = "put_dirt",
          prefixes = {'DIRT'}
     }})

end

function Garden:PlantSeed(seedId, cell)
     local dirt = self:GetDirt(cell)
     if not dirt then
          Error(lang["error"]["no_dirt"])
          return false
     end

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

function Garden:DrawDUI()
    local pos = self.worldPos
    if not pos then return end

    DrawMarker(
        9,                    -- type: vertical cylinder
        pos.x - 0.2, pos.y - 0.1, pos.z,  -- position
        0.0, 0.0, 0.0,        -- direction
        0.0, 0.0, 0.0,        -- rotation
        (0.9 *5), (0.9 *5), 1,        -- scale (x,y,z)
        255, 255, 255, 255,       -- color RGBA
        false, false, 2, false,       -- bobUpAndDown, faceCamera, rotate
        self.dui.dictName, self.dui.txtName, false        -- texture dictionary/name, drawOnEnts
    )
end


function Garden:update()
     self.grid:update()

     for _,plant in pairs(self.plants) do
          if plant then
               plant:update()
          end
     end

     -- DUI

     if self.dui and next(self.dui) ~= nil  then
          if not self.dui.dictName or not self.dui.txtName then
              return Logger:Error("Missing UI elements for plant status", {lSettings = {id = "dui-missing-elements", prefixes = {"DUI"}}})
          end

          local w,h = 1,1



     end

     self:DrawDUI()
end

--- @param cell Cell
function Garden:GetPlant(cell)
     if not cell then
         return false
     end

     local plant = self.plants[("%s_%s"):format(cell.row, cell.col)]

     return plant or false
end

function Garden:GetDirt(cell)
     if not cell then return false end

     local key = ("%s_%s"):format(cell.row, cell.col)
     return self.dirt[key] or false
end

function Garden:DestroyPlant(cell)
     local plant = self:GetPlant(cell)

     if not plant then
          Logger:Error("No plant to Destroy")
          return
     end

     plant:Destroy()
     self.plants[("%s_%s"):format(cell.row, cell.col)] = nil
     collectgarbage("collect")
end
