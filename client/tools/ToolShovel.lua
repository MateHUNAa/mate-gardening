local ToolBase = require("client.tools.ToolBase")
ToolShovel = setmetatable({}, { __index = ToolBase })
ToolShovel.__index = ToolShovel

function ToolShovel:new()
    local self = ToolBase.new(self, "watering_can")
    setmetatable(self, ToolShovel)
    self.action = "watering"


    self.ptfxLoaded = false
    self.inAnim = false
    return self
end


return ToolShovel
