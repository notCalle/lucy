--- Basic queue class, supporting both lifo and fifo extraction modes.
-- @classmod Queue
-- @usage
-- Queue = require'lucy.queue'
-- q = Queue{}
-- q:push(1) q:push(2) q:push(3)
-- 1 == q:pull()
-- 3 == q:pop()

local error = error
local List = require'lucy.list'
local M = List'Queue'
_ENV = M

--- Push an item onto the queue.
-- @param item anything
function M:push(item)
    if #self == 0 and self.callback and self._callback_pending then
        self._callback_pending = false
        return self.callback(item)
    else
        self:insert(item)
    end
end

local function item_or_cb(self,item)
    if not self.callback then
        return item
    elseif item then
        return self.callback(item)
    else
        self._callback_pending = true
    end
end

--- Pop item from the tail of the queue
-- @return the last item pushed
function M:pop()
    if self._callback_pending then error("Pending callback recursion") end
    return item_or_cb(self,self:remove())
end

--- Pull item from the head of the queue
-- @return the first item pushed
function M:pull()
    if self._callback_pending then error("Pending callback recursion") end
    return item_or_cb(self,self:remove(1))
end

return M
