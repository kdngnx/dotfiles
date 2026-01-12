vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.log", "*.log{.*}" },
    callback = function() vim.opt_local.filetype = "messages" end
})
