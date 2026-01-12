local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true

if vim.fn.findfile("init.lua", ".;") ~= "" then
    setlocal.keywordprg = ":help"
end -- quick vim help
