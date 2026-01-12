vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.psql" },
    callback = function() vim.opt_local.filetype = "sql" end
})
