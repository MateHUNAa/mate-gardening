MaterialRegistry = {}
MaterialRegistry.materials = {}
MaterialRegistry.classes = {}

function MaterialRegistry:Register(name, material)
    self.materials[name] = material
end

function MaterialRegistry:Get(name)
    return self.materials[name]
end

function MaterialRegistry:RegisterClass(name, class)
    self.classes[name] = class
end

function MaterialRegistry:GetClass(name)
    return self.classes[name]
end


local MatDirt = require("client.materials.MatDirt")
MaterialRegistry:RegisterClass("dirt", MatDirt)
