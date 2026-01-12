vim.lsp.config("pylsp", {
    cmd = { "pylsp" },
    filetypes = { "python" },
    -- root_markers = {
    --     "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
    --     "Pipfile", "pyrightconfig.json", ".git"
    -- },
    root_dir = vim.uv.cwd(),
    settings = {
        pylsp = {
            plugins = { pycodestyle = { ignore = { "W391" }, maxLineLength = 150 } }
        }
    }
})
