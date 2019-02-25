--- Basic list class, including all methods from table.
-- @classmod List
-- @see Object
-- @see table

local ipairs,pairs,table = ipairs,pairs,table
local Object = require'lucy.object'
local M = Object'List'
_ENV=M

for k,v in pairs(table) do M[k] = v end

--- Return a new list that is the concatenation of both lists
-- @tparam List other
-- @treturn List new list
function M:__add(other)
    return self.class{self:unpack()}..other
end

--- Concatenate the second list to the end of the first list
-- @tparam List other
-- @treturn List self
function M:__concat(other)
    for _,v in ipairs(other) do self:insert(v) end
    return self
end

return M
