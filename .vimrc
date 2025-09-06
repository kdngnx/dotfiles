vim9script

set nocompatible regexpengine=2 laststatus=2 noswapfile
set splitbelow splitright title visualbell ruler showmatch
set ignorecase smartcase autoread autoindent incsearch hlsearch
set updatetime=256 wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=2 tabstop=2 softtabstop=2 shiftround expandtab
set termguicolors background=dark list lcs=tab:>\ ,trail:-,nbsp:+
&showbreak = '+++ '

filetype on
filetype indent on
syntax on

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer <C-z>
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

autocmd BufRead,BufNewFile *.log,*.log{.*} setl ft=messages
autocmd BufRead,BufNewFile *.psql setl ft=sql
autocmd FileType vim setl keywordprg=:help

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

# keep things simple here, only essentials
packadd vim-fugitive
packadd vim-surround
packadd vim-highlightedyank
packadd lsp

set undodir=~/.vim/undo undofile
colorscheme desert

def GenTags()
  if !executable('ctags')
    echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
    return
  endif
  const job = job_start(['ctags', '-G', '-R', '.'], { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
  echomsg 'generate tags..., id: ' .. string(job)
enddef
command! -nargs=0 Tags GenTags()

# extend vim grep abilities with ripgrep, result can be accessible through qf list
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --no-heading\ --column
  set grepformat^=%f:%l:%c:%m
  nnoremap <Space>g :grep! --fixed-strings ''<Left>
  vnoremap <Space>g "0y:grep! --case-sensitive --fixed-strings '<C-r>0'<Left>
  nnoremap <Space>G :grep! --case-sensitive --fixed-strings '<C-r><C-w>'<CR>
  nnoremap <Space>/ :grep! --hidden --no-ignore --fixed-strings ''<Left>
endif

def FilesCommand()
  const file = trim(system('rg --files --hidden --follow | fzf'))
  if !empty(file)
    execute 'edit ' .. fnameescape(file)
  endif
  execute 'redraw!'
enddef
command! -nargs=0 Files FilesCommand()
nnoremap <Space>f :Files<CR>

autocmd FileType go setl shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab formatprg=gofmt
autocmd FileType json setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab formatprg=jq

augroup clangrc
  autocmd!
  autocmd FileType c,cpp setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType c,cpp if filereadable(findfile('CMakeLists.txt', '.;'))
    | setl makeprg=cmake\ -S\ %:p:h\ -B\ build\ \&\&\ cmake\ --build\ build
    | setl errorformat=%f:%l:%c:\ %m
    | endif
augroup END

augroup javarc
  autocmd!
  autocmd FileType java setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab
  autocmd FileType java if filereadable(findfile('pom.xml', '.;'))
    | setl makeprg=mvn\ compile
    | setl errorformat=[ERROR]\ %f:[%l\\,%v]\ %m
    | endif
augroup END

augroup pythonrc
  autocmd!
  autocmd FileType python setl shiftwidth=4 tabstop=4 softtabstop=4 expandtab
augroup END

augroup javascriptrc
  autocmd!
  autocmd FileType javascript,typescript setl shiftwidth=2 tabstop=2 softtabstop=2 expandtab
  autocmd FileType javascript,typescript if filereadable(findfile('package.json', '.;'))
    | setl makeprg=npm\ run\ build
    | endif
augroup END

highlight StatusLine ctermbg=gray guibg=gray ctermfg=black guifg=black
highlight StatusLineNC ctermbg=darkgray guibg=darkgray ctermfg=black guifg=black
highlight VertSplit cterm=NONE ctermbg=NONE ctermfg=darkgray guibg=NONE guifg=darkgray
highlight SignColumn cterm=NONE ctermbg=NONE guibg=NONE

# plugins
g:highlightedyank_highlight_duration = 150

call LspAddServer([{
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
}])

call LspOptionsSet({
  ignoreMissingServer: v:true,
  hoverInPreview: v:true,
  omniComplete: v:true,
  showInlayHints: v:true
})

def LspConfig()
  setl tagfunc=lsp#lsp#TagFunc  # go to definition by C-]
  setl formatexpr=lsp#lsp#FormatExpr()  # lsp format using gq
  nnoremap <buffer> gri :LspGotoImpl<CR>
  nnoremap <buffer> grr :LspShowReferences<CR>
  nnoremap <buffer> gra :LspCodeAction<CR>
  nnoremap <buffer> grn :LspRename<CR>
  nnoremap <buffer> ]d :LspDiagNext<CR>
  nnoremap <buffer> [d :LspDiagPrev<CR>
  nnoremap <buffer> <C-w>d :LspDiagCurrent<CR>
  nnoremap <buffer> K :LspHover<CR>
enddef
autocmd User LspAttached call LspConfig()

defcompile
