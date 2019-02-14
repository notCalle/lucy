--- LUCY is a Lua Class System.
-- Lucy implements single inheritence class hierarchy, with mixins for
-- protocoll oriented programming.
-- @module lucy
-- @usage
-- > Object = require'lucy.object'
-- > MyObject = Object'MyObject'      <=> Object:subclass'MyObject'
-- > function MyObject:is_seven() return self.ivar == 7 end
-- > my_object = MyObject{ ivar = 7 } <=> MyObject:instance{ ivar = 7 }
-- > my_object:is_seven()
-- true
-- @author Calle Englund &lt;calle@discord.bofh.se&gt;
-- @copyright &copy; 2019 Calle Englund
-- @license
-- The MIT License (MIT)
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:
--
-- The above copyright notice and this permission notice shall be included
-- in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local getmetatable,setmetatable = getmetatable,setmetatable
local error,pairs,type = error,pairs,type
local strsub = string.sub
local _ENV = {
    _VERSION = "v0.1-1",
    _LICENSE = [[
    ]]
}

-- Dispatch calls to the class table itself
--
-- Class'Subclass' creates a subclass
-- Class{ k = v, ... } creates a new instance, or
-- returns the singleton instance
local function class_call(self,arg)
    if type(arg) == "table" then
        return self:instance(arg)
    elseif type(arg) == "string" then
        return self:subclass(arg)
    else
        error("Argument must be a subclass name or instance table",2)
    end
end

local function partial_order(self,other)
    if type(other) ~= "table"
    or type(getmetatable(other)) ~= "table" then
        return false
    else
        local mt = getmetatable(self)
        return self == other
        or mt.instances and mt.instances[other]
        or partial_order(self,getmetatable(other).__index)
    end
end

local function mixin(self,other)
    if type(other) == "table" and
       type(getmetatable(other)) == "table" and
       type(getmetatable(other).__call) == "function"
    or
       type(other) == "function"
    then
        other(self)
    else
        error("Mixin must be callable",2)
    end
    return self
end

-- Create a named subclass of some super class, optionally including
-- some mixin tables by shallow copy
function subclass(self,name)
    if type(name) ~= "string" then error("A class name must be a string",2) end
    local mt = {
        __index = self,
        __call = class_call,
        __le = partial_order,
        __concat = mixin,
        __tostring = function(_) return name end
    }
    local T = setmetatable({}, mt)
    for k,v in pairs(self or {}) do
        if strsub(k,1,2) == "__" then T[k] = v end
    end
    return T, mt
end

return _ENV
