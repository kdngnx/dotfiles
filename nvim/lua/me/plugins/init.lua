-- keep things simple here; only essentials
vim.pack.add({
    "https://github.com/mhinz/vim-signify",
    "https://codeberg.org/mfussenegger/nvim-dap",
})
-- config for plugins
require("me.plugins.dap")
