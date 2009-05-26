"=============================================================================
" What Is This: Display marks at lines with compilation error.
" File: cuteErrorMarker.vim
" Author: Vincent Berthoux <twinside@gmail.com>
" Last Change: 2009 mai 23
" Version: 1.0
" Thanks:
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
" Additional:
"     * if you don't want the automatic placing of markers
"       after a make, you can define :
"       let g:cuteerrors_no_autoload = 1
"
let s:signId = 33000
let s:signCount = 0

if has("win32")
    let s:path = expand("~/vimfiles/signs/")
    let s:ext = '.ico'
else
    let s:path = expand("~/.vim/signs/")
    let s:ext = '.png'
endif

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
    if a:error =~ 'warning'
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
            let filename = substitute( error, '^\s*\d\+\s\+\([a-zA-Z0-9._]*\).*', '\1', 'e' )
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

