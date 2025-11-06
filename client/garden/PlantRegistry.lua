PlantRegistry = {}
PlantRegistry.__index = PlantRegistry

--- @param id string
--- @param data table
function PlantRegistry:Register(id, data)
     self[id] = data
end

--- @param id string
--- @return table|boolean
function PlantRegistry:Get(id)
	return self[id] or false
end
