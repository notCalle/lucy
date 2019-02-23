local Class = require'lucy.class'
local Mixin = require'lucy.mixin'

describe("a mixin", function()
    it("can instantiate itself into a class",
    function()
        local mixin = Mixin'Inmixer'
        local klass = Class'Klass'
        assert.has.no.errors(function() return klass+mixin end)
    end)

    context("instantiated in a class",
    function()
        local mixin = Mixin'Inmixer'
        function mixin:method() end

        it("has a partial order over instances",
        function()
            local klass = Class'Klass'+mixin
            assert.is_true(mixin <= klass)
        end)

        it("copies its methods, if unique",
        function()
            local klass = Class'Klass'+mixin
            assert.is_function(klass.method)
            assert.is.equal(klass.method,mixin.method)
        end)

        it("fails when there is a method name conflict",
        function()
            local klass = Class'Klass'+mixin
            assert.has.error(function() return klass+mixin end,
                             "Inmixer: Klass.method already defined")
        end)

        it("can rename methods to avoid conflicts",
        function()
            local klass = Class'Klass'+mixin%{method="new_method"}
            assert.is.equal(klass.new_method,mixin.method)
        end)
    end)
end)

