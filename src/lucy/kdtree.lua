--- A k dimensional binary search tree
-- @classmod KDTree

local Tree = require'lucy.tree'
local List = require'lucy.list'
local M,_M = List'KDTree'+Tree
_ENV=M

function M:__init()
    local size = #self
    if size < 2 then return end

    local dim = self._dim or #self[1]
    local depth = self._depth or 0
    local axis = depth%dim + 1
    self:sort(function(lhs,rhs) return lhs[axis] > rhs[axis] end)

    local left = List{_dim=dim,_depth=depth+1}
    local right = List{_dim=dim,_depth=depth+1}
    local split = size//2
    self._min = self[1][axis]
    self._split = (self[split][axis]+self[split+1][axis])/2
    self._max = self[size][axis]
    for i=1,split do left:insert(self:remove()) end
    for i=split+1,size do right:insert(self:remove()) end
    return self^{self.class(left),self.class(right)}
end

return M
