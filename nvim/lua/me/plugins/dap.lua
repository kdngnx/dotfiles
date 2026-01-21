local utils = require("me.utils")
local dap = require("dap")
local map = vim.keymap.set

map("n", "<Space>db", dap.toggle_breakpoint)
map("n", "<Up>", dap.continue)
map("n", "<Down>", dap.step_into)
map("n", "<Right>", dap.step_over)
map("n", "<Left>", dap.step_out)
map("n", "<Space>dr", function() dap.repl.open({ height = 15 }) end)

dap.adapters.java = function(callback)
    local client, buf = utils.get_current_client("jdtls", 5000)
    client:request("workspace/executeCommand",
        { command = "vscode.java.startDebugSession" },
        function(err, port)
            assert(not err, vim.inspect(err))
            callback({
                type = "server",
                host = "127.0.0.1",
                port = port
            })
        end, buf)
end

-- just general use cases
-- project specific configs are located in launch.json
dap.configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Java Debug (Attach) - Local 5055",
        hostName = "localhost",
        port = 5055,
        timeout = 5000
    },
    {
        type = "java",
        request = "attach",
        name = "Java Debug (Attach) - Remote 5005",
        hostName = "localhost",
        port = 5005,
        timeout = 30000
    }
}
