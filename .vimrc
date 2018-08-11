let mapleader = "\<Space>"         " Use space as leader

set colorcolumn=80                 " line length matters
set foldmethod=manual              " set a foldmethod
set hidden
set mouse=a                        " enable mouse
set number                         " line numbers
set scrolloff=2                    " Always shows two lines of vertical context around the cursor
set undofile
set showcmd                        " show incomplete commands

set list                           " show whitespace
set listchars=tab:»·,trail:·

set hlsearch                       " highlight what you search for
set ic                             " case insensitive search
set incsearch                      " type-ahead-find
set scs                            " smart case search
set inccommand=nosplit             " in-place substitution preview

set expandtab                      " use spaces instead of tabs
set softtabstop=4                  " 1 tab == 2 spaces
set shiftwidth=4                   " 1 tab == 2 spaces
set tabstop=4                      " 1 tab == 2 spaces

set splitbelow                     " all horizontal splits open to the bottom
set splitright                     " all vertical splits open to the right

set nobackup                       " no backup files
set noswapfile                     " no swap files
set nowritebackup                  " only in case you don't want a backup file while editing

syntax on
color dracula

" Copy selection to system clipboard
vnoremap <Leader>y "+y

" Indentation.
filetype plugin indent on
autocmd Filetype bash       setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype ruby       setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype sh         setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype vim        setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype xml        setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype yaml       setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd Filetype zsh        setlocal tabstop=2 softtabstop=2 shiftwidth=2

" Window navigation.
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> :<C-u>TmuxNavigateLeft<CR>
nmap <C-l> <C-w>l

" Move by screen lines.
noremap j gj
noremap k gk

" Filter command history.
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Bootstrap vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')


" ACK
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'mileszs/ack.vim'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev ak Ack!

:nmap <C>a       :Ack!<Space>
:nmap <Leader>af :Ack  %<Left><Left>
:nmap <Esc>k     :Ack! "\b<cword>\b" <CR>
:nmap <M-S-k>    :Ggrep! "\b<cword>\b" <CR>
:nmap <Esc>K     :Ggrep! "\b<cword>\b" <CR>

" ALE
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'w0rp/ale'

let g:ale_sign_warning='●'
let g:ale_sign_error='●'

let g:ale_linters = {}
let g:ale_linter_aliases = {}
let g:ale_fix_on_save = 1
let g:ale_fixers = {}

" Python.
let g:ale_python_mypy_options = '--ignore-missing-imports'

" Typescript.
let g:ale_linter_aliases = {'typescriptreact': 'typescript'}
let g:ale_linters['typescript'] = ['eslint', 'tslint']
let g:ale_fixers['typescript'] = ['prettier']
let g:ale_fixers['typescriptreact'] = ['prettier']
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --tab-width 4'


" Editor
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'scrooloose/nerdcommenter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'


" FZF
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

" Redefine :Ag command
function! s:ag_with_opts(arg, bang)
  let tokens  = split(a:arg)
  let ag_opts = join(filter(copy(tokens), 'v:val =~ "^-"'))
  let query   = join(filter(copy(tokens), 'v:val !~ "^-"'))
  call fzf#vim#ag(query, ag_opts, a:bang ? {} : {'down': '40%'})
endfunction

autocmd VimEnter * command! -nargs=* -bang Ag call s:ag_with_opts(<q-args>, <bang>0)

" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
" let g:fzf_history_dir = '~/.local/share/fzf-history'

" Set fzf statusline color
function! s:fzf_statusline()
  highlight fzf1 ctermfg=yellow
  highlight fzf2 ctermfg=yellow
  highlight fzf3 ctermfg=yellow
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

noremap <silent> <Leader><Leader> :silent FZF <CR>
" Search word under cursor with leader + a
nnoremap <silent> <leader>a :silent Ag -sw <C-r>=expand('<cword>')<CR><CR>
" Search visual selection with leader + a
vnoremap <silent> <leader>a y:silent Ag -sw <C-r>"<CR>

" Search tags in buffer by using leader + t
noremap <silent> <leader>t :silent BTags<CR>

" Search lines in buffers by using leader + l
noremap <silent> <leader>l :silent BLines '<C-r>=expand('<cword>')<CR><CR>

" Search all tags by using leader + T
noremap <silent> <leader>T :silent Tags<CR>

" Search marks by using leader + m
noremap <silent> <leader>m :silent Marks<CR>

function! BufList()
    redir => ls
    silent ls
    redir END
    return split(ls, '\n')
endfunction

function! BufOpen(e)
    execute 'buffer '. matchstr(a:e, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader><Enter> :silent call fzf#run({
\   'source':      reverse(BufList()),
\   'sink':        function('BufOpen'),
\   'options':     '+m',
\   'tmux_height': '40%'
\ })<CR>


" Git gutter
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'airblade/vim-gitgutter'
highlight clear SignColumn


" Lightline
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'itchyny/lightline.vim'


" Multiple cursors
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'terryma/vim-multiple-cursors'


" NERDTree
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

:command! NT NERDTreeToggle
:command! NTF NERDTreeFind
let NERDTreeIgnore = ['\.pyc$']
let NERDTreeShowHidden=1

" close if it's the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" remove help
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" open automatically on startup with no specified file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" Surround
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-surround'


" Unimpaired
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'tpope/vim-unimpaired'

" ~~~ Declare the list of plugins ~~~
" Utilities
Plug 'qpkorr/vim-bufkill'
Plug 'editorconfig/editorconfig-vim'


" Rainbow
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'luochen1990/rainbow'

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle


" Snippets
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'honza/vim-snippets'


" Syntax
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'cespare/vim-toml'


" Ultisnips
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'SirVer/ultisnips'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

call plug#end()


" Italic comments.
highlight Comment cterm=italic
highlight LineNr ctermbg=15  " clear background for line numbers

:nmap ;pc :PlugClean<CR>

:map <C-o> :g/^$/d                 " delete all empty lines

:nmap ;b :Buffers<CR>
:nmap ;f :Files<CR>
:nmap ;r :Tags<CR>

" Autoclose
:inoremap " ""<left>
:inoremap ' ''<left>
:inoremap ( ()<left>
:inoremap [ []<left>
:inoremap { {}<left>