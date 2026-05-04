" set background=light

" not support vi
set nocompatible

set timeout
set timeoutlen=300

" file encoding
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gbk,gb2312,cp936,latin1
set fileformats=unix,dos,mac

" history and cmd completion
set history=500
set wildmenu
set wildmode=longest:full,full

" line number
set number

" set prefix space and tab
set list
" set listchars=tab:▸\ ,space:·,trail:×
set listchars=tab:..,trail:+,extends:>,precedes:<,nbsp:~

" line position ui
set ruler
set showcmd

" statusline
set laststatus=2
set showmode

" search
set hlsearch
set incsearch
set ignorecase
set smartcase

" indent
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set showmatch
set matchtime=2
set nowrap
set scrolloff=3
set sidescrolloff=5

set backspace=indent,eol,start

set hidden

set nobackup
set nowritebackup
set noswapfile

" better split window behaviour
if exists('&splitright')
    set splitright
endif
if exists('&splitbelow')
    set splitbelow
endif

if has('mouse')
    set mouse=a
endif

if has('syntax')
    syntax on
endif

if has('autocmd')
    filetype plugin indent on
endif

if has('termguicolors')
"    set termguicolors
endif

" persist undo file
if exists('+undofile')
    set undofile
    if isdirectory($HOME . '/.vim')
        set undodir=~/.vim/undo
    endif
endif



let mapleader = " "

set pastetoggle=<F2>

" split window
nnoremap <Bar> :vsplit<CR>
nnoremap \ :split<CR>

" indent on visual mode
vnoremap < <gv
vnoremap > >gv

" change window
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" save
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

" clear search highlight
nnoremap <Leader><Space> :nohlsearch<CR>

" resource vimrc
nnoremap <Leader>sv :source $MYVIMRC<CR>

" BufferLine {{{

set showtabline=2
set tabline=%!MyBufferLine()

function! s:GetListedBuffers() abort
    return filter(range(1, bufnr('$')), 'buflisted(v:val)')
endfunction

function! MyBufferLine() abort
    let l:buffers = s:GetListedBuffers()
    let l:line = ''
    if empty(l:buffers)
        return ''
    endif
    for l:i in range(0, len(l:buffers) - 1)
        let l:bufnr = l:buffers[l:i]
        let l:index = l:i + 1
        let l:name = bufname(l:bufnr)

        if empty(l:name)
            let l:name = '[No Name]'
        else
            let l:name = fnamemodify(l:name, ':t')
        endif

        let l:modified = getbufvar(l:bufnr, '&modified') ? '+' : ''

        if l:bufnr == bufnr('%')
            let l:line .= '%#TabLineSel#'
        else
            let l:line .= '%#TabLine#'
        endif

        let l:line .= ' ' . l:index . ':' . l:name . l:modified . ' '
        let l:line .= '%#TabLineFill#|'
    endfor
    return l:line
endfunction

function! s:GotoBufferByIndex(index) abort
    let l:buffers = s:GetListedBuffers()
    if a:index < 1 || a:index > len(l:buffers)
        echohl WarningMsg
        echom 'No such buffer index: ' . a:index
        echohl None
        return
    endif

    let l:bufnr = l:buffers[a:index - 1]
    execute 'buffer ' . l:bufnr
endfunction

for i in range(1, 9)
    execute printf(
        \ 'nnoremap <silent> <leader>b%d :<C-u>call <SID>GotoBufferByIndex(%d)<CR>',
        \ i, i
        \ )
endfor

" BufferLine }}}

" BuferKeymap {{{
" nnoremap <Leader>bn :bnext<CR>
" nnoremap <Leader>bp :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap <Leader>bb :b#<CR>
nnoremap <Leader>bd :bdelete<CR>
nnoremap <Leader>bl :ls<CR>:buffer<Space>
function! s:CloseWindowAndDeleteBuffer() abort
    let l:bnr = bufnr('%')
    if winnr('$') > 1
        close
        if bufwinnr(l:bnr) == -1
            execute 'bdelete' l:bnr
        endif
    else
        bprevious
        if bufnr('%') == l:bnr
            enew
        endif
        execute 'bdelete' l:bnr
    endif
endfunction
nnoremap <silent> <leader>c :call <SID>CloseWindowAndDeleteBuffer()<CR>
" BuferKeymap }}}

" Explorer {{{

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_altv = 0
let g:netrw_winsize = 40
let g:netrw_browse_split = 4

let g:explorer_width = 40

function! s:FindProjectRoot(start) abort
    let l:dir = fnamemodify(a:start, ':p')

    if empty(l:dir)
        return getcwd()
    endif

    while 1
        if isdirectory(l:dir . '/.git')
                    \ || isdirectory(l:dir . '/.hg')
                    \ || isdirectory(l:dir . '/.svn')
            return l:dir
        endif

        if filereadable(l:dir . '/pyproject.toml')
                    \ || filereadable(l:dir . '/setup.py')
                    \ || filereadable(l:dir . '/package.json')
                    \ || filereadable(l:dir . '/Cargo.toml')
                    \ || filereadable(l:dir . '/go.mod')
            return l:dir
        endif

        let l:parent = fnamemodify(l:dir, ':h')
        if l:parent ==# l:dir
            break
        endif
        let l:dir = l:parent
    endwhile

    return getcwd()
