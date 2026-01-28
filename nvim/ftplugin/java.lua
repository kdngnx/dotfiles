local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true

if vim.fn.findfile("pom.xml", ".;") ~= "" then
    setlocal.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    setlocal.makeprg = "mvn clean compile -U"

    -- MvnTest current class
    local user_command = vim.api.nvim_create_user_command
    local fn = vim.fn
    local notify = vim.notify
    local log = vim.log.levels

    user_command("MvnTest", function(opts)
        local file_path = fn.expand("%:.") -- relative path
        local file_name = fn.fnamemodify(file_path, ":t:r")
        local is_test_file = string.match(file_name, "Test$")
            or string.match(file_name, "Tests$")
            or string.find(file_path, "/test/", 1, true) ~= nil

        -- check if current file is a test file; early exit if not
        if not is_test_file then
            notify("not a test file.", log.ERROR)
            return
        end

        -- walk up the directory tree to find pom.xml
        local module_dir = fn.fnamemodify(file_path, ":h")
        local found = false
        while module_dir ~= "" and module_dir ~= "." do
            local test_pom = module_dir .. "/pom.xml"
            if fn.filereadable(test_pom) == 1 then
                found = true
                break
            end
            module_dir = fn.fnamemodify(module_dir, ":h")
        end
        if not found then
            notify("could not find pom.xml", log.ERROR)
            return
        end

        local module_name = fn.system("cd " ..
            fn.shellescape(module_dir) .. " && mvn help:evaluate -Dexpression=project.artifactId -q -DforceStdout")
        module_name = vim.trim(module_name)
        if module_name == "" or vim.v.shell_error ~= 0 then
            notify("failed to get module name", log.ERROR)
            return
        end

        -- get current module configuration.properties
        local config_path = module_dir .. "/configuration.properties"
        local project_root = fn.getcwd()
        if fn.filereadable(config_path) ~= 1 then
            config_path = project_root .. "/configuration.properties"
        end -- otherwise default to project root

        -- extract test class name from current file
        local test_dir_pattern = "/src/test/java/"
        local test_dir_pos = string.find(file_path, test_dir_pattern, 1, true)
        if not test_dir_pos then
            notify("could not extract test class name", log.ERROR)
            return
        end
        local relative_path = string.sub(file_path, test_dir_pos + #test_dir_pattern)
        local test_class = string.gsub(relative_path, "/", ".")
        test_class = string.gsub(test_class, "%.java$", "")

        local test_cmd = "mvn test -e -DskipTests=false"
            .. " -Dic.configurationFile=" .. config_path
            .. " -Dlogback.configurationFile=" .. fn.getcwd() .. "/logback-dev.xml"
            .. " -pl :" .. module_name .. " -Dgroups=medium,small"
            .. " -Dtest=" .. test_class

        if opts.args and opts.args ~= "" then
            test_cmd = test_cmd .. "\\#" .. opts.args
        end -- add -Dtest optional method name if specified

        vim.cmd("terminal " .. test_cmd)
    end, { nargs = "?", desc = "run maven test" })
end -- maven
