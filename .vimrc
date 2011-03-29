"=============================================================================
" .vimrc config file
" Author: Mirosław Boruta (boruta.miroslaw.gmail.com)
"=============================================================================

" set nocompatible on, changes other settings
set nocompatible        " nocp: turn off vi compatibility
" resize the window, so that number and fold columns fit
"winsize 90 30

"=============================================================================
" General settings
"-----------------------------------------------------------------------------
set balloondelay=999999 " bdlay:  delay in milliseconds before balloon popup
set noballooneval       " nobeval:  no balloon-eval functionality
set helpheight=10       " hh: minimal initial height of the help window
set history=50          " hi:  keep 50 lines of :command line history
set modeline            " ml:  turn on modelines
set modelines=5         " mls:  number of lines to check for modeline
set more                " more:  page on extended output
set mouse=a             " mouse:  enable the use of the mouse
set nobackup            " nobk:  don't keep backup file
set noswapfile          " noswf:  don't keep swapfiles
set ttyfast             " tf:  indicates a fast terminal connection
set undolevels=1000     " ul:  lots of undo
set hidden              " hid:  don't display message about unsaved buffer

"=============================================================================
" Folds
"=============================================================================
set foldmethod=indent   " fdm:  lines with equal indent form a fold
set foldcolumn=4        " fdc:  shows folds at the side of the window
set foldlevel=1000      " fdl:  fold level
set foldlevelstart=1000 " fdls:  fold level start
set nofoldenable        " nofen:  open all folds on start

"=============================================================================
" Presentation
"-----------------------------------------------------------------------------
set formatprg=par       " fp: format line programm with gq operator
set formatoptions=tcrq  " fo:  automatic formatting
set listchars=eol:$,precedes:«,extends:»,tab:»·,trail:· " lsc:
                        "   chars in 'list' mode
set noequalalways       " noea: don't always keep windows at equal size
set noerrorbells        " noeb:  ring the bell for error messages
set nowrap              " nowrap:  lines will not wrap
set linebreak           " lbr:  break lines at break at when wrap is on
set number              " nu:  precede each line with its line number
set numberwidth=4       " nuw:  minimal number of columns to use for number
set showmatch           " sm:  jump to the matching bracket
set splitbelow          " sb:  slitted window appears below current one
set virtualedit=all     " ve:  virtual editing in all modes
set visualbell          " vb:  turn on visual bell
set whichwrap=<,>,b,s   " ww:  specified keys that move the cursor left/right
                        "   to move to prev/next line

"=============================================================================
" Statusline, ruler
"-----------------------------------------------------------------------------
set laststatus=2        " ls:  always put a status line
set ruler               " ru:  show the cursor position all the time
set shortmess=aIoO      " shm:  really short messages, don't show intro
set showcmd             " sc:  show command in the last line of the screen
set showmode            " smd:  show the current input mode
set showbreak=…         " sbr:  show start of hard wrapped line
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P  "this is default with ruler
set statusline=%([%-n]%y\ %f%M%R%)\ %=\ %(%l,%c%V\ %P\ [0x%02.2B]%)
"set statusline=[%n]\ %{ModifiedFlag()}%f\ %=%h%r%w\ (%v,%l)\ %P\

"=============================================================================
" File Autocompletion
"-----------------------------------------------------------------------------
set wildchar=<Tab>      " wc:  tab does autocompletion
set wildmenu            " wmnu:  wildmenu
set wildmode=full       " wim:  complete each full match

"=============================================================================
" Search and Replace
"-----------------------------------------------------------------------------
set hlsearch            " hls:  highlight search patterns
set ignorecase          " ic:  ignore case in search patterns
set incsearch           " is:  show partial matches as search is entered
set smartcase           " scs:  ignore case unless there are capitals in
                        "   the search

