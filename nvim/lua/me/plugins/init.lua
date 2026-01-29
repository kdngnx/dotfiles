-- keep things simple here; only essentials
vim.pack.add({
    "https://github.com/sainnhe/gruvbox-material",
    "https://github.com/tpope/vim-surround",
    "https://github.com/mhinz/vim-signify",
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-treesitter/nvim-treesitter"
})

-- config for plugins
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
require("me.plugins.dap")
require("me.plugins.treesitter")
