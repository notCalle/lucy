local Object = require'lucy.object'

describe("a lucy Object", function()
    it("has a partial order over instances",
    function()
        local instance = Object{}
        assert.is_true(Object <= instance)
    end)

    it("has a partial order over subclasses",
    function()
        local Sub = Object'Sub'
        assert.is_true(Object <= Sub)
    end)

    it("requires a subclass name or instance table when called",
    function()
        assert.has.error(function() Object() end,
            "Argument must be a subclass name or instance table")
    end)

    it("gives a string representation to instances",
    function()
        assert.is.string(tostring(Object{}))
    end)
end)
