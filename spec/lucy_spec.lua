local lucy = require'lucy'

describe("lucy", function()
    it("has a version", function()
        assert.is.string(lucy._VERSION)
    end)
end)
