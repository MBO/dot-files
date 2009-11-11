"from NERD_snippet.txt documentation


"remove all snippets from memory so we can source this script after
"modifying our snippets
call NERDSnippetsReset()

"slurp up all our snippets
call NERDSnippetsFromDirectory("~/.vim/snippets")

"use our html snippets for eruby and xhtml too
"call NERDSnippetsFromDirectoryForFiletype('~/.vim/snippets/html', 'eruby')
"call NERDSnippetsFromDirectoryForFiletype('~/.vim/snippets/html', 'xhtml')

"support functions that are called from our snippets
"---------------------------------------------------

function! Snippet_RubyClassNameFromFilename()
    let name = expand("%:t:r")
    return NS_camelcase(name)
endfunction

function! Snippet_MigrationNameFromFilename()
    let name = substitute(expand("%:t:r"), '^.\{-}_', '', '')
    return NS_camelcase(name)
endfunction

