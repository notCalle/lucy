--- Basic directed graph mixin, with no edge restrictions
-- @classmod Graph
-- @usage
-- MyGraph=Object'MyGraph'+Graph
--
-- v1 = MyGraph{}             (v1)
-- v2 = MyGraph{}^v1          (v2)->(v1)
-- v3 = MyGraph{}^{v1,v2}     (v3)->(v2)->(v1)
--                                `--------^
-- @see Object

local getmetatable,setmetatable = getmetatable,setmetatable
local insert = table.insert
local error,ipairs,next,type = error,ipairs,next,type
local cowrap,yield = coroutine.wrap,coroutine.yield
local Mixin = require'lucy.mixin'
local Queue = require'lucy.queue'
local M = Mixin'Graph'
_ENV = M

local _heads = setmetatable({},{__mode="k"})
local _tails = setmetatable({},{__mode="k"})

local function add_edge(head,tail)
    _tails[head] = _tails[head] or setmetatable({},{__mode="v"})
    _heads[tail] = _heads[tail] or setmetatable({},{__mode="v"})
    if type(head.__edge_to) == "function" then head:__edge_to(tail) end
    if type(tail.__edge_from) == "function" then tail:__edge_from(head) end
    insert(_tails[head],tail)
    insert(_heads[tail],head)
end

--- Add an edge between vertices.
-- Either head or tail, but not both may be a table of Graph objects.
-- In that case edges are added to/from all objects in the table.
--
-- N.B! call signature is actually Graph.__pow(head,tail), but ldoc.
-- @usage
-- v1^{v2,v3}^v4  <=>  v1^v2 ; v1^v3 ; v2^v4 ; v3^v4
-- @tparam Graph|{Graph,...} head
-- @tparam Graph|{Graph,...} tail
-- @treturn Graph|{Graph,...} head for method chaining
function M.__pow(head,tail)
    if type(head) ~= "table" or type(tail) ~= "table" then
        error("Edges must be between tables of/or graph vertices",2)
    else
        local heads = getmetatable(head) and {head} or head
        local tails = getmetatable(tail) and {tail} or tail
        for _,h in ipairs(heads) do
            for _,t in ipairs(tails) do add_edge(h,t) end
        end
    end
    return head
end

--- Return the list of tails for outgoing edges
-- @treturn {Graph,...}
function M:tails()
    return _tails[self] or {}
end

--- Return the list of heads for incoming edges
-- @treturn {Graph,...}
function M:heads()
    return _heads[self] or {}
end

local function push_edges(self,queue)
    for _,it in ipairs(_tails[self] or {}) do queue:push({[self] = it}) end
end

--- Return an iterator function that walks the edges of a graph, breadth first
--
-- If called with a function, that function must return truthy for an edge to
-- be walked, for example to detect loops and avoid infinite iteration, or
-- implementing a state machine.
--
-- The iterator yields two values: head,tail for the next selected edge.
-- @tparam ?func select function that selects edges to walk
-- @treturn func 'for' loop iterator
function M:edges_bfs(select)
    local q = Queue{}
    push_edges(self,q)
    local co = cowrap(function()
        local this = q:pull()
        while this do
            head,tail = next(this)
            if not select or select(head,tail) then
                yield(head,tail)
                push_edges(tail,q)
            end
            this = q:pull()
        end
    end)
    return co,self
end

--- Return an iterator function that walks the edges of a graph, depth first
-- @tparam ?func select function that selects edges to walk
-- @treturn func 'for' loop iterator
-- @see edges_bfs
function M:edges_dfs(select)
    local q = Queue{}
    push_edges(self,q)
    local co = cowrap(function()
        local this = q:pop()
        while this do
            head,tail = next(this)
            if not select or select(head,tail) then
                yield(head,tail)
                push_edges(tail,q)
            end
            this = q:pop()
        end
    end)
    return co,self
end

return _ENV
