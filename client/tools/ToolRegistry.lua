ToolRegistry = {}
ToolRegistry.tools = {}
ToolRegistry.classes = {}

function ToolRegistry:Register(name, tool)
     self.tools[name] = tool
end


function ToolRegistry:Get(name)
     return self.tools[name] or nil
end

--- @param action string
---@param class table
function ToolRegistry:RegisterClass(action, class)
     self.classes[action] = class
end

--- @param action string
function ToolRegistry:GetClass(action)
     return self.classes[action] or nil
end

local ToolBase = require("client.tools.ToolBase")
local ToolWatering = require("client.tools.ToolWatering")

ToolRegistry:RegisterClass("watering", ToolWatering)
ToolRegistry:RegisterClass("none", ToolBase)
