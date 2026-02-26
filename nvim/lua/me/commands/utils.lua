local user_command = vim.api.nvim_create_user_command
local log = vim.log.levels
local notify = vim.notify
local fn = vim.fn
local cmd = vim.cmd

-- simple find finder using ripgrep
_G.rg_find_func = function(cmd_arg, _)
    local ok, files = pcall(fn.systemlist, "rg --files --hidden --follow")
    if not ok or not files then
        return {}
    end
    if type(cmd_arg) == "string" and #cmd_arg > 0 then
        local lower = cmd_arg:lower()
        files = vim.tbl_filter(function(f)
            return f:lower():find(lower, 1, true) ~= nil
        end, files)
    end -- case-insensitive filter
    return files
end     -- returns list of file path strings
vim.opt.findfunc = "v:lua.rg_find_func"

user_command("Blame", function()
    cmd(string.format("!git blame -L %d,%d %s", fn.line("w0"), fn.line("w$"), fn.shellescape(fn.expand("%:p"))))
end, { nargs = 0 })

-- remove session files for current repo
user_command("CleanSession", function()
    local sfile = require("me.common").get_session_filepath()
    assert(sfile and fn.filereadable(sfile) == 1, "no session found")
    assert(fn.delete(sfile) == 0, "failed to remove session file: " .. sfile)
    notify("removed session file: " .. sfile, log.INFO)
end, { nargs = 0 })
