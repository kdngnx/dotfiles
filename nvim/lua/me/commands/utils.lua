local user_command = vim.api.nvim_create_user_command
local log = vim.log.levels
local notify = vim.notify
local fn = vim.fn
local cmd = vim.cmd

-- generate tags in the background
user_command("Tags", function()
    if fn.executable("ctags") == 0 then
        notify("no ctags installation found", log.WARN)
        return
    end
    local job = vim.system({ "ctags", "-R", "--exclude=dist", "." }, { text = true })
    notify("generate tags..., pid: " .. job.pid, log.INFO)
end, { nargs = 0 })

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
