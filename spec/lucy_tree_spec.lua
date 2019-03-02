local Object = require'lucy.object'
local DAG = require'lucy.dag'
local Tree = require'lucy.tree'
local Vertex = Object'Vertex'+Tree

describe("an object with tree mixin",function()
    it("is a kind of tree",
    function()
        assert.is_true(Tree <= Vertex)
    end)

    it("disallows multiple heads",
    function()
        local v1 = Vertex{}
        local v2 = Vertex{}^v1
        local v3 = Vertex{}

        assert.has.error(function() return v3^v1 end,(#Tree).multiparent_error)
    end)
end)
