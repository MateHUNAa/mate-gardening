ToolRegistry = {}
ToolRegistry.tools = {}

function ToolRegistry:Register(name, tool)
     self.tools[name] = tool
end


function ToolRegistry:Get(name)
     return self.tools[name] or nil
end
