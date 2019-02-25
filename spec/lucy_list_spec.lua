List = require'lucy.list'

describe("a list",function()
    it("includes all table.* methods",
    function()
        for k,v in pairs(table) do assert.is.equal(v,List[k]) end
    end)

    it("can be iterated with ipairs()",
    function()
        local l = List{1,2}
        assert.has.no.errors(function() for _ in ipairs(l) do end end)
    end)

    it("can tell how many values it contains",
    function()
        local l = List{}
        assert.is.equal(0,#l)
    end)

    it("can be concatenated with another list, in place",
    function()
        local l1 = List{1,2}
        local l2 = List{3,4}
        assert.has.no.errors(function() return l1..l2 end)
        assert.is.equal(4,#l1)
    end)

    it("can be added to another list, yielding a new list",
    function()
        local l1 = List{1,2}
        local l2 = List{3,4}
        local l3
        assert.has.no.errors(function() l3 = l1+l2 end)
        assert.is.equal(2,#l1)
        assert.is.equal(4,#l3)
    end)
end)
