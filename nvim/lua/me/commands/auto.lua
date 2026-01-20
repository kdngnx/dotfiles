local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local map = vim.keymap.set
local utils = require("me.utils")

-- close some windows quicker using `q` instead of typing :q<CR>
autocmd("FileType", {
    pattern = { "help", "qf", "messages", "checkhealth" },
    callback = function() map("n", "q", cmd.quit, { buffer = 0 }) end
})

-- open the quickfix window whenever a qf command is executed
autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    callback = function() cmd.cwindow() end
})

-- know what has been yanked
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.hl.on_yank({ higroup = "IncSearch", timeout = 128, silent = true })
    end
})

-- open `jdt://` uri and load them into the buffer
autocmd("BufReadCmd", {
    group = augroup("jdtls", { clear = true }),
    pattern = "jdt://*",
    callback = function(args)
        local uri = args.match
        local timeout_ms = 5000
        local client, buf = utils.get_current_client("jdtls", timeout_ms)

        vim.bo[buf].modifiable = true
        vim.bo[buf].swapfile = false
        vim.bo[buf].buftype = "nofile"
        vim.bo[buf].filetype = "java"

        local content
        local function handler(err, result)
            assert(not err, vim.inspect(err))
            assert(result, "jdtls client must return result for java/classFileContents")
            content = result
            local normalized = string.gsub(result, "\r\n", "\n")
            local source_lines = vim.split(normalized, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
            vim.bo[buf].modifiable = false
        end

        client:request("java/classFileContents", { uri = uri }, handler, buf)
        vim.wait(timeout_ms, function() return content ~= nil end)
    end
})
