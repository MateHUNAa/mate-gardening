--- @alias Cell {row: number, col: number}
--- @alias ToolAction "watering" | "fertilizing" | "pruning" | "harvest" | "dig"


--- @alias Model string|table<number, {model: string, offset: Vector3}>

--- @class PlantData
--- @field name string
--- @field growthTime number
--- @field stages number
--- @field model Model
--- @field modelOffset vector3
--- @field yield number


--- @class Garden
--- @field grid Grid|nil
--- @field plants table<string, Plant>
--- @field center Vector3
--- @field rows number
--- @field cols number
