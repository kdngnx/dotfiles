local M = {}
local lsp = vim.lsp

function M.get_active_lsp_client(ls_name)
    local buf = vim.api.nvim_get_current_buf()
    local client = lsp.get_clients({ name = ls_name })[1]
    if not client then
        vim.wait(5000, function()
            return next(lsp.get_clients({ name = ls_name, bufnr = buf })) ~= nil
        end)
        client = lsp.get_clients({ name = ls_name, bufnr = buf })[1]
    else
        vim.lsp.buf_attach_client(buf, client.id)
    end
    assert(client, "must have a `" .. ls_name .. "` client configured")
    return client, buf
end

return M
