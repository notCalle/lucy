LUA ?= lua
.PHONY: test
test:
	busted -v --lua=$(LUA)

.PHONY: coverage
coverage:
	busted -c --lua=$(LUA)
	luacov
	@awk '(S==0){}/^Summary/{S=1}(S==1){print}' < luacov.report.out

.PHONY: docs
docs:
	ldoc -d docs src

.PHONY: clean
clean:
	-rm luacov.*.out

.PHONY: rocks
rocks: clean coverage docs
	luarocks make rockspecs/lucy-scm-1.rockspec
