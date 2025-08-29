vim9script

set nocompatible regexpengine=2 laststatus=2 noswapfile
set splitbelow splitright title visualbell ruler showmatch
set ignorecase smartcase autoread autoindent incsearch hlsearch
set updatetime=256 wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=2 tabstop=2 softtabstop=2 shiftround expandtab
set background=dark list lcs=tab:>\ ,trail:-,nbsp:+
&showbreak = '+++ '
colorscheme desert

filetype on
filetype indent on
syntax on

# keep things simple here, only essentials
call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
call plug#end()

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql

nnoremap <C-l> :nohlsearch<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
autocmd QuickFixCmdPost [^l]* cwindow
au FileType help,qf,fugitive,fugitiveblame nnoremap <buffer> q :q<CR>

# generate tags in the background
def GenTags()
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif
  var job = job_start(['ctags', '-G', '-R', '.'], { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' .. string(job)
enddef
command! -nargs=0 Tags GenTags()

nnoremap <silent> - :Explore<CR>
au FileType netrw nnoremap <silent> <buffer> <C-c> :Rex<CR>

# extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m
  nnoremap <Space>g :grep! --fixed-strings ''<Left>
  vnoremap <Space>g "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<Left>
  nnoremap <Space>G :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings ''<Left>
endif
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <Space>s :%s/<C-r><C-w>//gI<Left><Left><Left>
vnoremap <Space>s "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>

# minimal files finding using fzf + rigrep
def FilesCommand()
  const file = trim(system('rg --files --hidden --follow | fzf'))
  if !empty(file)
    execute 'edit ' .. fnameescape(file)
  endif
  execute 'redraw!'
enddef
command! -nargs=0 Files FilesCommand()
nnoremap <Space>f :Files<CR>

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

highlight SignColumn cterm=NONE ctermbg=NONE guibg=NONE
highlight VertSplit cterm=NONE ctermbg=NONE guibg=NONE
highlight StatusLine ctermbg=gray ctermfg=black
highlight StatusLineNC ctermbg=darkgray ctermfg=black

var lsp_opts = {
  ignoreMissingServer: v:true,
  hoverInPreview: v:true,
  omniComplete: v:true,
  showInlayHints: v:true
}
autocmd User LspSetup call LspOptionsSet(lsp_opts)

var lsp_servers = [{
  name: 'clang',
  filetype: ['c', 'cpp', 'proto'],
  path: 'clangd',
  args: ['--background-index']
}, {
  name: 'pylsp',
  filetype: ['python'],
  path: 'pylsp',
  args: []
}, {
  name: 'tsserver',
  filetype: ['javascript', 'typescript'],
  path: 'typescript-language-server',
  args: ['--stdio']
}]
autocmd User LspSetup call LspAddServer(lsp_servers)

def LspConfig()
  setlocal tagfunc=lsp#lsp#TagFunc  # go to definition by C-]
  setlocal formatexpr=lsp#lsp#FormatExpr()  # lsp format using gq
  nnoremap <buffer> gri :LspGotoImpl<CR>
  nnoremap <buffer> grr :LspShowReferences<CR>
  nnoremap <buffer> gra :LspCodeAction<CR>
  nnoremap <buffer> grn :LspRename<CR>
  nnoremap <buffer> ]d :LspDiagNext<CR>
  nnoremap <buffer> [d :LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <buffer> K :LspHover<CR>
enddef
augroup lsp_keymaps
  au!
  au FileType c,cpp,python,javascript,typescript call LspConfig()
augroup END

g:highlightedyank_highlight_duration = 150

au FileType python setl sw=4 ts=4 sts=4 et
au FileType javascript,typescript setl sw=2 ts=2 sts=2 et
au FileType go setl sw=4 ts=4 sts=4 noet fp=gofmt
au FileType json setl sw=4 ts=4 sts=4 noet fp=jq

augroup clang_config
  autocmd!
  autocmd FileType c,cpp if filereadable(findfile('CMakeLists.txt', '.;'))
    | setl sw=4 ts=4 sts=4 et
    | setl makeprg=cmake\ -S\ %:p:h\ -B\ build\ \&\&\ cmake\ --build\ build
    | setl errorformat=%f:%l:%c:\ %m
    | endif
augroup END

augroup java_config
  autocmd!
  autocmd FileType java if filereadable(findfile('pom.xml', '.;'))
    | setl sw=4 ts=4 sts=4 et
    | setl includeexpr=substitute(v:fname,'\\.','/','g')
    | setl makeprg=mvn\ compile
    | setl errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
    | endif
augroup END

defcompile
