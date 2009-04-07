if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.sass    setfiletype sass
  au! BufRead,BufNewFile *.haml    setfiletype haml
augroup END
