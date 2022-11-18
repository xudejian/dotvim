" This is Dejian's .vimrc file
" vim:set ts=2 sts=2 sw=2 expandtab:
"
set nocompatible
" Plugins " {{{

let g:tex_flavor='latex'
"let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'

let g:rooter_patterns = [
      \ '.git', '.git/',
      \ 'Cargo.toml', 'go.mod',
      \ '_darcs/', '.hg/', '.bzr/', '.svn/',
      \ 'Makefile', 'package.json',
      \ 'tags']

" https://www.gnu.org/software/global/
let g:gutentags_modules = ['ctags', 'gtags_cscope']
let g:gutentags_project_root = ['tags']
let g:gutentags_add_default_project_roots = 0
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+pxI']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
let g:gutentags_auto_add_gtags_cscope = 0
let g:gutentags_plus_switch = 1

let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0

let g:pandoc#formatting#mode = "h"

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

let g:rustfmt_autosave = 1
" " }}}

set omnifunc=syntaxcomplete#Complete
set completeopt=menuone,longest
set sw=2 sts=2 ts=2
set expandtab
set nofoldenable
set tw=80
set wrap
set cindent
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4

set winwidth=82
set colorcolumn=+1
set nu
set hlsearch
set smartcase
set ignorecase
set linebreak

set mouse=a
set hidden
set lazyredraw
set si
set fenc=utf-8
set fencs=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936,big5,euc-jp,latin1
syntax sync minlines=256
set mat=2
set splitright
set splitbelow
set updatetime=300
set signcolumn=number

set autowriteall
set path+=**
set wildcharm=<C-Z>
set wildmode=list:longest,full

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
function! SetCursorPosition()
  if &filetype !~# 'commit'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exe "normal! g`\""
      normal! zz
    endif
  end
endfunction

augroup vimrcEx
  au!

  au InsertEnter,InsertLeave,FocusGained * set imd imi=0

  au FocusLost * silent! wa

  autocmd FileType html,css,javascript setl sw=2 sts=2 ts=2 noet iskeyword+=-
  autocmd FileType yml,yaml setl sw=2 sts=2 ts=2 et indentkeys-=<:>
  autocmd BufReadPost * call SetCursorPosition()
augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif


if has('nvim')
let g:gutentags_dont_load = 1
set undodir^=~/.cache/nvim/undo
else
set undodir^=~/.cache/vim/undo
endif

set backupcopy=yes
set undofile

let g:gruvbox_number_column='bg1'
colorscheme gruvbox

set grepprg=rg\ -S\ --vimgrep
set grepformat^=%f:%l:%c:%m

" Vim. Live it. ------------------------------------------------------- {{{
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" }}}

vmap <C-c> "+y

" don't give |ins-completion-menu| messages.
set shortmess+=c
set signcolumn=yes

set statusline=%n\ %<%.99f\ %{(&paste==1)?'[PASTE]':''}%h%w%m%r\ %1*\ %=
set statusline+=\ %y
set statusline+=%{(&ff!='unix')?&ff:''.(&fenc!='utf-8'&&&fenc!='')?'\ '.&fenc:''.&bomb?'-bom':''}
set statusline+=\ %*\ %-16(%l,%c-%v\ %P%)

if has('macunix')
  function! OpenURLUnderCursor()
    let s:uri = matchstr(getline('.'), '[a-z]*:\/\/[^ >,;()]*')
    let s:uri = shellescape(s:uri, 1)
    if s:uri != ''
      silent exec "!open '".s:uri."'"
      :redraw!
    endif
  endfunction
  nnoremap gx :call OpenURLUnderCursor()<CR>
endif

let g:netrw_banner=0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_list_hide = &wildignore
nnoremap <leader><Tab> :Lexplore<CR>

augroup autoquickfix
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
augroup END

let g:fzf_buffers_jump = 1

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" return the visually selected text and quote it with double quote
function! GetVisual() abort
    try
        let x_save = @x
        norm! gv"xy
        return '"' . escape(@x, '"') . '"'
    finally
        let @x = x_save
    endtry
endfunction
function! GetRawVisual() abort
    try
        let x_save = @x
        norm! gv"xy
        return @x
    finally
        let @x = x_save
    endtry
endfunction

nnoremap <C-p> :call fzf#vim#files('.', {'options':'--no-preview'})<CR>
nnoremap <leader>g :call fzf#vim#files('.', {'options':'--no-preview -1 --query '.expand('<cword>')})<CR>
nnoremap <silent> <Leader>ff :RG <C-R><C-W><CR>
nnoremap <C-\> :Buffers<CR>

nnoremap <C-]> g<C-]>

if has('mac') || has('macunix')
    " Open Dictionary.app on mac systems
    function! OpenDictionary(...)
        let word = ''

        if a:0 > 0 && a:1 !=# ''
            let word = a:1
        else
            let word = shellescape(expand('<cword>'))
        endif
        if &filetype == 'quiz'
            let word = substitute(word, '`', '', 'g')
        endif

        call system("open dict://" . word . ";say ". word)
    endfunction
    command! -nargs=? Dict call OpenDictionary(<q-args>)
endif

" Use H to show documentation in preview window
nnoremap <silent> H :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'h '.expand('<cword>')
  else
    call OpenDictionary()
  endif
endfunction

function! MyTrimTrailingWhitespace() " {{{1
    if &l:modifiable
        " don't lose user position when trimming trailing whitespace
        let s:view = winsaveview()
        try
            silent! keeppatterns %s/\s\+$//e
        finally
            call winrestview(s:view)
        endtry
    endif
endfunction " }}}1
autocmd BufWritePre <buffer> call MyTrimTrailingWhitespace()

if &term =~ '256color'
  set t_ut=
  set t_Co=256
  set termguicolors
endif

if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
  let &t_SI = "\e[5 q"
  let &t_EI = "\e[2 q"
endif

nmap <ScrollWheelUp> <nop>
nmap <ScrollWheelDown> <nop>
imap <ScrollWheelUp> <nop>
imap <ScrollWheelDown> <nop>
vmap <ScrollWheelUp> <nop>
vmap <ScrollWheelDown> <nop>

runtime coc.vim
set bg=dark
