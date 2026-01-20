local utils = require("me.utils")
local dap = require("dap")

dap.adapters.java = function(callback)
    local client, buf = utils.get_current_client("jdtls", 5000)
    client:request("workspace/executeCommand", { command = "vscode.java.startDebugSession" }, function(err, port)
        assert(not err, vim.inspect(err))
        callback({
            type = "server",
            host = "127.0.0.1",
            port = port
        })
    end, buf)
end

dap.configurations.java = {
    {
        type = "java",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 5005,
        timeout = 30000
    },
}
