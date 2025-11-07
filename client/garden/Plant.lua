--- @class Plant
--- @field data PlantData|boolean
--- @field garden Garden
--- @field cell Cell
--- @field plantedAt number
--- @field obj any
--- @field update fun(self: Plant)
--- @field stage number
--- @return Plant|boolean
Plant = {}
Plant.__index = Plant

--- @class PlantData
--- @field name string
--- @field growthTime number
--- @field stages number
--- @field model string
--- @field yield number

--- @param seedId string
--- @param garden Garden
--- @param cell Cell
--- @retrun Plant|boolean
function Plant:new(seedId, garden, cell)
     --- @type PlantData|boolean
     local plantData = PlantRegistry:Get(seedId)

     if not plantData then
          Logger:Error("[Plant:new]: No plant found with seedId: ", seedId)
          return false
     end

     local self = setmetatable({}, Plant)

     self.data = plantData
     self.garden = garden
     self.cell = cell
     self.stage = 1
     self.plantedAt = GetGameTimer()
     self.obj = nil

     self:SpawnModel()

     return self
end

--
-- Model Creation
--

--- @return Vector3
function Plant:GetWorldPosition()
     if not self.garden or not self.garden.grid then
          Logger:Error("[Plant:GetWorldPosition] Garden or grid not found")
          return vec3(0,0,0)
     end

     local grid = self.garden.grid
     local cell = self.cell

     local pos = grid:GetCellWorldPos(cell.row, cell.col)

     return pos
end

function Plant:SpawnModel()
     local model = self.model
     if type(model) == "table" then
          model = model[self.stage] or model[1]
     end

     local pos = self:GetWorldPosition()


     self.obj = Functions.makeProp({
          prop = model,
          coords = vector4(pos.x, pos.y, pos.z, 0.0)
     }, true, false)
end

function Plant:RefreshModel()
     if DoesEntityExist(self.obj) then
          DeleteEntity(self.obj)
          self.obj = nil
     end

     self:SpawnModel()
end

function Plant:Destroy()
     if DoesEntityExist(self.obj) then
          DeleteEntity(self.obj)
     end

     self.obj = nil
end

--
-- Plant Progress
--

--- Calculates current growth progress (0.0 - 1.0)
function Plant:GetProgress()
    local elapsed = GetGameTimer() - self.startTime
    return math.min(elapsed / self.data.growthTime, 1.0)
end

function Plant:update()
     local progress = self:GetProgress()
     local stage = math.floor(progress * self.data.stages) + 1

     if stage > self.data.stages then
          stage = self.data.stages
     end

     if stage ~= self.stage then
          self.stage = stage
          self:RefreshModel()
     end
end


function Plant:isFullyGrown()
     return self.stage >= self.data.stages
end
