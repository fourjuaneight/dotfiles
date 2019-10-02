"""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""

" change the mapleader from \ to SPC
let mapleader=" "

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
set autowrite                   " Automatically :write before running commands

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

" Open new split panes to right and bottom; more natural
set splitbelow
set splitright

" no backup files written on save
set nobackup
set noswapfile
set nowritebackup

" Always use vertical diffs
set diffopt+=vertical

filetype plugin indent on        " indentation

" italic comments on terminal and gui
highlight Comment cterm=italic gui=italic

" theme
color dracula


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

Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'honza/vim-snippets'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'luochen1990/rainbow'
Plug 'mattn/emmet-vim'
Plug 'mileszs/ack.vim'
Plug 'othree/javascript-libraries-syntax.vim'
Plug 'pangloss/vim-javascript'
Plug 'qpkorr/vim-bufkill'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'SirVer/ultisnips'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'

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
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<leader>mw'
let g:multi_cursor_select_all_word_key = '<leader>maw'
let g:multi_cursor_start_key           = '<leader>mk'
let g:multi_cursor_select_all_key      = '<leader>mak'
let g:multi_cursor_next_key            = '<leader>mn'
let g:multi_cursor_prev_key            = '<leader>mp'
let g:multi_cursor_skip_key            = '<leader>ms'
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

" line numbers
let NERDTreeShowLineNumbers=0

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

" YCM
" disable auto_triggering ycm suggestions pane and instead
" let g:ycm_auto_trigger = 0

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-j>', '<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Ultisnips
" snippets location
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


"""""""""""""""""""""""""""""""""""""""""""""""
" Key Remaps
"""""""""""""""""""""""""""""""""""""""""""""""
" copy selection to system clipboard
vnoremap <leader>by "+y

" window navigation
nmap <leader>wj <C-w>j
nmap <leader>wk <C-w>k
nmap <leader>wh <C-w>h
nmap <leader>wl <C-w>l

" Plug shortcuts
nmap <leader>pc :PlugClean<CR>
nmap <leader>pu :PlugUpdate<CR>
nmap <leader>pi :PlugInstall<CR>

" delete all empty lines
map <leader>bln :g/^$/d

" autoclose brackets and quotes
inoremap " ""<left>
inoremap ' ''<left>
inoremap ` ``<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

" tabs
map <leader>tn :bn<cr>
map <leader>tp :bp<cr>
map <leader>td :bd<cr>

" ACK
nmap <leader>/b :Ack "" %<Left><Left><Left>
nmap <leader>/dc :Ack! --css ""<Left>
nmap <leader>/ds :Ack! --sass ""<Left>
nmap <leader>/dh :Ack! --html ""<Left>
nmap <leader>/dj :Ack! --js ""<Left>
nmap <leader>/br :cdo %s///g \| update
" https://chrisarcand.com/vims-new-cdo-command/

" ALE
nmap <leader>bfx :ALEFix<cr> " Ale lint and fix
nmap <leader>bfxsg :ALEFixSuggest<cr> " Ale suggest fixes

" Bufkill
nmap <leader>bd :BD<cr> " delete a file from buffer and keep window/split
nmap <leader>bn :BF<cr> " next buffer
nmap <leader>bp :BB<cr> " prev buffer

" Fugitive
nmap <leader>gst :Gstatus<cr> " git status
nmap <leader>gdf :Gdelete<cr> " git rm file and buffer

" fzf
nmap <leader>/d :Files<CR>

" Git Gutter
nmap <leader>gg :GitGutterToggle<CR> " toggle git gutter

" NERDCommenter
imap <leader>cc <plug>NERDCommenterComment " comment selection
imap <leader>ct <plug>NERDCommenterToggle " toggle comment selection

" NERDTree
nmap <leader>nt :NERDTreeToggle<CR> " toggle nr

" YCM
nmap <leader>yrs :YcmRestartServer <CR>
nmap <leader>yfc :YcmForceCompileAndDiagnostics<CR>
nmap <leader>ydi :YcmShowDetailedDiagnostic <CR>
nmap <leader>ycm :YcmCompleter <CR>
