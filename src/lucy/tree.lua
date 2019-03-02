--- A basic tree mixin.
-- @classmod Tree
-- @usage
-- Tree=require'lucy.tree'
-- MyTree=Object'MyTree'+Tree
--
-- @see Graph
-- @see DAG

local error = error
local Mixin = require'lucy.mixin'
local DAG = require'lucy.dag'
local M = Mixin'Tree'|DAG%{__edge_from="__dag_edge_from"}
_ENV = M

function M:__edge_from(head)
    self:__dag_edge_from(head)
    if #self:heads() ~= 0 then error((#M).multiparent_error,2) end
    self._parent = head
end

--- Errors
-- @section

--- Adding an edge would cause a vertex to have more than one parent
-- @field Tree.multiparent_error
-- @usage error((#Tree).multiparent_error)
(#M).multiparent_error = "would have more than one parent"

return _ENV
