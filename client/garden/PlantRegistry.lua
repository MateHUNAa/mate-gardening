PlantRegistry = {}
PlantRegistry.__index = PlantRegistry

--- @param id string
--- @param data Plant
function PlantRegistry:Register(id, data)
     self[id] = data
end

--- @param id string
--- @return Plant|boolean
function PlantRegistry:Get(id)
	return self[id] or false
end
