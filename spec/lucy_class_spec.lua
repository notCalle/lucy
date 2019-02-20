local Class = require'lucy.class'

describe("a lucy Class", function()
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
            "Argument must be a subclass name or instance table")
    end)

    it("requires a mixin to be callable",
    function()
        assert.has.error(function() return Class'Sub'..{} end,
            "Mixin must be callable")
    end)

    it("has a string representation",
    function()
        assert.is.equal(tostring(Class), "Class")
    end)

    it("can find super class version of methods",
    function()
        local Sub = Class'Sub'
        function Sub:value() end
        local SubUb = Sub'SubUb'
        SubUb._value = SubUb:super'value'
        function SubUb:value(x) end
        assert.is_not.equal(Sub.value,SubUb.value)
        assert.is.equal(Sub.value,SubUb._value)
    end)
end)
