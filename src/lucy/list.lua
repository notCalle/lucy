--- Basic list class, including all methods from table.
-- @classmod List
-- @see table

local Object = require'lucy.object'
local List = Object'List'

for k,v in pairs(table) do List[k] = v end

return List
