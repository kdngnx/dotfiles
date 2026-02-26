local M = {}

local lsp = vim.lsp
local fn = vim.fn

function M.get_active_lsp_client(lsname)
    local buf = vim.api.nvim_get_current_buf()
    local filters = { name = lsname }
    local client = lsp.get_clients(filters)[1]

    if not client then
        filters["bufnr"] = buf
        vim.wait(5000, function() return next(lsp.get_clients(filters)) ~= nil end)
        client = lsp.get_clients(filters)[1]
    else
        vim.lsp.buf_attach_client(buf, client.id)
    end

    assert(client, string.format("must have a `%s` client configured", lsname))
    return client, buf
end

function M.get_session_filepath()
    local branch = vim.trim(fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"))
    if vim.v.shell_error ~= 0 or #branch == 0 then
        return nil
    end -- returns nil as we want silent exit

    local repo_path = fn.getcwd():gsub("/", "")
    assert(repo_path, "invalid repo path")

    local name = string.format("%s_%s", repo_path, branch)
    local sessions_dir = fn.stdpath("state") .. "/sessions"
    if fn.isdirectory(sessions_dir) == 0 then
        fn.mkdir(sessions_dir, "p")
    end -- first run only

    return string.format("%s/%s.vim", sessions_dir, name)
end

return M
