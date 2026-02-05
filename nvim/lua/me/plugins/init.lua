-- keep things simple here; only essentials
vim.pack.add({
    "https://github.com/tpope/vim-surround",
    "https://github.com/mfussenegger/nvim-dap",
})
-- config for plugins
require("me.plugins.dap")
