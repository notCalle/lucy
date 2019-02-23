--- Basic set class with boolean operations and partial ordering.
-- @classmod Set
-- @usage
-- Set{1,2} & Set{2,3}      => Set{2}
-- Set{1,2} | Set{2,3}      => Set{1,2,3}
-- Set{1,2} - Set{2,3}      => Set{1}
-- Set{1,2} ~ Set{2,3}      => Set{1,3}
-- Set{1,2} == Set{2,1}     => true
-- Set{1,2} <= Set{1,2,3}   => true
-- Set{1,2} <= Set{2,3}     => false
-- @see Object

local setmetatable,type = setmetatable,type
local ipairs,rawset = ipairs,rawset
local Object = require'lucy.object'
local M,_M = Object'Set'
_ENV=M

--- Add an element to the set
-- @param elem anything
function M:insert(elem)
    if self:include(elem) then return end
    local c = #self+1
    rawset(self,c,elem)
    self.__values[elem] = c
end

--- Test if an element is in the set.
-- @param elem anything
-- @treturn boolean
function M:include(elem)
    return self.__values[elem] ~= nil
end

--- Set equality over included elements.
-- @tparam Set|table other candidate for testing
-- @treturn boolean
function M:__eq(other)
    return #(self ~ other) == 0
end

--- Set partial ordering over subsets.
-- @tparam Set|table other candidate for testing
-- @treturn boolean
function M:__le(other)
    return #(self - other) == 0
end

--- Set union operation.
-- @tparam Set|table other
-- @treturn Set all elements in either set
function M:__bor(other)
    local new = self.class{}
    for _,v in ipairs(self) do new:insert(v) end
    for _,v in ipairs(other) do new:insert(v) end
    return new
end

--- Set intersection operation.
-- @tparam Set|table other
-- @treturn Set elements present in both sets
function M:__band(other)
    local new = self.class{}
    for _,v in ipairs(self) do
        if other:include(v) then new:insert(v) end
    end
    return new
end

--- Set symmetric difference.
-- @tparam Set|table other
-- @treturn Set elements exclusive to one of the sets
function M:__bxor(other)
    local new = self.class{}
    for _,v in ipairs(self) do
        if not other:include(v) then new:insert(v) end
    end
    for _,v in ipairs(other) do
        if not self:include(v) then new:insert(v) end
    end
    return new
end

--- Set difference operation.
-- @tparam Set|table other
-- @treturn Set elements present in self but not other
function M:__sub(other)
    local new = self.class{}
    for _,v in ipairs(self) do
        if not other:include(v) then new:insert(v) end
    end
    return new
end

function _M:__call(l)
    if type(l) == "table" then
        local I = (#Object).__call(self,{})
        I.__values = setmetatable({},{__mode="k"})
        for _,v in ipairs(l) do I:insert(v) end
        return I
    else
        return (#Object).__call(self,l)
    end
end

return M
