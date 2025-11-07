SeedBase = {}
SeedBase.__index = SeedBase


function SeedBase:new(name)
    local self = setmetatable({}, SeedBase)
    self.name = name
    self.model = nil
    self.yield = 1
    self.growthTime = 0
    self.stages = 1
    self.stage = 1
    return self
end


function SeedBase:OnPlant(garden, cell)
    Logger:Warning(("[%s] OnPlant() not implemented."):format(self.name or "UnknownSeed"))
end

function SeedBase:Equip()
    Logger:Warning(("[%s] Equip() not implemented."):format(self.name or "UnknownSeed"))
end

function SeedBase:Unequip()
    Logger:Warning(("[%s] Unequip() not implemented."):format(self.name or "UnknownSeed"))
end


return SeedBase
