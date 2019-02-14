--- Base class for mixins.
-- @classmod Mixin
-- @alias Meta
-- @usage
-- Object = require'lucy.object'
-- Mixin = require'lucy.mixin'
-- MyMixin = Mixin'MyMixin'
-- MyObject = Object'MyObject'..MyMixin
-- @see Object
-- @see Class
local getmetatable,setmetatable = getmetatable,setmetatable
local error,pairs,rawget,rawset = error,pairs,rawget,rawset
local format = string.format
local subclass = require'lucy'.subclass
local M, _M = subclass(nil,"Mixin")
_ENV=M

--- Create a mixin subclass
function M:subclass(name)
    local T,mt = subclass(self,name)
    mt.__mod = _M.__mod
    return T,mt
end

--- Initialize an instance of a mixin
function M:instance(I)
    local mt = getmetatable(self)
    mt.instances = mt.instances or setmetatable({},{__mode="k"})
    mt.instances[I] = true

    for k,v in pairs(self) do
        if not rawget(I,k) then
            rawset(I,k,v)
        else
            error(format("%s: %s.%s already defined",self,I,k))
        end
    end

    return I
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

--- Create a new subclass or instance.
-- @function __call
-- @usage
-- SomeMixin(TheClass) <=> TheClass..SomeMixin
-- @see Class:__concat
-- @tparam string|Class name or instance class
-- @treturn Object a new subclass or the instance class

--- Partial ordering of subclasses and instances.
-- @function __le
-- @tparam Object other
-- @treturn boolean true iff 'other' inherits from 'self'


return M
