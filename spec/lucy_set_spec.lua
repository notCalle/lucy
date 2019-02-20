Set = require'lucy.set'

describe("a set",function()
    it("can count how many values it contains",
    function()
        local s = Set{1,3,3,7,"foo"}
        assert.is.equal(4,#s)
    end)

    it("can tell if it includes a value or not",
    function()
        local s = Set{"foo"}
        assert.is_true(s:include("foo"))
        assert.is_false(s:include("bar"))
    end)

    it("can insert values",
    function()
        local s = Set{}
        assert.has.no.errors(function() s:insert("foo") end)
        assert.is_true(s:include("foo"))
    end)

    it("can not remove values",
    function()
        local s = Set{"foo"}
        assert.has.error(function() s:remove("foo") end,
                         "attempt to call a nil value (method 'remove')")
    end)

    it("can be iterated with ipairs()",
    function()
        local s = Set{1,2}
        assert.has.no.errors(function() for _ in ipairs(s) do end end)
    end)

    context("and another set",function()
        it("considers sets with the same elements to be equal",
        function()
            assert.is.equal(Set{1,2},Set{2,1})
            assert.is_not.equal(Set{1},Set{1,2})
        end)

        it("forms a partial order over subsets",
        function()
            assert.is_true(Set{1} <= Set{1,2,3})
            assert.is_false(Set{1} <= Set{2,3})
        end)

        it("can form a set union",
        function()
            local s = Set{1,2} | Set{3,4}
            assert.is.equal(Set{1,2,3,4},s)
        end)

        it("can form a set intersection",
        function()
            local s = Set{1,2,3} & Set{3,4}
            assert.is.equal(Set{3},s)
        end)

        it("can form a set difference",
        function()
            local s = Set{1,2,3} - Set{3,4}
            assert.is.equal(Set{1,2},s)
        end)

        it("can form a symmetric set difference",
        function()
            local s = Set{1,2,3} ~ Set{3,4}
            assert.is.equal(Set{1,2,4},s)
        end)
    end)
end)
