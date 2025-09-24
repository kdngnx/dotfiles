local map = vim.keymap.set
local set = vim.opt
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd

-- unify command mode keys with shell
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")

-- extend vim grep abilities with ripgrep, result can be accessible through qf list
if vim.fn.executable("rg") > 0 then
    set.grepprg = "rg --vimgrep --smart-case --no-heading --column"
    set.grepformat:prepend("%f:%l:%c:%m")
    map("n", "<Space>g", [[:silent grep! --fixed-strings ''<Left>]])
    map("v", "<Space>g", [["0y:silent grep! --case-sensitive --fixed-strings '<C-r>0'<Left>]])
    map("n", "<Space>G", [[:silent grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>]])
    map("n", "<Space>/", [[:silent grep! --hidden --no-ignore --fixed-strings ''<Left>]])
end

-- some proper ways to browse/search marked text
map("v", "//", [["0y/\V<C-r>=escape(@0,'/\')<CR><CR>]])
map("n", "<Space>e", [[:edit %:h<C-z>]])

-- replace word/marked text
map("n", "<Space>s", [[:%s/<C-r><C-w>//gI<Left><Left><Left>]])
map("v", "<Space>s", [["0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>]])

-- copy to system clipboard, all motions after `<Space>y` work the same as normal `y`
map({ "n", "v" }, "<Space>y", [["+y]])
map({ "n", "v" }, "<Space>p", [["+p]])
map("n", "<Space>P", [["+P]])

-- better keymap to toggle netrw
map("n", "-", cmd.Explore)
autocmd("FileType", {
    pattern = "netrw",
    callback = function() map("n", "<C-c>", cmd.Rexplore, { buffer = 0 }) end
})
