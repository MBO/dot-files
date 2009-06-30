"=============================================================================
" What Is This: Display marks at lines with compilation error.
" File: cuteErrorMarker.vim
" Author: Vincent Berthoux <twinside@gmail.com>
" Last Change: 2009 june 28
" Version: 1.3
" Thanks:
" Require:
"   set nocompatible
"     somewhere on your .vimrc
" Usage:
"      :MarkErrors
"        Place markers near line from the error list
"      :CleanupMarkErrors
"        Remove all the markers
"       show calendar in normal mode
"      :RemoveErrorMarkersHook
"        Remove the autocommand for sign placing
"      :make
"        Place marker automatically by default
" ChangeLog:
"     * 1.3 :- Taking into account "Documents and Settings" folder...
"            - Adding icons source from $VIM or $VIMRUNTIME
"            - Checking the nocompatible option (the only one required)
"     * 1.2 :- Fixed problems with subdirectory
"            - Warning detection is now case insensitive
"     * 1.1 :- Bug fix when make returned only an error
"            - reduced flickering by avoiding redraw when not needed.
"     * 1.0 : Original version
" Additional:
"     * if you don't want the automatic placing of markers
"       after a make, you can define :
"       let g:cuteerrors_no_autoload = 1
"
if exists("g:__CUTEERRORMARKER_VIM__")
    finish
endif
let g:__CUTEERRORMARKER_VIM__ = 1

"======================================================================
"           Configuration checking
"======================================================================
if &compatible
    echom 'Cute Error Marker require the nocompatible option, loading aborted'
    echom "To fix it add 'set nocompatible' in your .vimrc file"
    finish
endif

fun! s:GetInstallPath(of) "{{{
    " If the plugin in installed in the vim runtime directory
    if filereadable( expand( '$VIMRUNTIME' ) . a:of )
        return expand( '$VIMRUNTIME' )
    endif

    " If the plugin in installed in the vim directory
    if filereadable( expand( '$VIM' ) . a:of )
        return expand( '$VIM' )
    endif

    if has("win32")
        let vimprofile = 'vimfiles'
    else
        let vimprofile = '.vim'
    endif

    " else in the profile directory
    if filereadable( expand( '~/' . vimprofile ) . a:of )
        return expand('~/' . vimprofile )
    endif

    return ''
endfunction "}}}

if has("win32")
    let s:ext = '.ico'
else
    let s:ext = '.png'
endif

let s:path = escape( s:GetInstallPath( '/signs/err' . s:ext ), ' \' )
if s:path == ''
    echom "Cute Error Marker can't find icons, plugin not loaded" 
    finish
else
    let s:path = s:path . '/signs/'
endif

"======================================================================
"           Plugin data
"======================================================================
let s:signId = 33000
let s:signCount = 0

exec 'sign define errhere text=[X icon=' . s:path . 'err' . s:ext
exec 'sign define warnhere text=/! icon=' . s:path . 'warn' . s:ext

fun! PlaceErrorMarkersHook() "{{{
    augroup cuteerrors
        "au !
        au QuickFixCmdPre make call CleanupMarkErrors()
        au QuickFixCmdPost make call MarkErrors()
    augroup END
endfunction "}}}

fun! RemoveErrorMarkersHook() "{{{
    augroup cuteerrors
        au!
    augroup END
endfunction "}}}

" compute the output of an Ex command
fun! s:ExOutput(txt) "{{{
    let tempz = getreg( 'z' )
    redir @z
    exec a:txt
    redir END

    let toRet = string(getreg( 'z' ))
    call setreg( 'z', tempz )

    return toRet
endfunction "}}}

fun! s:SelectClass( error ) "{{{
    if a:error =~ '\cwarning'
        return 'warnhere'
    else
        return 'errhere'
    endif
endfunction "}}}

fun! MarkErrors() "{{{
    let errText = s:ExOutput("silent clist")
    let errList = split( errText, '\n')

    for error in errList
        if error !~ "^\s*[\"']*\s*$" 
            let filename = substitute( error, '^\s*\d\+\s\+\(\([a-zA-Z0-9._]\+[\\/]\)*[a-zA-Z0-9._]\+\).*', '\1', 'e' )
            let matchedBuf = bufnr( filename )

            if matchedBuf >= 0
                let s:signCount = s:signCount + 1
                let id = s:signId + s:signCount
                let errClass = s:SelectClass( error )
                let errLn = substitute( error, '^[^:]*:\(\d\+\).*', '\1', 'e')
                let toPlace = 'sign place ' . id
                            \ . ' line=' . errLn
                            \ . ' name=' . errClass
                            \ . ' buffer=' . matchedBuf
                exec toPlace
            endif
        endif
    endfor

    " If we have placed some markers
    if s:signCount > 0
        redraw!
    endif
endfunction "}}}

fun! CleanupMarkErrors() "{{{
    let i = s:signId + s:signCount

    " this if is here to avoid redraw if un-needed
    if i > s:signId
        while i > s:signId
            let toRun = "sign unplace " . i
            exec toRun
            let i = i - 1
        endwhile

        let s:signCount = 0
        redraw!
    endif
endfunction "}}}

if !exists("g:cuteerrors_no_autoload")
    call PlaceErrorMarkersHook()
endif

command! MarkErrors call MarkErrors()
command! CleanupMarkErrors call CleanupMarkErrors()

