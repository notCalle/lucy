rockspec_format = "3.0"
package = "lucy"
version = "scm-1"
source = {
    url = "git+https://github.com/notcalle/lucy.git",
    branch = "master"
}
description = {
    summary = "A Lua Class System",
    homepage = "https://github.com/notcalle/lucy",
    license = "MIT",
    maintainer = "Calle Englund <calle@bofh.se>",
    labels = { "class", "oop" }
}
dependencies = {
    "lua ~> 5.3"
}
build = {
    type = "builtin",
    modules = {
        lucy = "src/lucy.lua",
        ["lucy.class"] = "src/lucy/class.lua",
        ["lucy.dag"] = "src/lucy/dag.lua",
        ["lucy.list"] = "src/lucy/list.lua",
        ["lucy.graph"] = "src/lucy/graph.lua",
        ["lucy.mixin"] = "src/lucy/mixin.lua",
        ["lucy.object"] = "src/lucy/object.lua",
        ["lucy.queue"] = "src/lucy/queue.lua",
        ["lucy.set"] = "src/lucy/set.lua",
        ["lucy.singleton"] = "src/lucy/singleton.lua",
        ["lucy.tree"] = "src/lucy/tree.lua",
    }
}
