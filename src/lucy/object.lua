--- Base class for objects, classes that can have instances.
-- @classmod Object
-- @usage
-- MyObject = Object'MyObject'
-- instance = MyObject{}
-- @see Class
local getmetatable,setmetatable = getmetatable,setmetatable
local format,gsub = string.format,string.gsub
local error,tostring,type = error,tostring,type
local Class = require'lucy.class'
local M = Class'Object'
_ENV=M

local table_id = setmetatable({},{__mode = "k"})

function M:instance(I)
    if type(I) ~= "table" then error("An instance must be a table",2) end
    table_id[I] = gsub(tostring(I),"table: ","")
    self.__init(setmetatable(I,self))
    return I
end

--- Initialize a new instance.
function M:__init() end

--- String representation of an instance.
-- @treturn string
function M:__tostring()
    return format("%s<%s>",getmetatable(self),table_id[self])
end

--- Include methods from a mixin.
-- @function __concat
-- @usage
-- SomeClass..OneMixin..AndOneMore
-- @tparam Mixin mixin to be included in the class
-- @return self

--- Create a new subclass or instance.
-- @function __call
-- @tparam string|table name or instance table
-- @treturn Object a new subclass or instance

--- Partial ordering of subclasses and instances.
-- @function __le
-- @tparam Object other
-- @treturn boolean true iff 'other' inherits from 'self'

return M