endfunction

function! s:IsCurrentWindowNetrw() abort
    return &filetype ==# 'netrw'
endfunction

function! s:ToggleExplorerAt(dir) abort
    if s:IsCurrentWindowNetrw()
        close
        return
    endif

    let l:target = fnamemodify(a:dir, ':p')
    let l:found_win = 0
    let l:same_dir = 0

    for i in range(1, winnr('$'))
        let l:buf = winbufnr(i)
        if getbufvar(l:buf, '&filetype') ==# 'netrw'
            let l:found_win = i
            let l:netrw_dir = fnamemodify(getbufvar(l:buf, 'netrw_curdir', ''), ':p')
            if l:netrw_dir ==# l:target
                let l:same_dir = 1
            endif
            break
        endif
    endfor
    if l:found_win && l:same_dir
        execute l:found_win . 'wincmd c'
        return
    endif
    if l:found_win
        execute l:found_win . 'wincmd c'
    endif

    execute 'Vexplore ' . fnameescape(l:target)
    execute 'vertical resize ' . g:explorer_width
endfunction

function! ToggleExplorerHere() abort
    let l:dir = expand('%:p:h')
    if empty(l:dir)
        let l:dir = getcwd()
    endif
    call s:ToggleExplorerAt(l:dir)
endfunction

function! ToggleExplorerRoot() abort
    let l:filedir = fnamemodify(expand('%:p:h'), ':p')
    let l:cwd = fnamemodify(getcwd(), ':p')
    if empty(l:filedir)
        let l:start = l:cwd
    else
        let l:filedir_slash = substitute(l:filedir, '/\+$', '', '') . '/'
        let l:cwd_slash = substitute(l:cwd, '/\+$', '', '') . '/'
        if stridx(l:filedir_slash, l:cwd_slash) == 0
            let l:start = l:filedir
        else
            let l:start = l:cwd
        endif
    endif
    let l:root = s:FindProjectRoot(l:start)
    call s:ToggleExplorerAt(l:root)
endfunction

nnoremap <Leader>e :call ToggleExplorerHere()<CR>
nnoremap <Leader>E :call ToggleExplorerRoot()<CR>

function! s:NetrwOpenVRight() abort
    let l:name = expand('<cfile>')
    if empty(l:name)
        return
    endif
    if exists('b:netrw_curdir')
        let l:path = fnamemodify(b:netrw_curdir . '/' . l:name, ':p')
    else
        let l:path = fnamemodify(l:name, ':p')
    endif
    if isdirectory(l:path)
        execute 'edit ' . fnameescape(l:path)
        return
    endif
    wincmd l
    execute 'rightbelow vsplit ' . fnameescape(l:path)
endfunction

augroup MyNetrwVSplitRight
    autocmd!
    autocmd FileType netrw nnoremap <buffer> v :<C-u>call <SID>NetrwOpenVRight()<CR>
augroup END

" Explorer }}}

" OSC52 {{{
function! s:IsSSH() abort
    return exists('$SSH_CONNECTION') || exists('$SSH_CLIENT') || exists('$SSH_TTY')
endfunction
function! s:Osc52Copy(text) abort
    let l:b64 = system('base64 | tr -d "\n"', a:text)
    if v:shell_error
        return
    endif
    let l:seq = "\e]52;c;" . l:b64 . "\x07"
    if exists('$TMUX') && !empty($TMUX)
        let l:seq = "\ePtmux;\e" . substitute(l:seq, "\e", "\e\e", 'g') . "\e\\"
    endif
    call system('cat > /dev/tty', l:seq)
endfunction
function! s:Osc52VisualYank() abort
    normal! gvy
    call s:Osc52Copy(getreg('"'))
endfunction
function! s:Osc52Opfunc(type) abort
    if a:type ==# 'char'
        normal! `[v`]y
    elseif a:type ==# 'line'
        normal! `[V`]y
    else
        execute "normal! `[\<C-v>`]y"
    endif
    call s:Osc52Copy(getreg('"'))
endfunction
function! s:Osc52YankLine() abort
    normal! yy
    call s:Osc52Copy(getreg('"'))
endfunction

if s:IsSSH() && executable('base64')
    xnoremap <silent> <leader>y :<C-u>call <SID>Osc52VisualYank()<CR>
    nnoremap <silent> <leader>y :set opfunc=<SID>Osc52Opfunc<CR>g@
    nnoremap <silent> <leader>yy :call <SID>Osc52YankLine()<CR>
endif
" OSC52 }}}

" Session {{{
let g:last_session_file = expand('~/.vim/last-session.vim')
set sessionoptions=buffers,curdir,folds,help,tabpages,winsize
function! SaveLastSession() abort
    execute 'mksession! ' . fnameescape(g:last_session_file)
