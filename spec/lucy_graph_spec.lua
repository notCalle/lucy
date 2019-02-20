local Object = require'lucy.object'
local Graph = require'lucy.graph'
local Vertex = Object'Vertex'..Graph

describe("an Object with Graph mixin",function()
    it("can add an edge between two vertices",
    function()
        local v1 = Vertex{}
        local v2 = Vertex{}^v1
        assert.is.equal(v1,v2:tails()[1])
        assert.is.equal(v2,v1:heads()[1])
    end)

    it("can add edges between a group of vertices and a vertex",
    function()
        local g1 = {Vertex{},Vertex{}}
        local v1 = Vertex{}
        assert.has.no.errors(function() return v1^g1 end)
        assert.has.no.errors(function() return g1^v1 end)
    end)

    it("can not add an edge between two groups of vertices",
    function()
        local g1 = {Vertex{},Vertex{}}
        local g1 = {Vertex{},Vertex{}}
        assert.has.errors(function() return g1^g2 end)
    end)

    it("requires edges to be between Graph vertices",
    function()
        local v1 = Vertex{}
        assert.has.errors(function() return v1^"" end,
                          "Edges must be between tables of/or graph vertices")
        assert.has.errors(function() return v1^Object{} end,
                          "Edges must be between graph vertices")
    end)

    context("iterating edges in a graph",function()
        local v1 = Vertex{}
        local v2 = Vertex{}
        local v3 = Vertex{}
        local v4 = Vertex{}^{v1,v2}^v3

        it("can iterate breadth first",
        function()
            local order = {}
            for h,t in v4:edges_bfs() do table.insert(order,{h,t}) end
            assert.is.same(order,{{v4,v1},{v4,v2},{v1,v3},{v2,v3}})
        end)

        it("can iterate depth first",
        function()
            local order = {}
            for h,t in v4:edges_dfs() do table.insert(order,{h,t}) end
            assert.is.same(order,{{v4,v2},{v2,v3},{v4,v1},{v1,v3}})
        end)
    end)
end)