"=============================================================================
" Tab standards
"-----------------------------------------------------------------------------
set backspace+=eol      " bs:  backspace over end of line
set backspace+=indent   " bs:  backspace over autoindent
set backspace+=start    " bs:  backspace over start of insert
set expandtab           " et:  insert spaces instead of tabs
set shiftwidth=4        " sw:  number of spaces for each indent
set smarttab            " sta:  insert shiftwidth spaces in front of line
set tabstop=4           " ts:  number of spaces that a Tab counts for

" grab spell file from ftp://ftp.vim.org/pub/vim/runtime/spell
set spelllang=en

" Set mapleader to ","
let mapleader=","

"=============================================================================
" Misc
"-----------------------------------------------------------------------------
" gp:  use custom grep program (perl script)
if has("unix")
    set grepprg="ack-grep -a"
endif

syntax on               " turn on syntax highlighting
" Turn off filetype to init pathogen first
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on

" For all text files set 'textwidth' to 78 characters.
au FileType text setlocal textwidth=78

" Highlighting current cursor line and collumn for active window
" cul:  highlight the screen line of the cursor
" cuc:  highlight the screen column
" au WinEnter * set cursorline " cursorcolumn
" au WinLeave * set nocursorline " nocursorcolumn

" prepare to :Man command
if has("unix")
    runtime ftplugin/man.vim
endif
"=============================================================================
" Gui
"-----------------------------------------------------------------------------
" gfn:  set Font
if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ Medium\ 10,DejaVu\ Sans\ Mono\ 10,Monospace\ 10
    elseif has("x11")
        " Also for GTK 1
        set guifont=*-lucidatypewriter-medium-r-normal-*-*-100-*-*-m-*-*
    elseif has("gui_win32")
        set guifont=DejaVu_Sans_Mono:h10:cEASTEUROPE,Lucida_Sans_Typewriter:h10:cEASTEUROPE,Lucida_Console:h10:cEASTEUROPE,Courier_New:h10:cEASTEUROPE,Fixedys:h10:cEASTEUROPE
    endif

    set guioptions+=a   " go: a - autoselect
    set guioptions+=c   " go: c - use console dialogs
    "set guioptions+=f   " go: f - don't detach the gui from the shell
    set guioptions-=T   " go: T - don't include toolbar
endif

"=============================================================================
" Colorscheme
"-----------------------------------------------------------------------------
" function to switch over favourite colorschemes
function! <SID>SwitchPSCStyle(inc)
    if !exists("s:colo_tab")
        let s:colo_tab = [ "vividchalk", "github", "evening" ]
    endif
    if exists("s:colo_id")
        let s:colo_id = (s:colo_id + a:inc) % len(s:colo_tab)
    else
        let s:colo_id = a:inc % len(s:colo_tab)
    endif
    execute "colorscheme" s:colo_tab[s:colo_id]
endfunction
call <SID>SwitchPSCStyle(0)

"=============================================================================
" automatically give executable permissions if file begins with #! and contains
" '/bin/' in the path
"=============================================================================
function! <SID>ModeChange()
    if getline(1) =~ "^#!.*/bin/"
        silent !chmod a+x <afile>
    endif
endfunction
if has("unix")
    autocmd BufWritePost * call <SID>ModeChange()
endif
"=============================================================================
" Plugins
"-----------------------------------------------------------------------------
" Ack
let g:ackprg="ack-grep -H --nocolor --nogroup"
" Gist
let g:gist_clip_command = 'xclip -selection clipboard'
let g:gist_open_browser_after_post=1
let g:gist_browser_command='opera %URL% &'
" NERDTree
let NERDTreeCaseSensitiveSort=1
let NERDTreeChDirMode=2
let NERDTreeWinPos="left"
" TagList
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1

"=============================================================================
" Vim Tips Wiki (vim.wikia.com)
"=============================================================================
" Tip 2
" Expand current file directory while in command line
if has("unix")
    cmap %/ <C-R>=expand("%:p:h") . '/'<CR>
