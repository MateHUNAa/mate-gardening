MaterialBase = {}
MaterialBase.__index = MaterialBase


function MaterialBase:new(name)
     local self = setmetatable({}, MaterialBase)
     self.name = name or "UnknownMaterial"
     self.actionTime = 1000
     return self
end

function MaterialBase:OnApply(garden, cell)
     Logger:Warn(("[%s] OnApply() not implemented."):format(self.name))
end


return MaterialBase
