"=============================================================================
" .vimrc config file
" Author: Miros¿aw Boruta (boruta.miroslaw.gmail.com)
"=============================================================================

" set nocompatible on, changes other settings
set nocompatible        " nocp: turn off vi compatibility
" resize the window, so that number and fold columns fit
winsize 90 30

"=============================================================================
" General settings
"-----------------------------------------------------------------------------
set helpheight=10       " hh: minimal initial height of the help window
set history=50          " hi:  keep 50 lines of :command line history
set modeline            " ml:  turn on modelines
set modelines=5         " mls:  number of lines to check for modeline
set more                " more:  page on extended output
set mouse=a             " mouse:  enable the use of the mouse
set nobackup            " nobk:  don't keep backup file
set ttyfast             " tf:  indicates a fast terminal connection
set undolevels=1000     " ul:  lots of undo

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
set formatoptions=cqrt  " fo:  automatic formatting
set listchars=eol:$,precedes:«,extends:»,tab:»·,trail:· " lsc:
                        "   chars in 'list' mode
set noequalalways       " noea: don't always keep windows at equal size
set noerrorbells        " noeb:  ring the bell for error messages
set nowrap              " nowrap:  lines will not wrap
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
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P  "this is default with ruler
set statusline=%([%-n]%y\ %f%M%R%)\ %=\ %(%l,%c%V\ %P\ [0x%02.2B]%)
"set statusline=[%n]\ %{ModifiedFlag()}%f\ %=%h%r%w\ (%v,%l)\ %P\

"=============================================================================
" File Autocompletion
"-----------------------------------------------------------------------------
set wildchar=<Tab>      " wc:  tab does autoconpletion
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

" grap spell file from ftp://ftp.vim.org/pub/vim/runtime/spell
set spelllang=en,pl
"set spell

"=============================================================================
" Misc
"-----------------------------------------------------------------------------
" gp:  use custom grep program (perl script)
if has("unix")
    set grepprg=ack\ -a
elseif has("win32")
    set grepprg="C:\\cmp\\ack.pl -a"
endif

syntax on               " turn on syntax highlighting
if has("autocmd")
    filetype plugin indent on
endif

" For all text files set 'textwidth' to 78 characters.
au FileType text setlocal textwidth=78

" Highlighting current cursor line and collumn for active window
" cul:  highlight the screen line of the cursor
" cuc:  highlight the screen column
"au WinEnter * set cursorline " cursorcolumn
"au WinLeave * set nocursorline " nocursorcolumn
" mappings for tabs
map <C-Tab> gt
map <C-S-Tab> gT

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
        set guifont=Inconsolata\ Medium\ 12,DejaVu\ Sans\ Mono\ 10,Monospace\ 10
    elseif has("x11")
        " Also for GTK 1
        set guifont=*-lucidatypewriter-medium-r-normal-*-*-100-*-*-m-*-*
    elseif has("gui_win32")
        set guifont=DejaVu_Sans_Mono:h10:cEASTEUROPE,Lucida_Sans_Typewriter:h10:cEASTEUROPE,Lucida_Console:h10:cEASTEUROPE,Courier_New:h10:cEASTEUROPE,Fixedys:h10:cEASTEUROPE
    endif

    set guioptions+=a   " go: a - autoselect
    set guioptions+=c   " go: c - use consle dialogs
    "set guioptions+=f   " go: f - don't detach the gui from the shell
    set guioptions-=T   " go: T - don't include toolbar
endif

"=============================================================================
" Colorscheme
"-----------------------------------------------------------------------------
" function to switch over favourite colorschemes
function! <SID>SwitchPSCStyle(inc)
    if !exists("s:colo_tab")
        let s:colo_tab = [ "vividchalk", "norwaytoday" ,"evening", "ashen", "slate" ]
    endif
    if exists("s:colo_id")
        let s:colo_id = (s:colo_id + a:inc) % len(s:colo_tab)
    else
        let s:colo_id = a:inc % len(s:colo_tab)
    endif
    execute "colorscheme" s:colo_tab[s:colo_id]
endfunction

map <silent> <leader>tn :call <SID>SwitchPSCStyle(1)<CR>
map <silent> <leader>tp :call <SID>SwitchPSCStyle(-1)<CR>
call <SID>SwitchPSCStyle(0)

"=============================================================================
" automatically give executable permissions if file begins with #! and contains
" '/bin/' in the path
"=============================================================================
function ModeChange()
    if getline(1) =~ "^#!.*/bin/"
        silent !chmod a+x <afile>
    endif
endfunction
if has("unix")
    au BufWritePost * call ModeChange()
endif
"=============================================================================
" Plugins
"-----------------------------------------------------------------------------
" Buffer Explorer / Browser:
" http://www.vim.org/scripts/script.php?script_id=42

" Tag List: http://vim-taglist.sourceforge.net
map <silent> <F4> :TlistToggle<CR>
let Tlist_GainFocus_On_ToggleOpen=1
if has("win32")
    let Tlist_Ctags_Cmd="C:\\cmd\\ctags.exe"
elseif has("unix")
    let Tlist_Ctags_Cmd="ctags"
endif

" NERD tree
" NERD commenter
" Perl IDE
" Source Explorrer
" Calendar
" Gist
let g:gist_open_browser_after_post=1
let g:gist_browser_command='opera %URL% &'

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

" Tip 964
" Copy/Paste keybindings
map  <F7> gg"*yG <C-o> <C-o>
vmap <F7> "*y
imap <S-F7> <C-o>"*p
map  <S-F7> "*p
set pastetoggle=<F8>   " pt:  key used to toggle :past

" Tip 920
" Map key to toggle opt
function MapToggle(key, opt)
    let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
    exec 'nnoremap '.a:key.' '.cmd
    exec 'inoremap '.a:key." \<C-O>".cmd
endfunction
command -nargs=+ MapToggle call MapToggle(<f-args>)
" Display-altering option toggles
MapToggle <F1> hlsearch
MapToggle <F2> wrap
MapToggle <F3> list

" Tip 764
"nnoremap <CR> :set nohlsearch \| set hlsearch?<CR>

map <F5> :e!<CR>

map <F6> :split<CR>
map <S-F6> :vsplit<CR>

let g:skip_loading_mswin=1
behave xterm

" Works only in xterm, not in Win ;-(
map <S-MouseDown> <C-F>
map <C-MouseDown> <C-F>

map <S-MouseUp> <C-B>
map <C-MouseUp> <C-B>

" Map C-BS to work like in Windows in insert mode
imap <C-BS> <C-O>db


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

