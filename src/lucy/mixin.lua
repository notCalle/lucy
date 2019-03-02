--- Base class for mixins.
-- @classmod Mixin
-- @usage
-- Object = require'lucy.object'
-- Mixin = require'lucy.mixin'
-- MyMixin = Mixin'MyMixin'
-- MyObject = Object'MyObject'+MyMixin
-- @see Class
-- @see Object

local getmetatable,setmetatable,type = getmetatable,setmetatable,type
local error,pairs,rawget,rawset = error,pairs,rawget,rawset
local format = string.format
local Class = require'lucy.class'
local M,_M = Class'mixin'
_ENV=M

--- Class metamethods
-- @section

--- Instantiate mixin in receiver.
-- @usage
-- TheClass+SomeMixin
-- @tparam Mixin mixin the mixin
-- @treturn Class the instance class
function _M:__add(mixin)
    local mt = #mixin
    if not rawget(mt,"instances") then
        rawset(mt,"instances",setmetatable({},{__mode="k"}))
    end
    mt.instances[self] = true

    for k,v in pairs(mixin) do
        if not rawget(self,k) then
            rawset(self,k,v)
        else
            error(format("%s: %s.%s already defined",mixin,self,k))
        end
    end

    return self
end

--- Merge mixin into receiver.
-- @usage
-- MyMixin = Mixin'MyMixin'|OtherMixin
-- @tparam Mixin other the mixin
-- @treturn Mixin self
function _M:__bor(other)
    for k,v in pairs(other) do
        if not rawget(self,k) then
            rawset(self,k,v)
        else
            error(format("%s: %s.%s already defined",mixin,self,k))
        end
    end

    return self
end

--- Filter a mixin, renaming methods to enable overrides.
-- If a method is renamed to something falsey, it is not included
-- @tparam table map {[string]=string,...} table of method name mappings
-- @usage
-- MyObject..MyMix % {doit="_mymix_doit", dont=false}
-- function MyObject:doit() self:_mymix_doit() ... end
function _M:__mod(map)
    local mt = getmetatable(self)
    new = setmetatable({},mt)
    for k,v in pairs(self) do
        if map[k] then k = map[k] end
        if k and v then new[k] = v end
    end
    return new
end

--- Partial ordering of subclasses and instances.
-- @tparam Object other
-- @treturn boolean 'other' is an instance of or inherits from 'self'
function _M:__le(other)
    local instances = rawget(#self,"instances")
    return instances and instances[other]
        or (#Class).__le(self,other)
end

return M