endfunction
function! LoadLastSession() abort
    if filereadable(g:last_session_file)
        execute 'source ' . fnameescape(g:last_session_file)
    else
        echo 'No session file found: ' . g:last_session_file
    endif
endfunction
augroup LastSession
    autocmd!
    autocmd VimLeavePre * call SaveLastSession()
augroup END

nnoremap <leader>s :call LoadLastSession()<CR>
command! LoadLastSession call LoadLastSession()
command! SaveLastSession call SaveLastSession()
" Session }}}

" GIT {{{
function! s:FormatUnixTime(ts)
    let l:out = system('date -d @' . a:ts . ' "+%Y-%m-%d %H:%M"')
    if v:shell_error
        let l:out = system('date -r ' . a:ts . ' "+%Y-%m-%d %H:%M"')
    endif
    return substitute(l:out, '\n\+$', '', '')
endfunction

function! GitBlameInfoEcho()
    let l:file = expand('%:p')
    let l:line = line('.')
    if empty(l:file) || !filereadable(l:file)
        echo "No file"
        return
    endif
    let l:dir = fnamemodify(l:file, ':h')
    let l:name = fnamemodify(l:file, ':t')
    let l:save_cwd = getcwd()
    try
        execute 'lcd ' . fnameescape(l:dir)
        let l:out = system('git blame --porcelain -L ' . l:line . ',' . l:line . ' -- ' . shellescape(l:name))
        if v:shell_error
            echo "git blame failed"
            return
        endif
        let l:lines = split(l:out, "\n")
        if empty(l:lines)
            echo "No blame info"
            return
        endif
        let l:commit = matchstr(l:lines[0], '^\x\{7,40}')
        if empty(l:commit) || l:commit =~ '^0\+$'
            echo "Not committed yet"
            return
        endif
        let l:author = ''
        let l:time = ''

        for l:item in l:lines
            if l:item =~ '^author '
                let l:author = substitute(l:item, '^author ', '', '')
            elseif l:item =~ '^author-time '
                let l:time = substitute(l:item, '^author-time ', '', '')
            endif
        endfor
        let l:msg = system('git log -1 --format=%s ' . shellescape(l:commit))
        if v:shell_error
            echo l:commit
            return
        endif
        let l:msg = substitute(l:msg, '\n\+$', '', '')

        if !empty(l:time)
            let l:time = s:FormatUnixTime(l:time)
        endif
        let l:short = strpart(l:commit, 0, 8)
        echo l:short . ' (' . l:author . ' ' . l:time . ') ' . l:msg
    finally
        execute 'lcd ' . fnameescape(l:save_cwd)
    endtry
endfunction

command! BlameInfo call GitBlameInfoEcho()
nnoremap <leader>gb :BlameInfo<CR>
" GIT }}}

" AutoCmdGroup
if has('autocmd')
    augroup my_vimrc
        autocmd!
        " previous cursor position
        autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   execute "normal! g'\"" |
            \ endif

        autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        autocmd FileType c,cpp setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
        autocmd FileType java setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
        autocmd FileType make setlocal noexpandtab
        autocmd FileType sh,zsh,bash setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
        autocmd FileType text,markdown setlocal wrap
    augroup END
endif

" Formatter {{{
function! ClangGitFormatFile()
    let l:file = expand('%:p')
    let l:ext = tolower(expand('%:e'))

    if empty(l:file) || !filereadable(l:file)
        echoerr "No file"
        return
    endif

    if index(['c', 'cc', 'cpp', 'cxx', 'h', 'hh', 'hpp', 'hxx', 'proto'], l:ext) < 0
        echoerr "Not a C/C++/protobuf file"
        return
    endif

    let l:dir = fnamemodify(l:file, ':h')
    let l:name = fnamemodify(l:file, ':t')
    let l:save_cwd = getcwd()

    silent write

    try
        execute 'lcd ' . fnameescape(l:dir)

        let l:use_git = 0

        call system('git rev-parse --is-inside-work-tree')
        if !v:shell_error
            call system('git ls-files --error-unmatch -- ' . shellescape(l:name))
            if !v:shell_error
                call system('git rev-parse --verify HEAD')
                if !v:shell_error
                    let l:use_git = 1
                endif
            endif
        endif

        if l:use_git
            let l:out = system('git clang-format --force HEAD -- ' . shellescape(l:name))
            let l:code = v:shell_error
            let l:out = substitute(l:out, "\x00", "", "g")

            if l:code > 1
                echoerr 'git clang-format failed'
                return
            endif
        else
            let l:out = system('clang-format -i -- ' . shellescape(l:name))
            let l:code = v:shell_error

            if l:code != 0
                echoerr 'clang-format failed'
                return
            endif
        endif

        silent edit!
        redraw!
    finally
        execute 'lcd ' . fnameescape(l:save_cwd)
    endtry
endfunction

command! ClangGitFormatFile call ClangGitFormatFile()
augroup LocalFormatFileMap
    autocmd!
    autocmd FileType c,cpp,proto nnoremap <buffer> <silent> <leader>lf :call ClangGitFormatFile()<CR>
augroup END
" Formatter }}}

