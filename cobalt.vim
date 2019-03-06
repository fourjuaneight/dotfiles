scriptencoding utf8

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'cobalt'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

let s:fg        = ['#F8F8F2', 255]

let s:bglighter = ['#244D6A',  23]
let s:bglight   = ['#193549', 237]
let s:bg        = ['#163042', 236]
let s:bgdark    = ['#192935', 235]
let s:bgdarker  = ['#15232D', 234]

let s:subtle    = ['#244D6A',  23]

let s:selection = ['#0050A4',  25]
let s:comment   = ['#0787FF',  33]
let s:cyan      = ['#80FFA9', 121]
let s:green     = ['#FFC600', 220]
let s:orange    = ['#E1EFFF', 195]
let s:pink      = ['#FF902F', 208]
let s:purple    = ['#FF2C70', 197]
let s:red       = ['#E4776A', 173]
let s:yellow    = ['#3AD917', 276]

let s:none      = ['NONE', 'NONE']

let g:cobalt_palette = {
      \ 'fg': s:fg,
      \ 'bg': s:bg,
      \ 'selection': s:selection,
      \ 'comment': s:comment,
      \ 'cyan': s:cyan,
      \ 'green': s:green,
      \ 'orange': s:orange,
      \ 'pink': s:pink,
      \ 'purple': s:purple,
      \ 'red': s:red,
      \ 'yellow': s:yellow,
      \
      \ 'bglighter': s:bglighter,
      \ 'bglight': s:bglight,
      \ 'bgdark': s:bgdark,
      \ 'bgdarker': s:bgdarker,
      \ 'subtle': s:subtle,
      \}

if has('nvim')
  let g:terminal_color_0  = '#15232D'
  let g:terminal_color_1  = '#E4776A'
  let g:terminal_color_2  = '#FFC600'
  let g:terminal_color_3  = '#3AD917'
  let g:terminal_color_4  = '#FF2C70'
  let g:terminal_color_5  = '#FF902F'
  let g:terminal_color_6  = '#80FFA9'
  let g:terminal_color_7  = '#F8F8F2'
  let g:terminal_color_8  = '#0787FF'
  let g:terminal_color_9  = '#E68277'
  let g:terminal_color_10 = '#F7D148'
  let g:terminal_color_11 = '#6CDB53'
  let g:terminal_color_12 = '#FF6193'
  let g:terminal_color_13 = '#FF9F4A'
  let g:terminal_color_14 = '#94FAB4'
  let g:terminal_color_15 = '#FFFFFF'
endif

if !exists('g:cobalt_bold')
  let g:cobalt_bold = 1
endif

if !exists('g:cobalt_italic')
  let g:cobalt_italic = 1
endif

if !exists('g:cobalt_underline')
  let g:cobalt_underline = 1
endif

if !exists('g:cobalt_undercurl') && g:cobalt_underline != 0
  let g:cobalt_undercurl = 1
endif

if !exists('g:cobalt_inverse')
  let g:cobalt_inverse = 1
endif

if !exists('g:cobalt_colorterm')
  let g:cobalt_colorterm = 1
endif

let s:attrs = {
      \ 'bold': g:cobalt_bold == 1 ? 'bold' : 0,
      \ 'italic': g:cobalt_italic == 1 ? 'italic' : 0,
      \ 'underline': g:cobalt_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:cobalt_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:cobalt_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...)
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !has('gui_running')
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

function! s:Background()
  if g:cobalt_colorterm || has('gui_running')
    return s:bg
  else
    return s:none
  endif
endfunction

call s:h('CobaltBgLight', s:none, s:bglight)
call s:h('CobaltBgLighter', s:none, s:bglighter)
call s:h('CobaltBgDark', s:none, s:bgdark)
call s:h('CobaltBgDarker', s:none, s:bgdarker)

