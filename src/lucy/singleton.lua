--- Singleton mixin, makes the target a single instance class.
-- @classmod Singleton
-- @usage
-- Object = require'lucy.object'
-- Singleton = require'lucy.singleton'
-- MyObj = Object'MyObj'+Singleton
-- MyObj{} == MyObj{}
-- @see Mixin
-- @see Object
local Mixin = require'lucy.mixin'
local M = Mixin'Singleton'
_ENV=M

local function _instance(self,I)
    self.__instance = self.__instance or self:_instance(I)
    return self.__instance
end

function M:instance(T)
    T._instance = T:super'instance'
    Mixin.instance(self,T)
    T.instance = _instance
end

return M
