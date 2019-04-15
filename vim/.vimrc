"""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""
" encoding
set encoding=utf-8
set fileencoding=utf-8

syntax on                       " Enable syntax highlight

set hidden                      " hides buffers instead of closing them
set foldmethod=manual           " manual folding
set mouse=a                     " when copying, keeping the line numbers out
set number                      " show line numbers
set scrolloff=2                 " context lines above and below the cursor
set showcmd                     " see commands as you type them

" Show white spaces as a character
set list
set listchars=tab:··,trail:·
set listchars=eol:·,tab:··,trail:·,extends:·,precedes:·

set hlsearch                    " highlight search terms
set ic                          " ignore case
set incsearch                   " show search matches as you type

" tab is two spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2 noexpandtab

set splitbelow
set splitright

" no backup files written on save
set nobackup
set noswapfile
set nowritebackup

filetype plugin indent on        " indentation

" italic comments on terminal and gui
highlight Comment cterm=italic gui=italic

" theme
color dracula

" change the mapleader from \ to ,
let mapleader=","


"""""""""""""""""""""""""""""""""""""""""""""""
" Plugins List
"""""""""""""""""""""""""""""""""""""""""""""""
" Auto-install Plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plugins
call plug#begin('~/.vim/plugged')

Plug 'mileszs/ack.vim'
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'qpkorr/vim-bufkill'
Plug 'alvan/vim-closetag'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'scrooloose/nerdcommenter'
Plug 'luochen1990/rainbow'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'

Plug 'pangloss/vim-javascript'
Plug 'othree/javascript-libraries-syntax.vim'

Plug 'tpope/vim-unimpaired'
Plug 'SirVer/ultisnips'
Plug 'maxbrunsfeld/vim-yankstack'
Plug 'Valloric/YouCompleteMe'

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Related Configs
"""""""""""""""""""""""""""""""""""""""""""""""
" ACK
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" ALE
let g:ale_sign_warning='--'
let g:ale_sign_error='>>'

let g:ale_sign_column_always = 1

let g:ale_linters = {'css': ['prettier'], 'scss': ['prettier'], 'less': ['prettier'], 'javascript': ['eslint'], 'erb': ['erb'], 'ruby': ['rubocop'], 'yaml': ['prettier'], 'json': ['prettier'], 'python': ['flake8']}
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace'], 'css': ['prettier'], 'scss': ['prettier'], 'less': ['prettier'], 'javascript': ['prettier', 'eslint'], 'erb': ['erb'], 'ruby': ['rubocop'], 'yaml': ['prettier'], 'json': ['prettier'], 'python': ['autopep8']}
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_javascript_css_use_local_config = 1
let g:ale_javascript_sass_use_local_config = 1
let g:ale_javascript_less_use_local_config = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_eslint_use_local_config = 1
let g:ale_json_prettier_use_local_config = 1
let g:ale_yaml_prettier_use_local_config = 1

" Ariline
let g:airline_theme='dracula'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#ale#enabled = 1
let g:airline_section_c = ''
let g:airline_section_x = ''
let g:airline_section_y = ''

" Closetag
" Non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'html,jsx,tsx'
" Non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'
" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'

" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html EmmetInstall " enable just for HTML

" FZF
" Set statusline color
function! s:fzf_statusline()
  highlight fzf1 ctermfg=yellow
  highlight fzf2 ctermfg=yellow
  highlight fzf3 ctermfg=yellow
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction
autocmd! User FzfStatusLine call <SID>fzf_statusline()

" Git gutter
highlight clear SignColumn

" JS Libs
let g:used_javascript_libs = 'jquery,react,underscore,vue'

" Multiple Cursor
et g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

" NERDTree
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

" NERDCommenter
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'css': { 'left': '/*','right': '*/' } }

" Rainbow
let g:rainbow_active = 1 " 0 if you want to enable it later via :RainbowToggle

" Ultisnips
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


"""""""""""""""""""""""""""""""""""""""""""""""
" Key Remaps
"""""""""""""""""""""""""""""""""""""""""""""""
" copy selection to system clipboard
vnoremap <Leader>y "+y

" window navigation
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-h> <C-w>h
nmap <C-l> <C-w>l

" Plug shortcuts
nmap <leader>pc :PlugClean<CR>
nmap <leader>pu :PlugUpdate<CR>
nmap <leader>pi :PlugInstall<CR>

" delete all empty lines
map <C-o> :g/^$/d

" autoclose brackets and quotes
inoremap " ""<left>
inoremap ' ''<left>
inoremap ` ``<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

" ACK
nmap <leader>ak :Ack! ""<Left> " search pattern
nmap <leader>akf :Ack "" %<Left><Left><Left> " search pattern in current file
nmap <leader>akc :Ack! --css ""<Left> " search pattern in css files
nmap <leader>aks :Ack! --sass ""<Left> " search pattern in sass files
nmap <leader>akh :Ack! --html ""<Left> " search pattern in html files
nmap <leader>akr :Ack! --ruby ""<Left> " search pattern in ruby files
nmap <leader>akj :Ack! --js ""<Left> " search pattern in js files
nmap <leader>cdo :cdo s///g | update " search and replace
" https://chrisarcand.com/vims-new-cdo-command/

" ALE
nmap <leader>alef :ALEFix<cr> " Ale lint and fix
nmap <leader>alefs :ALEFixSuggest<cr> " Ale suggest fixes

" Bufkill
nmap <leader>bd :BD<cr> " delete a file from buffer and keep window/split
nmap <leader>bn :BF<cr> " next buffer
nmap <leader>bp :BB<cr> " prev buffer

" Fugitive
nmap <leader>gst :Gstatus<cr> " git status
nmap <leader>gdf :Gdelete<cr> " git rm file and buffer

" fzf
nmap <leader>bf :Buffers<CR> " search active buffer
nmap <leader>fz :Files<CR> " search current directory
nmap <leader>tg :Tags<CR> " search tags

" Git Gutter
nmap <leader>gg :GitGutterToggle<CR> " toggle git gutter

" NERDCommenter
imap <leader>cc <plug>NERDCommenterComment " comment selection
imap <leader>ct <plug>NERDCommenterToggle " toggle comment selection

" NERDTree
nmap <leader>nt :NERDTreeToggle<CR> " toggle nr

" Yankstack
nmap <leader>p <Plug>yankstack_substitute_older_paste " cycle backwards through your yanks
nmap <leader>P <Plug>yankstack_substitute_newer_paste " cycle forwards through your yanks
