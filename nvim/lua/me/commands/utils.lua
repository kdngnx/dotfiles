local user_command = vim.api.nvim_create_user_command
local log = vim.log.levels
local notify = vim.notify
local fn = vim.fn
local cmd = vim.cmd

-- simple find finder using ripgrep
local function find_complete(pattern)
    local find_cmd = "rg --files --hidden --follow | grep -i " .. fn.shellescape(pattern)
    return fn.systemlist(find_cmd)
end
user_command("Find", function(opts)
    local pattern = opts.args
    if fn.filereadable(pattern) == 1 then
        cmd("edit " .. fn.fnameescape(pattern))
        return
    end
    local files = find_complete(pattern)
    if #files == 0 then
        notify("no file matches", log.WARN)
        return
    end
    cmd("edit " .. fn.fnameescape(files[1]))
end, {
    nargs = 1,
    complete = function(arglead, _, _) return find_complete(arglead) end,
    bang = false
})

user_command("Blame", function()
    local start_line = fn.line("w0") -- first visible line, like H
    local end_line = fn.line("w$")   -- last visible line, like L
    local file = fn.expand("%:p")
    cmd(string.format("!git blame -L %d,%d %s", start_line, end_line, fn.shellescape(file)))
end, { nargs = 0 })

-- remove session files for current repo
user_command("CleanSession", function()
    local common = require("me.common")
    local session_file = common.get_session_filepath()
    if not session_file then
        notify("not in a git repository", log.WARN)
        return
    end

    if fn.filereadable(session_file) == 0 then
        notify("session file does not exist: " .. session_file, log.WARN)
        return
    end

    if fn.delete(session_file) == 0 then
        notify("removed session file: " .. session_file, log.INFO)
    else
        notify("failed to remove session file: " .. session_file, log.ERROR)
    end
end, { nargs = 0 })
