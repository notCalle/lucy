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
        ["lucy.list"] = "src/lucy/list.lua",
        ["lucy.mixin"] = "src/lucy/mixin.lua",
        ["lucy.object"] = "src/lucy/object.lua",
        ["lucy.queue"] = "src/lucy/queue.lua",
        ["lucy.singleton"] = "src/lucy/singleton.lua"
    }
}
