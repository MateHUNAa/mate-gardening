ToolBase = {}
ToolBase.__index = ToolBase


function ToolBase:new(name)
     local self = setmetatable({}, ToolBase)
     self.name = name
     self.action = "none"
     self.actionTime = 1000
     self.uses = 15
     self.prop = nil

     return self
end

function ToolBase:OnUse(garden, cell)
    Logger:Warning(("[%s] OnUse() not implemented."):format(self.name or "UnknownTool"))
end

function ToolBase:Equip()
    Logger:Warning(("[%s] Equip() not implemented."):format(self.name or "UnknownTool"))
end

function ToolBase:Unequip()
    Logger:Warning(("[%s] Unequip() not implemented."):format(self.name or "UnknownTool"))
end

function ToolBase:OnHoldComplete(garden, cell)
    Logger:Warning(("[%s] OnHoldComplete() not implemented."):format(self.name or "UnknownTool"))
end

function ToolBase:OnHoldCancelled(garden, cell)
    Logger:Warning(("[%s] OnHoldCancelled() not implemented."):format(self.name or "UnknownTool"))
end


return ToolBase
