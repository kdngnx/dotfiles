local map = vim.keymap.set
local lsp = vim.lsp
local log = vim.log.levels
local notify = vim.notify

-- consistent behaviours across language servers
vim.diagnostic.config({ virtual_text = true, underline = true })
lsp.config("*", {
    on_attach = function(client, bufnr)
        lsp.semantic_tokens.enable(false)
        lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
        lsp.inlay_hint.enable(true)

        -- see `:help vim.lsp.*` for documentation on any of the below functions
        map("n", "gi", lsp.buf.implementation)
        map("n", "gr", lsp.buf.references)
        map("n", "gu", function()
            lsp.buf.references({ includeDeclaration = false })
        end) -- show usages only
        map("n", "<C-w>a", lsp.buf.code_action)
        map("n", "<C-h>", lsp.buf.document_symbol)
        map("i", "<C-k>", lsp.buf.signature_help)

        -- log language server status
        vim.lsp.handlers["language/status"] = function(_, result, _)
            local msg = result.message or "(no message)"
            notify(string.format("lsp [%s]: %s", client.name, msg), log.INFO)
        end
    end,
    detached = true
})

-- server configs, usually just launch cmd, applicable filetypes and root marker
-- some specific language settings can be applied too
require("me.lsp.clangd")
require("me.lsp.jdtls")
require("me.lsp.pyright")
require("me.lsp.luals")
require("me.lsp.tsserver")

-- can be disabled by `:lua vim.lsp.enable("tsserver", false)` for example
lsp.enable({ "clangd", "jdtls", "pyright", "luals", "tsserver" })