elseif has("win32")
    cmap %/ <C-R>=expand("%:p:h") . '\'<CR>
endif
" Tip 396
"highlight ExtraWhitespace ctermbg=red guibg=red
"au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Tip to highlight spell mistakes only in insert mode
" http://stackoverflow.com/questions/5040580/is-it-possible-to-toggle-a-vim-option-when-switching-to-insert-mode/5041384#5041384
autocmd InsertEnter * setlocal spell
autocmd InsertLeave * setlocal nospell

map  <silent> <F1>         :set hlsearch!<CR>
imap <silent> <F1>    <C-O>:set hlsearch!<CR>
map  <silent> <F2>         :set wrap!<CR>
imap <silent> <F2>    <C-O>:set wrap!<CR>
map  <silent> <F3>         :set list!<CR>
imap <silent> <F3>    <C-O>:set list!<CR>
map  <silent> <F4>         :TlistToggle<CR>
imap <silent> <F4>    <C-O>:TlistToggle<CR>
map  <silent> <F5>         :e!<CR>
imap <silent> <F5>    <C-O>:e!<CR>
map  <silent> <F6>         :vsplit<CR>
imap <silent> <F6>    <C-O>:vsplit<CR>
map  <silent> <S-F6>       :split<CR>
imap <silent> <S-F6>  <C-O>:split<CR>
map           <F7>         gg"*yG<C-o><C-o>
vmap          <F7>         "*y
imap          <S-F7>  <C-o>"*p
map           <S-F7>       "*p
set pastetoggle=<F8>   " pt:  key used to toggle :past
map  <silent> <F9>         :NERDTreeToggle<CR>
imap <silent> <F9>    <C-O>:NERDTreeToggle<CR>
map  <silent> <S-F9>       :NERDTreeFind<CR>
imap <silent> <S-F9>  <C-O>:NERDTreeFind<CR>

let g:skip_loading_mswin=1
behave xterm

map  <S-MouseDown>         <C-F>
map  <C-MouseDown>         <C-F>
map  <S-MouseUp>           <C-B>
map  <C-MouseUp>           <C-B>

map  <C-Tab>               gt
map  <C-S-Tab>             gT

" Map C-BS to work like in Windows in insert mode
imap <C-BS>           <C-O>db
imap <C-DEL>          <C-O>dw

nmap <silent> <leader>v    :edit $MYVIMRC<CR>
map  <silent> <leader>tn   :call <SID>SwitchPSCStyle(1)<CR>
map  <silent> <leader>tp   :call <SID>SwitchPSCStyle(-1)<CR>

map  <silent> <leader>/    :let @/=''<CR>
map  <silent> <leader>l    :set list!<CR>
" Scratch
map  <silent> <leader>s    :Sscratch<CR>
map  <silent> <leader>S    :Scratch<CR>

map  <silent> <leader>,    :set spell!<CR>

" Fuf
map  <silent> <leader>fb   :FufBuffer<CR>
map  <silent> <leader>fd   :FufDir<CR>
map  <silent> <leader>fD   :FufDirWithCurrentBufferDir<CR>
map  <silent> <leader>ff   :FufFile<CR>
map  <silent> <leader>fF   :FufFileWithCurrentBufferDir<CR>
map  <silent> <leader>fl   :FufLine<CR>
map  <silent> <leader>ft   :FufBufferTag<CR>
map  <silent> <leader>fc   :FufCoverageFile<CR>
map  <silent> <leader>fh   :FufHelp<CR>
map  <silent> <leader>fr   :FufRenewCache<CR>

" Operator camelize
map  <silent> <leader>oc   <Plug>(operator-camelize)
map  <silent> <leader>od   <Plug>(operator-decamelize)

" NarrowRegion
xmap <silent> <leader>nd   <Plug>NrrwrgnDo
map  <silent> <leader>nr   :NR<CR>
map  <silent> <leader>nw   :WidenRegion<CR>
map  <silent> <leader>np   :NRPrepare<CR>
map  <silent> <leader>nm   :NRMulti<CR>

