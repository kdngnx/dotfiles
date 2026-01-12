vim.lsp.config("tsserver", {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "typescript" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
    init_options = { hostInfo = "neovim" },
})
