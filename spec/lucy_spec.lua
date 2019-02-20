local lucy = require'lucy'

describe("lucy", function()
    it("has a version", function()
        assert.is.string(lucy._VERSION)
    end)

    it("can create subclasses", function()
        assert.is_function(lucy.subclass)
    end)
end)
