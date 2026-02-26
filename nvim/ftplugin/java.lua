local setl = vim.opt_local
local fn = vim.fn

setl.shiftwidth = 4
setl.tabstop = 4
setl.softtabstop = 4
setl.expandtab = true

if #fn.findfile("pom.xml", ".;") > 0 then
    setl.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    setl.makeprg = "mvn compile"

    -- MvnTest current class
    local user_command = vim.api.nvim_create_user_command
    user_command("MvnTest", function(opts)
        local fpath = fn.expand("%:.") -- relative path
        local fname = fn.fnamemodify(fpath, ":t:r")

        -- check if current file is a test file; early exit if not
        local is_test_file = string.match(fname, "[Tt]ests?$")
            or string.find(fpath, "/test/", 1, true)
        assert(is_test_file, "not a test file")

        -- walk up the directory tree to find pom.xml
        local modpath = fn.fnamemodify(fpath, ":h")
        while #modpath > 0 do
            if fn.filereadable(modpath .. "/pom.xml") == 1 then
                break
            end
            modpath = fn.fnamemodify(modpath, ":h")
        end

        -- generate test command
        local test_cmd = { "terminal mvn test -e -DskipTests=false" }
        local config_path = string.format("%s/configuration.properties", fn.getcwd())
        if #modpath > 0 then
            local module = vim.trim(fn.system(string.format(
                "cd %s && mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout", fn.shellescape(modpath))))
            assert(vim.v.shell_error == 0 and #module > 0, "failed to get module name")
            table.insert(test_cmd, " -pl :")
            table.insert(test_cmd, module)

            local mod_config_path = string.format("%s/configuration.properties", modpath)
            if fn.filereadable(mod_config_path) == 1 then
                config_path = mod_config_path
            end
        end -- non-root module

        assert(fn.filereadable(config_path) == 1, "no valid configuration.properties file")
        table.insert(test_cmd, " -Dic.configurationFile=")
        table.insert(test_cmd, config_path)
        table.insert(test_cmd, " -Dlogback.configurationFile=")
        table.insert(test_cmd, fn.getcwd())
        table.insert(test_cmd, "/logback-dev.xml")
        table.insert(test_cmd, " -Dgroups=medium,small")

        -- extract test class name from current file
        local tdir_pattern = "/src/test/java/"
        local tdir_pos = string.find(fpath, tdir_pattern, 1, true)
        assert(tdir_pos, "could not extract test class name")

        local test_class = fpath:sub(tdir_pos + #tdir_pattern):gsub("/", "."):gsub("%.java$", "")
        table.insert(test_cmd, " -Dtest=")
        table.insert(test_cmd, test_class)

        local method_arg = (opts.args and vim.trim(opts.args))
        if #method_arg > 0 then
            table.insert(test_cmd, "\\#")
            table.insert(test_cmd, method_arg)
        end -- add -Dtest optional method name if specified

        -- bang = debug (:MvnTest! or :MvnTest! method)
        if opts.bang then
            table.insert(test_cmd, " -DargLine=")
            table.insert(test_cmd, fn.shellescape("-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=localhost:5155"))
        end -- checkout dap.configurations.java
        vim.cmd(table.concat(test_cmd))
    end, { nargs = "?", bang = true, desc = "run maven test (method); use ! to debug" })
end -- maven
