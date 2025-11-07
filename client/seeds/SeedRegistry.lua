SeedRegistry = {}
SeedRegistry.__index = SeedRegistry
SeedRegistry.seeds = {}


function SeedRegistry:Register(name, seed)
     self.seeds[name] = seed
end

function SeedRegistry:Get(name)
    return self.seeds[name]
end

--- @param plantData PlantData
function SeedRegistry:RegisterFromPlantData(plantData)
     local seedClass = self:Get(plantData.name) or SeedBase
     local seed = seedClass:new(plantData.name)

     seed.model = plantData.model
     seed.growthTime = plantData.growthTime
     seed.stages = plantData.stages
     seed.yield = plantData.yield

     self:Register(plantData.name, seedClass)
     Logger:Info(("Registered seed %s"), plantData.name)
end
