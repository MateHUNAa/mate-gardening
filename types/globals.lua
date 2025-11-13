-- Shared Globals


---@alias Date string|number
---@alias playerId integer|number|string

---@alias Vector3 {x: number, y: number, z: number}
---@alias Vector4 {x: number, y: number, z: number, w: number}

---@class Editable
Editable = {}

---@class MySQL
MySQL = {}

-- Utility

---@param msg string
function Error(msg) end

---@param msg string
function Info(msg) end

---@param msg string
function Success(msg) end

---@param eventName string
---@param callback fun(playerId:number, identifier: string, params: table): any
---@param showLog? boolean
function regServerNuiCallback(eventName, callback, showLog) end


mCore = {}

---@param center vector3
---@param width number
---@param height number
---@param icon string|table
---@param rot vector3|nil
---@param dir vector3|nil
---@param color table|nil
---@param faceCamera boolean
mCore.DrawCustomIcon = function(center, width, height, icon, rot, dir, color, faceCamera) end
