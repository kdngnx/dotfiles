local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true
setlocal.formatprg = "clang-format"

if vim.fn.findfile("CMakeLists.txt", ".;") ~= "" then
    setlocal.errorformat = "%f:%l:%c: %m"
    setlocal.makeprg = "cmake -S . -B build && cmake --build build"
end -- cmake
