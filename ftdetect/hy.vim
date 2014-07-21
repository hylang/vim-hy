au BufRead,BufNewFile  *.hy set filetype=hy

fun! s:DetectHyShebang()
    if getline(1) =~# '^#!.*/bin/env\s\+hy\>'
        set ft=hy
    endif
endfun

autocmd BufNewFile,BufRead * call s:DetectHyShebang()
