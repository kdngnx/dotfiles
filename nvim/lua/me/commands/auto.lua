local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local map = vim.keymap.set

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
