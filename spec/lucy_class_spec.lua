local Class = require'lucy.class'

describe("a class", function()
    it("can not create an instance",
    function()
        assert.has.error(function() Class{} end)
    end)

    it("can create a subclass",
    function()
        assert.has.no.errors(function() Class'Sub' end)
    end)

    it("has a partial order over subclasses",
    function()
        local Sub = Class'Sub'
        assert.is_true(Class <= Sub)
    end)

    it("requires a subclass name when called",
    function()
        assert.has.error(function() Class() end,
            "Invalid argument type, nil")
    end)

    it("has a string representation",
    function()
        assert.is.equal(tostring(Class), "Class")
    end)
end)
