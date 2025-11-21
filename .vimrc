set nocompatible
set regexpengine=2 noswapfile splitbelow splitright
set ignorecase smartcase title ruler showmatch autoread autoindent
set incsearch hlsearch visualbell showcmd showmode
set timeout timeoutlen=512 updatetime=256
set wildmenu wildoptions=pum,tagfile wildcharm=<C-z>
set shiftwidth=4 tabstop=4 softtabstop=4 shiftround expandtab
set background=dark laststatus=2
set wrap list lcs=tab:>\ ,trail:-,nbsp:+
let &showbreak = '+++ '

filetype on
filetype indent on
syntax enable

nnoremap <Space>e :edit %:h<C-z>
nnoremap <Space>b :buffer 
nnoremap <C-l> :nohlsearch<CR>
nnoremap <silent> - :Explore<CR>
autocmd FileType netrw nnoremap <silent> <buffer> <C-c> :Rexplore<CR>
autocmd FileType help,qf,messages nnoremap <buffer> q :q<CR>
autocmd QuickFixCmdPost [^l]* cwindow

autocmd BufRead,BufNewFile *.log,*.log{.*} setlocal ft=messages
autocmd BufRead,BufNewFile *.psql setlocal ft=sql
autocmd FileType vim setlocal keywordprg=:help

nnoremap <Space>y "+y
vnoremap <Space>y "+y
nnoremap <Space>p "+p
nnoremap <Space>P "+P
vnoremap <Space>p "+p

" keep things simple here, only essentials
set termguicolors undofile undodir=~/.vim/undo
colorscheme retrobox

function! s:gen_tags() abort
    if !executable('ctags')
        echohl WarningMsg | echomsg 'no ctags installation found' | echohl None
        return
    endif
    let l:job = job_start(['ctags', '-G', '-R', '.'],
                \ { 'in_io': 'null', 'out_io': 'null', 'err_io': 'null' })
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
nnoremap <Space>f :Find 
nnoremap <Space>F :Find <C-r><C-w><C-z>

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

autocmd FileType json setlocal sw=4 ts=4 sts=4 et fp=jq
autocmd FileType go setlocal sw=4 ts=4 sts=4 noet fp=gofmt
