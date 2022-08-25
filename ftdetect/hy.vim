au BufRead,BufNewFile  *.hy setf hy

fun! s:DetectHyShebang()
    if getline(1) =~# '^#!.*/bin/env\s\+hy\>'
        setf hy
    endif
endfun

autocmd BufNewFile,BufRead * call s:DetectHyShebang()
