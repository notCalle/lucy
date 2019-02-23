--- Base class for objects, classes that can have instances.
-- @classmod Object
-- @usage
-- MyObject = Object'MyObject'
-- instance = MyObject{}
-- @see Class

local print=print
local getmetatable,setmetatable = getmetatable,setmetatable
local format,gsub = string.format,string.gsub
local error,pairs,tostring,type = error,pairs,tostring,type
local rawget,rawset = rawget,rawset
local strsub = string.sub
local Class = require'lucy.class'
local M,_M = Class'Object'
_ENV=M

local table_id = setmetatable({},{__mode = "k"})

--- Initialize a new instance.
function M:__init() end

--- String representation of an instance.
-- @treturn string
function M:__tostring()
    return format("%s<%s>",getmetatable(self),table_id[self])
end

--- Class metamethods
-- @section

--- Create a new instance or subclass.
-- @tparam table|string I instance table or subclass name
-- @treturn Object a new instance or subclass
function _M:__call(I)
    if type(I) == "table" then
        table_id[I] = gsub(tostring(I),"table: ","")
        self.__init(setmetatable(I,self))
        return I
    else
        local T,_T = (#Class).__call(self,I)
        T.__index = T
        T.class = T
        for k,v in pairs(self) do
            if strsub(k,1,2) == "__" and not rawget(T,k) then rawset(T,k,v) end
        end
        return T,_T
    end
end

--- Partial ordering of subclasses and instances.
-- @tparam Object other
-- @treturn boolean 'other' is an instance of or inherits from 'self'
function _M:__le(other)
    local mt = getmetatable(other)
    return type(mt) == "table" and self == mt
        or (#Class).__le(self,mt.__index)
end

return M