" Learn vim movements
map  <Up>                  <Nop>
map  <C-Up>                <Nop>
map  <S-Up>                <Nop>
map  <M-Up>                <Nop>
map  <Down>                <Nop>
map  <C-Down>              <Nop>
map  <S-Down>              <Nop>
map  <M-Down>              <Nop>
map  <Left>                <Nop>
map  <C-Left>              <Nop>
map  <S-Left>              <Nop>
map  <M-Left>              <Nop>
map  <Right>               <Nop>
map  <C-Right>             <Nop>
map  <S-Right>             <Nop>
map  <M-Right>             <Nop>
map  <PageUp>              <Nop>
map  <PageDown>            <Nop>
map  <Home>                <Nop>
map  <End>                 <Nop>
map  <C-End>               <Nop>
map  <C-PageUp>            <Nop>
map  <C-PageDown>          <Nop>
map  <C-Home>              <Nop>
map  <S-End>               <Nop>
map  <S-End>               <Nop>
map  <S-PageUp>            <Nop>
map  <S-PageDown>          <Nop>
map  <S-Home>              <Nop>
map  <S-End>               <Nop>
map  <S-End>               <Nop>
map  <M-PageUp>            <Nop>
map  <M-PageDown>          <Nop>
map  <M-Home>              <Nop>
map  <M-End>               <Nop>
imap <Up>                  <Nop>
imap <C-Up>                <Nop>
imap <S-Up>                <Nop>
imap <M-Up>                <Nop>
imap <Down>                <Nop>
imap <C-Down>              <Nop>
imap <S-Down>              <Nop>
imap <M-Down>              <Nop>
imap <Left>                <Nop>
imap <C-Left>              <Nop>
imap <S-Left>              <Nop>
imap <M-Left>              <Nop>
imap <Right>               <Nop>
imap <C-Right>             <Nop>
imap <S-Right>             <Nop>
imap <M-Right>             <Nop>
imap <PageUp>              <Nop>
imap <PageDown>            <Nop>
imap <Home>                <Nop>
imap <C-End>               <Nop>
imap <C-PageUp>            <Nop>
imap <C-PageDown>          <Nop>
imap <C-Home>              <Nop>
imap <S-End>               <Nop>
imap <S-End>               <Nop>
imap <S-PageUp>            <Nop>
imap <S-PageDown>          <Nop>
imap <S-Home>              <Nop>
imap <S-End>               <Nop>
imap <S-End>               <Nop>
imap <M-PageUp>            <Nop>
imap <M-PageDown>          <Nop>
imap <M-Home>              <Nop>
imap <M-End>               <Nop>

" Syntax settings (:he syntax.txt)
" 2HTML
let html_ignore_folding=1
let html_use_css=1
let html_use_encoding="utf-8"

" C
let c_space_errors=1

" GROOVY
let groovy_highlight_groovy_lang_ids=1
let groovy_highlight_functions="style"
let groovy_highlight_debug=1
let groovy_space_errors=1

" JAVA
let java_highlight_java_lang_ids=1
let java_highlight_all=1
let java_highlight_functions="style"
let java_highlight_debug=1
let java_space_errors=1

" JavaScript
let javaScript_fold=1

" PERL
let perl_include_pod=1
let perl_string_as_statement=1
let perl_fold=1
let perl_fold_blocks=1
let perl_nofold_packages=1
let perl_want_scope_in_variables=1
let perl_extended_vars=1

" PYTHON
let python_highlight_numbers=1
let python_highlight_builtins=1
let python_highlight_exceptions=1
let python_highlight_space_errors=1

" RUBY
let ruby_operators=1
let ruby_fold=1
let ruby_space_errors=1

" TEX
let tex_fold_enabled=1
let tex_comment_nospell=1
let g:tex_indent_items=1

" vim:set encoding=utf-8