call s:h('CobaltFg', s:fg)
call s:h('CobaltFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('CobaltFgBold', s:fg, s:none, [s:attrs.bold])

call s:h('CobaltComment', s:comment)
call s:h('CobaltCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('CobaltSelection', s:none, s:selection)

call s:h('CobaltSubtle', s:subtle)

call s:h('CobaltCyan', s:cyan)
call s:h('CobaltCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('CobaltGreen', s:green)
call s:h('CobaltGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('CobaltGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('CobaltGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('CobaltOrange', s:orange)
call s:h('CobaltOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('CobaltOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('CobaltOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('CobaltOrangeInverse', s:bg, s:orange)

call s:h('CobaltPink', s:pink)
call s:h('CobaltPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('CobaltPurple', s:purple)
call s:h('CobaltPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('CobaltPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('CobaltRed', s:red)
call s:h('CobaltRedInverse', s:fg, s:red)

call s:h('CobaltYellow', s:yellow)
call s:h('CobaltYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('CobaltError', s:red, s:none, [], s:red)

call s:h('CobaltErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('CobaltWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('CobaltInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('CobaltTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('CobaltSearch', s:green, s:none, [s:attrs.inverse])
call s:h('CobaltBoundary', s:comment, s:bgdark)
call s:h('CobaltLink', s:cyan, s:none, [s:attrs.underline])

call s:h('CobaltDiffChange', s:none, s:none)
call s:h('CobaltDiffText', s:bg, s:orange)
call s:h('CobaltDiffDelete', s:red, s:bgdark)

set background=dark

call s:h('Normal', s:fg, s:Background())
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  CobaltSelection
hi! link CursorColumn CobaltSelection
hi! link CursorLineNr CobaltYellow
hi! link DiffAdd      CobaltGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   CobaltDiffChange
hi! link DiffDelete   CobaltDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     CobaltDiffText
hi! link Directory    CobaltPurpleBold
hi! link ErrorMsg     CobaltRedInverse
hi! link FoldColumn   CobaltSubtle
hi! link Folded       CobaltBoundary
hi! link IncSearch    CobaltOrangeInverse
hi! link LineNr       CobaltComment
hi! link MoreMsg      CobaltFgBold
hi! link NonText      CobaltSubtle
hi! link Pmenu        CobaltBgDark
hi! link PmenuSbar    CobaltBgDark
hi! link PmenuSel     CobaltSelection
hi! link PmenuThumb   CobaltSelection
hi! link Question     CobaltFgBold
hi! link Search       CobaltSearch
hi! link SignColumn   CobaltComment
hi! link TabLine      CobaltBoundary
hi! link TabLineFill  CobaltBgDarker
hi! link TabLineSel   Normal
hi! link Title        CobaltGreenBold
hi! link VertSplit    CobaltBoundary
hi! link Visual       CobaltSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   CobaltOrangeInverse

call s:h('MatchParen', s:fg, s:pink, [s:attrs.underline])
call s:h('Conceal', s:comment, s:bglight)

hi! link Comment CobaltComment
hi! link Underlined CobaltFgUnderline
hi! link Todo CobaltTodo

hi! link Error CobaltError
hi! link SpellBad CobaltErrorLine
hi! link SpellLocal CobaltWarnLine
hi! link SpellCap CobaltInfoLine
hi! link SpellRare CobaltInfoLine

hi! link Constant CobaltPurple
hi! link String CobaltYellow
hi! link Character CobaltPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier CobaltFg
hi! link Function CobaltGreen

hi! link Statement CobaltPink
hi! link Conditional CobaltPink
hi! link Repeat CobaltPink
hi! link Label CobaltPink
hi! link Operator CobaltPink
hi! link Keyword CobaltPink
hi! link Exception CobaltPink

hi! link PreProc CobaltPink
hi! link Include CobaltPink
hi! link Define CobaltPink
hi! link Macro CobaltPink
hi! link PreCondit CobaltPink
hi! link StorageClass CobaltPink
hi! link Structure CobaltPink
hi! link Typedef CobaltPink

hi! link Type CobaltCyanItalic

hi! link Delimiter CobaltFg

hi! link Special CobaltPink
hi! link SpecialKey CobaltComment
hi! link SpecialComment CobaltCyanItalic
hi! link Tag CobaltCyan
hi! link helpHyperTextJump CobaltLink
hi! link helpCommand CobaltPurple
hi! link helpExample CobaltGreen
hi! link helpBacktick Special

" vim: fdm=marker ts=2 sts=2 sw=2: