local parsers = {
    "c", "cpp", "zig", "java", "python", "lua", "javascript", "typescript", "bash",
    "fish", "json", "markdown", "diff", "sql", "html", "xml", "clojure", "terraform"
}
require("nvim-treesitter").install(parsers)
vim.api.nvim_create_autocmd("FileType", {
    pattern = parsers,
    callback = function(args)
        vim.treesitter.start()
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
