--- @class Plant
Plant = {}
Plant.__index = Plant

--- @param seedId string
--- @param garden Garden
--- @param cell Cell
--- @retrun Plant|boolean
function Plant:new(seedId, garden, cell)
     --- @type PlantData|boolean
     local plantData = PlantRegistry:Get(seedId)

     if not plantData then
          Logger:Error("[Plant:new]: No plant found with seedId: ", seedId)
          return
     end

     local self = setmetatable({}, Plant)

     self.data = plantData
     self.garden = garden
     self.cell = cell
     self.stage = 1
     self.plantedAt = GetGameTimer()
     self.obj = nil

     self.isAlive = true

     self.water = 50
     self.lastDecay = GetGameTimer()

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

     if not self.data then
          return pos
     end

     --- @type PlantData
     local data = self.data

     if type(data.model) == "string" then
          pos += data.modelOffset
          return pos
     end

     if type(data.model) == "table" then
          local stageData = data.model[math.min(self.stage, #data.model)]

          if stageData and stageData.offset then
               pos+= stageData.offset
               return pos
          end
     end

     return pos
end

function Plant:SpawnModel()
     local model = self.data.model
     if type(model) == "table" then
          local idx = math.min(self.stage, #model)
          Logger:Debug(("Plant stage: %d, model index: %d"):format(self.stage, idx))
          model = model[idx].model or model[1].model
     end

     local pos = self:GetWorldPosition()

     self.obj = Functions.makeProp({
          prop = model,
          coords = vector4(pos.x, pos.y, pos.z, math.random(0, 360))
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
    local elapsed = GetGameTimer() - self.plantedAt
    return math.min(elapsed / self.data.growthTime, 1.0)
end

function Plant:update()
     if not self.isAlive then return end -- TODO: Do smthing when the plant is dead

     local progress = self:GetProgress()
     local stage = math.floor(progress * self.data.stages) + 1

     if stage > self.data.stages then
          stage = self.data.stages
     end

     if stage ~= self.stage then
          self.stage = stage
          self:RefreshModel()
     end

     -- Watering
     local now = GetGameTimer()
     if now - self.lastDecay >= Config.WaterDecay then
          self:DecayWater()
          self.lastDecay = now
     end
end

function Plant:DecayWater()
     self.water = math.max(self.water -1, 0)

     -- Logger:Debug(("Plant %s has decayed water to %d%%"):format(self.data.name, self.water))

     if self.water <= 0 then
          Logger:Warning(("Plant died Action not implemented"))
     end
end

function Plant:Water(amount)
     amount = amount or 20
     self.water = math.min(self.water + amount, 100)
     Logger:Info(("Watered %s (now at %d%%)"):format(self.data.name, self.water))
end

function Plant:isFullyGrown()
     return self.stage >= self.data.stages
end


function Plant:Harvest()
     if not self:isFullyGrown() then
          Info("Plant is not fully grown")
          return
     end

     self.garden:DestroyPlant(self.cell)
end
