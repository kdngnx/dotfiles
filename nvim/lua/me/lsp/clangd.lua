vim.lsp.config("clangd", {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "proto" },
    root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", ".git" }
})
