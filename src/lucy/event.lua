--- Event dispatcher class
-- @classmod Event
-- @see Object

local pairs = pairs
local Object = require'lucy.object'
local M,_M = Object'Event'
_ENV=M

--- Register an event handler.
-- @tparam function handler
-- @return event handler id, for unregistering
function M:register(handler)
	local id = {}
	self[id] = handler
	return id
end

--- Unregister an event handler.
-- @param id of event handler
-- @treturn function the unreigstered handler
function M:unregister(id)
	local handler = self[id]
	self[id] = nil
	return handler
end

function M:__call(...)
	for _,h in pairs(self) do
		h(...)
	end
end

return M
