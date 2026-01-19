local setlocal = vim.opt_local
setlocal.shiftwidth = 4
setlocal.tabstop = 4
setlocal.softtabstop = 4
setlocal.expandtab = true

if vim.fn.findfile("pom.xml", ".;") ~= "" then
    setlocal.errorformat = "[ERROR] %f:[%l\\,%v] %m"
    setlocal.makeprg = "mvn clean compile"
end -- maven
