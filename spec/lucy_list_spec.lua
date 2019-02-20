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
end)
