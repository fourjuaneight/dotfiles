"""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""

" change the mapleader from \ to SPC
let mapleader=" "

set timeoutlen=1000 ttimeoutlen=0

" encoding
set encoding=utf-8
set fileencoding=utf-8

syntax on                       " Enable syntax highlight

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
if &diff
    set diffopt-=internal
    set diffopt+=vertical
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

filetype plugin indent on        " indentation

" italic comments on terminal and gui
highlight Comment cterm=italic gui=italic

" theme
packadd! dracula_pro
let g:dracula_colorterm = 0
colorscheme dracula_pro_van_helsing

" Ignored files/directories from autocomplete (and CtrlP)
set wildignore+=*/tmp/*
set wildignore+=*.so
set wildignore+=*.zip
set wildignore+=*/vendor/bundle/*
set wildignore+=*/node_modules/

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
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'njk' }
Plug 'jparise/vim-graphql',
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'lepture/vim-jinja'
Plug 'luochen1990/rainbow'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'qpkorr/vim-bufkill'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'w0rp/ale'
Plug 'Xuyuanp/nerdtree-git-plugin'

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Related Configs
"""""""""""""""""""""""""""""""""""""""""""""""
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
let g:airline_theme='dracula_pro'
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

" COC
let g:coc_global_extensions = [
\ 'coc-css',
\ 'coc-emmet',
\ 'coc-eslint',
\ 'coc-html',
\ 'coc-json',
\ 'coc-pairs',
\ 'coc-prettier',
\ 'coc-snippets',
\ 'coc-tsserver',
\ ]
vmap <C-j> <Plug>(coc-snippets-select)
imap <C-j> <Plug>(coc-snippets-expand-jump)
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<cr>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'

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
let g:NERDTreeIgnore = ['^node_modules$']

" remove help
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" line numbers
let NERDTreeShowLineNumbers=0

" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()

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

" Ripgrep
let g:rg_command = 'rg --vimgrep -S'
let g:rg_derive_root='true'

" Ultisnips
" snippets location
let g:UltiSnipsSnippetDirectories=["UltiSnips", "snips"]

" Rust
let g:rustfmt_autosave = 1

"""""""""""""""""""""""""""""""""""""""""""""""
" Key Remaps
"""""""""""""""""""""""""""""""""""""""""""""""
" quit
noremap <leader>q :q<cr>

" force quit
noremap <leader>q! :q!<cr>

" write
noremap <leader>s :w<cr>

" write and quit
noremap <leader>sq ZZ<cr>

" write and force quit
noremap <leader>sq! :wq!<cr>

" copy selection to system clipboard
vnoremap <leader>by "+y

" window navigation
nmap <leader>wj <C-w>j
nmap <leader>wk <C-w>k
nmap <leader>wh <C-w>h
nmap <leader>wl <C-w>l

" Plug shortcuts
nmap <leader>pc :PlugClean<cr>
nmap <leader>pu :PlugUpdate<cr>
nmap <leader>pug :PlugUpgrade<cr>
nmap <leader>pi :PlugInstall<cr>

" delete all empty lines
map <leader>dln :g/^$/d

" tabs
map <leader>tn :bn<cr>
map <leader>tp :bp<cr>
map <leader>td :bd<cr>

" Ripgrep
nmap <leader>/x <C-w>j<Bar>:bd<cr><Bar><C-w>l
nmap <leader>/a :Rg ""<Left>
nmap <leader>/b <C-w>l<Bar>:Rg "" %:p<Left><Left><Left><Left><Left>
nmap <leader>/bc :Rg -t css ""<Left>
nmap <leader>/bs :Rg -t sass ""<Left>
nmap <leader>/bh :Rg -t html ""<Left>
nmap <leader>/bm :Rg -t md ""<Left>
nmap <leader>/bjs :Rg -t js ""<Left>
nmap <leader>/bjsx :Rg -t jsx ""<Left>
nmap <leader>/bjn :Rg -t json ""<Left>
nmap <leader>/bts :Rg -t ts ""<Left>
nmap <leader>/btsx :Rg -t tsx ""<Left>
nmap <leader>/br :cdo %s///g \| update
" https://chrisarcand.com/vims-new-cdo-command/

" ALE
nmap <leader>ff :ALEFix<cr> " Ale lint and fix
nmap <leader>fs :ALEFixSuggest<cr> " Ale suggest fixes

" Bufkill
nmap <leader>bd :BD<cr> " delete a file from buffer and keep window/split
nmap <leader>bn :BF<cr> " next buffer
nmap <leader>bp :BB<cr> " prev buffer

" CoC
" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<cr>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Fugitive
nmap <leader>gst :10Gstatus<cr>
nmap <leader>gf :Gfetch<cr>
nmap <leader>gp :Gpull<cr>
nmap <leader>gup :Gpush<cr>
nmap <leader>ga :Gw<cr>
nmap <leader>gaq :Gwq<cr>
nmap <leader>gaa :Git add .<cr>
nmap <leader>gcm :Gcommit<cr>
nmap <leader>gr :Git reset<cr>
nmap <leader>gdf :Gdelete<cr>

" fzf
nmap <leader>/d <C-w>l<Bar>:FZF<cr>

" NERDCommenter
imap <leader>cc <plug>NERDCommenterComment
imap <leader>ct <plug>NERDCommenterToggle

" NERDTree
nmap <leader>b :NERDTreeToggle<cr>

" Surround
nmap <leader>sp ys
nmap <leader>sc cs
nmap <leader>sd ds
