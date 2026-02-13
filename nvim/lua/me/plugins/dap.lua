local common = require("me.common")
local dap = require("dap")
local map = vim.keymap.set
local fn = vim.fn

map("n", "<C-w>b", dap.toggle_breakpoint)
map("n", "<Up>", dap.continue)
map("n", "<Down>", dap.step_into)
map("n", "<Right>", dap.step_over)
map("n", "<Left>", dap.step_out)
map("n", "<C-w><C-b>", function() dap.repl.open({ height = 15 }) end)

dap.adapters.java = function(callback)
    local client, buf = common.get_active_lsp_client("jdtls")
    client:request("workspace/executeCommand",
        { command = "vscode.java.startDebugSession" },
        function(err, port)
            assert(not err, vim.inspect(err))
            callback({ type = "server", host = "localhost", port = port })
        end, buf)
end

-- run `set -x JDK_JAVA_OPTIONS "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=localhost:5055"` to turn on debug agent
-- use `set -e JDK_JAVA_OPTIONS` to erase the env variable

-- project specific configs are located in launch.json
-- these are configs for general use cases only
dap.configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Local 5055",
        hostName = "localhost",
        port = 5055,
        timeout = 5000
    },
    {
        type = "java",
        request = "attach",
        name = "Test Debug (Attach) - Local 5155",
        hostName = "localhost",
        port = 5155,
        timeout = 5000
    },
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = function()
            return fn.input("remote_host: ", "localhost")
        end,
        port = function()
            return tonumber(fn.input("port: ", "5005")) or 5005
        end,
        timeout = 30000
    }
}
