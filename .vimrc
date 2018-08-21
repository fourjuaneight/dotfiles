if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')


" ACK
Plug 'mileszs/ack.vim'

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

cnoreabbrev ak Ack!

nmap <Esc>ak    :Ack! ""<Left>
nmap <Esc>akf   :Ack "" %<Left><Left><Left>
nmap <Esc>akc   :Ack! --css ""<Left>
nmap <Esc>aks   :Ack! --sass ""<Left>
nmap <Esc>akh   :Ack! --html ""<Left>
nmap <Esc>akr   :Ack! --ruby ""<Left>
nmap ;cdo       :cdo s///g | update
nmap <Esc>k     :Ack! "\b<cword>\b" <CR>
nmap <M-S-k>    :Ggrep! "\b<cword>\b" <CR>
nmap <Esc>K     :Ggrep! "\b<cword>\b" <CR>

" ALE
Plug 'w0rp/ale'

let g:ale_sign_warning='--'
let g:ale_sign_error='>>'

let g:ale_sign_column_always = 1

let g:ale_linters = {'html': ['proselint'], 'css': ['prettier'], 'scss': ['prettier'], 'less': ['prettier'], 'javascript': ['prettier', 'eslint'], 'erb': ['erb'], 'ruby': ['rubocop'], 'yaml': ['prettier'], 'json': ['prettier'], 'python': ['flake8', 'pylint'], 'vim': ['vint']}
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_fixers = {'html': ['tidy'], 'css': ['prettier'], 'scss': ['prettier'], 'less': ['prettier'], 'javascript': ['prettier', 'eslint'], 'erb': ['erb'], 'ruby': ['rubocop'], 'yaml': ['prettier'], 'json': ['prettier'], 'python': ['flake8', 'pylint'], 'vim': ['vint']}

nmap <Esc>alef	:ALEFix<CR>

" Ariline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_theme='dracula'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:airline_section_c = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

" Editor
Plug 'scrooloose/nerdcommenter'
Plug 'ntpeters/vim-better-whitespace'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

" Set fzf statusline color
function! s:fzf_statusline()
  highlight fzf1 ctermfg=yellow
  highlight fzf2 ctermfg=yellow
  highlight fzf3 ctermfg=yellow
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

nmap <Esc>bf :Buffers<CR>
nmap <Esc>fz :Files<CR>
nmap <Esc>tg :Tags<CR>

" Fugitive
Plug 'tpope/vim-fugitive'

" Git gutter
Plug 'airblade/vim-gitgutter'
highlight clear SignColumn

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

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

map <Esc>nt :NERDTreeToggle<CR>

" Surround
Plug 'tpope/vim-surround'

" Unimpaired
Plug 'tpope/vim-unimpaired'

" ~~~ Declare the list of plugins ~~~
" Utilities
Plug 'qpkorr/vim-bufkill'
map bd :BD<cr>

Plug 'editorconfig/editorconfig-vim'

" Rainbow
Plug 'luochen1990/rainbow'

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

" Snippets
Plug 'honza/vim-snippets'

" Syntax
Plug 'elzr/vim-json'
Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'cakebaker/scss-syntax.vim'
Plug 'othree/html5.vim'
Plug 'cespare/vim-toml'

" Ultisnips
Plug 'SirVer/ultisnips'

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

call plug#end()

set foldmethod=manual
set hidden
set mouse=a
set number
set scrolloff=2
set showcmd

set list
set listchars=tab:··,trail:·
set listchars=eol:·,tab:··,trail:·,extends:·,precedes:·

set hlsearch
set ic
set incsearch

set softtabstop=2 noexpandtab
set shiftwidth=2
set tabstop=2

set splitbelow
set splitright

set nobackup
set noswapfile
set nowritebackup

syntax on
color dracula

" Copy selection to system clipboard
vnoremap <Leader>y "+y

" Indentation
filetype plugin indent on
autocmd Filetype bash
autocmd Filetype ruby
autocmd Filetype sh
autocmd Filetype vim
autocmd Filetype xml
autocmd Filetype yaml
autocmd Filetype zsh

" Window navigation
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> :<C-u>TmuxNavigateLeft<CR>
nmap <C-l> <C-w>l

" Tabs
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>

" Move by screen lines
noremap j gj
noremap k gk

" Filter command history
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Italic comments
highlight Comment cterm=italic

nmap <Esc>pc :PlugClean<CR>
nmap <Esc>pu :PlugUpdate<CR>
nmap <Esc>pi :PlugInstall<CR>

" delete all empty lines
map <C-o> :g/^$/d

" Autoclose
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
