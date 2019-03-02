local Object = require'lucy.object'
local Graph = require'lucy.graph'
local DAG = require'lucy.dag'
local Vertex = Object'Vertex'+DAG

describe("an object with DAG mixin",function()
    it("is a kind of DAG",
    function()
        assert.is_true(DAG <= Vertex)
    end)

    it("disallows edge cycles",
    function()
        local v1 = Vertex{}
        local v2 = Vertex{}^v1

        assert.has.error(function() return v1^v2 end,(#DAG).cyclic_error)
        assert.has.error(function() return v1^v1 end,(#DAG).cyclic_error)
        assert.has.error(function() return v2^v2 end,(#DAG).cyclic_error)
    end)
end)
