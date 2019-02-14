--- Base of the class hierarchy.
-- @classmod Class
-- @usage
-- Class = require'lucy.class'
-- SubClass = Class'SubClass'
-- @see Mixin
-- @see Object
local getmetatable = getmetatable
local subclass = require'lucy'.subclass
local M = subclass(nil,"Class")
_ENV=M

function M:subclass(name)
    local T,mt = subclass(self, name)
    T.__index = T
    T.class = T
    return T,mt
end

--- Find method in super class.
-- @tparam string method name
-- @treturn function super class implementation of 'method'
function M:super(method)
    local superclass = getmetatable(self).__index
    return superclass and method and superclass[method]
        or superclass
end

--- Include methods from a mixin.
-- @function __concat
-- @usage
-- SomeClass..OneMixin..AndOneMore
-- @tparam Mixin mixin to be included in the class
-- @return self

--- Create a new subclass.
-- @function __call
-- @tparam string name
-- @treturn Class a new subclass

--- Partial ordering of subclasses.
-- @function __le
-- @tparam Class other
-- @treturn boolean true iff 'other' inherits from 'self'

return M
