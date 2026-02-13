local map = vim.keymap.set
local cmd = vim.cmd
local set = vim.opt

-- extend vim grep abilities with ripgrep
if vim.fn.executable("rg") > 0 then
    set.grepprg = "rg --vimgrep --smart-case --no-heading --column"
    set.grepformat:prepend("%f:%l:%c:%m")
    -- add `--hidden --no-ignore` for wildcard
    map("n", "<C-_>", [[:silent grep! ]]) -- also mean <C-/>
    map("v", "<C-_>", [["0y:silent grep! --case-sensitive <C-r>0]])
end -- result can be accessible through qf list

-- some proper ways to browse/search
map("n", "<C-p>", [[:find ]])
map("n", "<C-j>", [[:edit %:h<C-z><C-z>]])
map("n", "<C-n>", [[:buffer ]])
map("n", "<Tab>", [[:edit #<CR>]])

-- copy to system clipboard, all motions after `<C-w>y` work the same as normal `y`
map({ "n", "v" }, "<C-w>y", [["+y]])
map({ "n", "v" }, "<C-w>p", [["+p]])
map("n", "<C-w><C-p>", [["+P]])

-- command mode navigation
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")
map("c", "<M-BS>", "<C-w>")
map("c", "<M-Left>", "<C-Left>")
map("c", "<M-Right>", "<C-Right>")

-- better keymap to toggle netrw
map("n", "-", cmd.Explore)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function() map("n", "<C-c>", cmd.Rexplore, { buffer = 0 }) end
})
