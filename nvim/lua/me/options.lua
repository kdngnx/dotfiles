local set = vim.opt
local g = vim.g
set.swapfile = false
set.showmatch = true
set.ignorecase = true
set.smartcase = true
set.splitbelow = true
set.splitright = true
set.updatetime = 256
set.timeoutlen = 512
set.shiftwidth = 4
set.tabstop = 4
set.softtabstop = 4
set.expandtab = true
set.shiftround = true
set.showbreak = "+++ "
set.list = true
set.undofile = true
set.title = true
set.visualbell = true
set.cursorline = true
set.number = true
set.termguicolors = false
vim.cmd.colorscheme("retrobox")
set.wildignore = {
    "**/.git/*",
    "**/node_modules/*",
    "**/vendor/*",
    "**/venv/*",
    "**/.venv/*",
    "**/target/*",
    "**/dist/*",
    "**/build/*",
    "**/.cache/*",
    "**/*.so",
    "**/*.o",
    "**/*.dll",
    "**/*.obj",
    "**/*.pyc",
    "**/*.class",
    "**/*.exe",
    "**/*.tmp",
    "**/*.swp",
    "**/*.jpg",
    "**/*.png",
    "**/*.gif",
    "**/*.pdf",
    "**/*.zip",
    "**/*.tar.gz",
    "**/.DS_Store",
}
g.loaded_node_provider = 0
g.loaded_perl_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
