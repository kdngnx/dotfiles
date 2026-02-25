local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set
local common = require("me.common")

-- close some windows quicker using `q` instead of typing :bd<CR>
autocmd("FileType", {
    pattern = { "help", "qf", "messages", "checkhealth" },
    callback = function() map("n", "q", cmd.bdelete, { buffer = 0 }) end
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
    group = augroup("jdtls_class_file_content", { clear = true }),
    pattern = "jdt://*",
    callback = function(args)
        local client, buf = common.get_active_lsp_client("jdtls")
        local uri = args.match
        local bo = vim.bo

        bo[buf].modifiable = true
        bo[buf].swapfile = false
        bo[buf].buftype = "nofile"
        bo[buf].filetype = "java"

        local content
        local function handler(err, result)
            assert(not err, vim.inspect(err))
            assert(result, "jdtls client must return result for java/classFileContents")
            content = result
            local normalized = string.gsub(result, "\r\n", "\n")
            local source_lines = vim.split(normalized, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, source_lines)
            bo[buf].modifiable = false
        end

        client:request("java/classFileContents", { uri = uri }, handler, buf)
        vim.wait(5000, function() return content ~= nil end)
    end
})

-- don't do sessionize stuff if opening specific files
local wd = vim.v.argv[3]
if not wd or wd == "." then
    autocmd("BufWritePost", {
        group = augroup("session_auto_save", { clear = true }),
        pattern = "*",
        callback = function()
            local sfile = common.get_session_filepath()
            if sfile then cmd("mksession! " .. fn.fnameescape(sfile)) end
        end
    })

    autocmd("VimEnter", {
        group = augroup("session_auto_load", { clear = true }),
        pattern = "*",
        callback = function()
            local sfile = common.get_session_filepath()
            if sfile and fn.filereadable(sfile) == 1 then cmd("source " .. fn.fnameescape(sfile)) end
        end
    })
end
