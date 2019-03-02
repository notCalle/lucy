--- Directed Acyclic Graph mixin.
-- @classmod DAG
-- @usage
-- DAG=require'lucy.dag'
-- MyGraph=Object'MyGraph'+DAG
--
-- @see Graph

local error = error
local Mixin = require'lucy.mixin'
local Graph = require'lucy.graph'
local M = Mixin'DAG'|Graph
_ENV = M

function M:__edge_from(head)
    if head == self then error((#M).cyclic_error,2) end
    for _,v in self:edges_bfs() do
        if v == head then error((#M).cyclic_error,2) end
    end
end

function M:__edge_to(tail)
    if tail == self then error((#M).cyclic_error,2) end
    for _,v in tail:edges_bfs() do
        if v == self then error((#M).cyclic_error,2) end
    end
end

--- Errors
-- @section

--- Adding an edge would cause the DAG to become cyclic
-- @field DAG.cyclic_error
-- @usage error((#DAG).cyclic_error)
(#M).cyclic_error = "would become cyclic"

return _ENV
