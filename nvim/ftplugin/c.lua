local setl = vim.opt_local
setl.shiftwidth = 4
setl.tabstop = 4
setl.softtabstop = 4
setl.expandtab = true
setl.formatprg = "clang-format"

if #vim.fn.findfile("CMakeLists.txt", ".;") > 0 then
    setl.errorformat = "%f:%l:%c: %m"
    setl.makeprg = "cmake -S . -B build && cmake --build build"
end -- cmake
