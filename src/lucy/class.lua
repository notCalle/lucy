--- Base of the class hierarchy.
-- @classmod Class
-- @usage
-- Class = require'lucy.class'
-- SubClass = Class'SubClass'
local print = print
local getmetatable,setmetatable = getmetatable,setmetatable
local error,type,pairs = error,type,pairs
local strsub = string.sub

local function class(super,name)
    if type(name) ~= "string" then
        error("Invalid argument type, "..type(name),2)
    end
    -- These metamethods are private to each class
    local mt = {
        __index = super,
        super = super,
        __tostring = function(_) return name end
    }
    -- Copy all other metamethods from super class
    for k,v in pairs(getmetatable(super) or {}) do
        if strsub(k,1,2) == "__" and not mt[k] then mt[k] = v end
    end
    return setmetatable({},mt),mt
end

local M,_M = class(nil,"Class")
_ENV=M

--- Create a named subclass
-- @usage
-- SubClass = Class'SubClass'
-- @function __call
-- @tparam string name name of new class
-- @treturn Class a new class
_M.__call = class

--- Get class metatable
-- @usage
-- (#SubClass).super
-- @function __len
_M.__len = getmetatable

--- Partial ordering of subclasses.
-- @tparam Class other
-- @treturn boolean 'other' inherits from 'self'
function _M:__le(other)
    return self == other
        or type(getmetatable(other)) == "table" and
           self <= getmetatable(other).__index
end

return M
