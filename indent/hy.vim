" Vim indent file
" Language:	Hy
" Maintainer:	Gregor Best <gbe@unobtanium.de>
" URL:		 
" Last Change:	2014 Jun 24
" Based on the Lisp indent file by Sergey Khorev (<sergey.khorev@gmail.com>), 
" http://sites.google.com/site/khorser/opensource/vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1

setlocal ai nosi
setlocal et

setlocal lispwords+=defmain,import,with-decorator,defn
setlocal lisp

let b:undo_indent = "setl ai< si< et< lw< lisp<"
