local ToolBase = require("client.tools.ToolBase")
ToolInspector = setmetatable({}, { __index = ToolBase })
ToolInspector.__index = ToolInspector

function ToolInspector:new()
    local self = ToolBase.new(self, "inspector_tool")
    setmetatable(self, ToolInspector)
    self.action = "inspect"

    self.ptfxLoaded = false
    self.inAnim = false
    return self
end


--- @param garden Garden
---@param cell Cell
function ToolInspector:OnUse(garden, cell)

     --- @type Plant
     local plant = garden:GetPlant(cell)

     if not plant then
          Logger:Debug():Error("No plant found on ", cell)
          return
     end

     plant:ToggleStatus()
end


return ToolInspector
