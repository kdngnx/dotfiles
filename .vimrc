set nocompatible
set regexpengine=2 noswapfile splitbelow splitright
set ignorecase smartcase title ruler showmatch autoread autoindent
set incsearch hlsearch visualbell showcmd showmode
set timeout timeoutlen=512 updatetime=256
set wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=4 tabstop=4 softtabstop=4 shiftround expandtab
set notermguicolors background=dark laststatus=2
set wrap list lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax enable

nmap <Space>b :buffer 
nmap <Space>e :edit %:h<C-z>
nmap <C-l> :nohlsearch<CR>
nmap <silent> - :Ex<CR>
nmap <Space>y "+y
vmap <Space>y "+y
nmap <Space>p "+p
nmap <Space>P "+P
vmap <Space>p "+p

au QuickFixCmdPost [^l]* cwindow
au BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
au BufRead,BufNewFile *.psql setl ft=sql
au FileType netrw nmap <silent> <buffer> <C-c> :Rex<CR>
au FileType help,qf,messages nmap <buffer> q :q<CR>
au FileType vim setl keywordprg=:help
