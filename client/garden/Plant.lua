Plant = {}
Plant.__index = Plant

--- @class Plant
--- @field name string
--- @field growthTime number
--- @field stages number
--- @field model string
--- @field yield number

--- @param seedId string
---@param cell Cell
function Plant:new(seedId, cell)
     local plantData = PlantRegistry:Get(seedId)

     if not plantData then
          Logger:Error("[Plant:new]: No plant found with seedId: ", seedId)
          return false
     end

     local self = setmetatable({}, Plant)

     self.id = seedId
     self.cell = cell
     self.stage = 1
     self.data = plantData
     self.plantedAt = GetGameTimer()

     return self
end

function Plant:update()
     local elapsed = GetGameTimer() - self.plantedAt
     local progress = elapsed / self.data.growthTime

     if progress >= (self.stage / self.data.stages) then
          self.stage = math.min(self.stage+1, self.data.stages)
     end
end


function Plant:isFullyGrown()
     return self.stage >= self.data.stages
end
