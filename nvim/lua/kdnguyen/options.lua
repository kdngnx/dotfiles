-- set default regexp engine to nfa
vim.opt.regexpengine = 2
vim.opt.swapfile = true
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.updatetime = 100
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.undofile = true
vim.opt.foldenable = false
vim.opt.title = true
vim.opt.visualbell = true
vim.opt.list = true
vim.opt.showbreak = "+++ "
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
require("vim._extui").enable({
    enable = true,
    msg = { target = "cmd" },
})
