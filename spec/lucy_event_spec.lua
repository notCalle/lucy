Event = require'lucy.event'

describe("an event",function()
    it("can register handlers",
    function()
        local ev = Event{}
        local handler = function() end

        assert.has.no.errors(function() ev:register(handler) end)
    end)

    it("can unregister handlers",
    function()
        local ev = Event{}
        local handler = function() end
        local id = ev:register(handler)

        assert.is.equal(handler, ev:unregister(id))
    end)

    it("can call handlers",
    function()
        local result = nil
        local ev = Event{}
        ev:register(function(x) result = x end)
        assert.has.no.errors(function() ev(true) end)
        assert.is_true(result)
    end)
end)
