vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.mdc" },
    callback = function() vim.opt_local.filetype = "markdown" end
})
