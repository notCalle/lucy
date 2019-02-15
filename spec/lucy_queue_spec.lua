local List = require'lucy.list'
local Queue = require'lucy.queue'

describe("a queue", function()
    it("is a kind of list",
    function()
        assert.is_true(List <= Queue)
    end)

    it("can get items pushed",
    function()
        local q = Queue{}
        assert.has.no.errors(function() q:push(1) end)
    end)

    it("can pull values in fifo order",
    function()
        local q = Queue{1,2}
        assert.is.equal(q:pull(),1)
        assert.is.equal(q:pull(),2)
    end)

    it("can pop values in lifo order",
    function()
        local q = Queue{1,2}
        assert.is.equal(q:pop(),2)
        assert.is.equal(q:pop(),1)
    end)

    it("returns nil when it is empty",
    function()
        local q = Queue{}
        assert.is_nil(q:pop())
        assert.is_nil(q:pull())
    end)

    context("when it has a callback",
    function()
        local value = nil
        local function set_value(v) value = v end

        it("yields values to the callback",
        function()
            value = nil
            local q = Queue{1,2, callback = set_value}
            assert.is_nil(q:pop())
            assert.is.equal(value,2)
            assert.is_nil(q:pull())
            assert.is.equal(value,1)
        end)

        it("yields value to the callback on push when pending",
        function()
            value = nil
            local q = Queue{callback = set_value}
            q:pull()
            q:push(2)
            assert.is.equal(value,2)
        end)

        it("disallows pop/pull when a callback is pending",
        function()
            local q = Queue{callback = set_value}
            q:pull()
            assert.has.error(function() q:pull() end)
        end)
    end)
end)
