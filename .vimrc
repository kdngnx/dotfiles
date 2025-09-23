set nocompatible regexpengine=2 noswapfile splitbelow splitright
set ignorecase smartcase title ruler showmatch autoread autoindent
set incsearch hlsearch visualbell showcmd showmode
set timeout timeoutlen=512 updatetime=256
set wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=2 tabstop=2 softtabstop=2 shiftround expandtab
set notermguicolors background=dark laststatus=2
set list lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax on

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <Space>s :%s/<C-r><C-w>//gI<Left><Left><Left>
vnoremap <Space>s "0y:%s/<C-r>=escape(@0,'/\')<CR>//gI<Left><Left><Left>
vnoremap // "0y/\V<C-r>=escape(@0,'/\')<CR><CR>

nnoremap <C-l> :nohlsearch<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
autocmd QuickFixCmdPost [^l]* cwindow
autocmd FileType help,qf,messages,fugitive,fugitiveblame nnoremap <buffer> q :q<CR>

nnoremap <silent> - :Explore<CR>
autocmd FileType netrw nnoremap <silent> <buffer> <C-c> :Rex<CR>

autocmd BufRead,BufNewFile *.log,*.log{.*} setlocal ft=messages
autocmd BufRead,BufNewFile *.psql setlocal ft=sql
autocmd FileType vim setlocal keywordprg=:help

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

" keep things simple here, only essentials
call plug#begin()
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'machakann/vim-highlightedyank'
Plug 'yegappan/lsp'
Plug 'github/copilot.vim'
call plug#end()

set undodir=~/.vim/undo undofile
colorscheme desert

function! s:gen_tags() abort
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif

  let l:job = job_start(['ctags', '-G', '-R', '.'], { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' . string(l:job)
endfunction
command! -nargs=0 Tags call s:gen_tags()

" extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m

  nnoremap <Space>g :grep! --fixed-strings ''<Left>
  vnoremap <Space>g "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<Left>
  nnoremap <Space>G :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings ''<Left>
endif

function! s:find_complete(arglead, cmdline, cursorpos) abort
  let l:cmd = 'rg --files --hidden --follow | grep -i ' . shellescape(a:arglead)
  return systemlist(l:cmd)
endfunction

function! s:find_command(pattern) abort
  if filereadable(a:pattern)
    execute 'edit' fnameescape(a:pattern)
    return
  endif

  let l:files = s:find_complete(a:pattern, '', 0)
  if len(l:files) == 0
    echohl WarningMsg | echom 'no file matches' | echohl None
    return
  endif
  execute 'edit' fnameescape(l:files[0])
endfunction

" minimal file finder using ripgrep
command! -nargs=1 -complete=customlist,s:find_complete Find call s:find_command(<q-args>)
nnoremap <Space>F :Find <C-r><C-w><C-z>

autocmd FileType go setlocal sw=4 ts=4 sts=4 noet fp=gofmt
autocmd FileType json setlocal sw=4 ts=4 sts=4 et fp=jq

autocmd FileType c,cpp,java,python setlocal sw=4 ts=4 sts=4 et
autocmd FileType c,cpp if filereadable(findfile('CMakeLists.txt', '.;')) |
      \ setlocal makeprg=cmake\ -S\ %:p:h\ -B\ build\ \&\&\ cmake\ --build\ build |
      \ setlocal errorformat=%f:%l:%c:\ %m | endif

autocmd FileType java if filereadable(findfile('pom.xml', '.;')) |
      \ setlocal makeprg=mvn\ compile |
      \ setlocal errorformat=[ERROR]\ %f:[%l\\,%v]\ %m | endif

autocmd FileType javascript,typescript setlocal sw=2 ts=2 sts=2 et
autocmd FileType javascript,typescript if filereadable(findfile('package.json', '.;')) |
      \ setlocal makeprg=npm\ run\ build | endif

highlight StatusLine ctermbg=gray ctermfg=black
highlight StatusLineNC ctermbg=darkgray ctermfg=black
highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=darkgray
highlight SignColumn cterm=NONE ctermbg=NONE

" plugins
let g:highlightedyank_highlight_duration = 150

set rtp+=~/.fzf
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['right,41%,<70(up,41%)']
let g:fzf_layout = { 'down': '41%' }
nnoremap <Space>f :Files<CR>
nnoremap <Space>b :Buffers<CR>

let s:lsp_opts = #{
      \   ignoreMissingServer: v:true,
      \   hoverInPreview: v:true,
      \   omniComplete: v:true,
      \   showInlayHints: v:true
      \ }
autocmd User LspSetup call LspOptionsSet(s:lsp_opts)

let s:lsp_servers = [
      \   #{ name: 'clang', filetype: ['c', 'cpp', 'proto'], path: 'clangd', args: ['--background-index'] },
      \   #{ name: 'pylsp', filetype: ['python'], path: 'pylsp', args: [] },
      \   #{ name: 'tsserver', filetype: ['javascript', 'typescript'], path: 'typescript-language-server', args: ['--stdio'] }
      \ ]
autocmd User LspSetup call LspAddServer(s:lsp_servers)

function! s:lsp_config() abort
  setlocal tagfunc=lsp#lsp#TagFunc  " go to definition by C-]
  setlocal formatexpr=lsp#lsp#FormatExpr()  " lsp format using gq
  nnoremap <silent> <buffer> gi :LspGotoImpl<CR>
  nnoremap <silent> <buffer> gr :LspShowReferences<CR>
  nnoremap <silent> <buffer> gR :LspRename<CR>
  nnoremap <silent> <buffer> K :LspHover<CR>
  nnoremap <silent> <buffer> ]d :LspDiagNext<CR>
  nnoremap <silent> <buffer> [d :LspDiagPrev<CR>
  nnoremap <silent> <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <silent> <buffer> <Space>a :LspCodeAction<CR>
endfunction
autocmd User LspAttached call s:lsp_config()
