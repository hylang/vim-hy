" Vim indent file
" Language:	   Hy
" Maintainer:	Gregor Best <gbe@unobtanium.de>
" URL:		   https://github.com/farhaven/vim-hy
" Last Change:	2014 Jun 24
"
" Based on the Lisp indent file by Sergey Khorev (<sergey.khorev@gmail.com>), 
" http://sites.google.com/site/khorser/opensource/vim

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
   finish
endif
let b:did_indent = 1
let b:undo_indent = "setl ai< si< et< lw< lisp<"

setlocal ai nosi nolisp
setlocal softtabstop=2 shiftwidth=2 expandtab

" hyConstant
setlocal lispwords+=null,nil

" hyBoolean
setlocal lispwords+=false,true

" hySpecial
setlocal lispwords+=macro-error,defmacro-alias,let,if-python2,def,setv,fn,lambda

" hyException
setlocal lispwords+=throw,raise,try,except,catch

" hyCond
setlocal lispwords+=cond,if-not,lisp-if,lif,when,unless

" hyRepeat
setlocal lispwords+=loop,for*,while

" hyDefine
setlocal lispwords+=defmacro/g!,defmain,defn-alias,defun-alias,defmulti,defnc
setlocal lispwords+=defclass,defmacro,defreader,defn,defun

" hyMacro
setlocal lispwords+=,->,->>,ap-dotimes,ap-each,ap-each-while,ap-filter,ap-first
setlocal lispwords+=ap-if,ap-last,ap-map,ap-map-when,ap-reduce,ap-reject,car,cdr
setlocal lispwords+=defnc,delete-route,fnc,fnr,for,macroexpand-all,post-route
setlocal lispwords+=postwalk,prewalk,profile/calls,profile/cpu,put-route,route
setlocal lispwords+=route-with-methods,walk,with,with-gensyms

" hyFunc
setlocal lispwords+=,!=,%,%=,&,&=,*,**,**=,*=,+,+=,\,,-,--trampoline--,-=,.,/
setlocal lispwords+=,//,//=,/=,<,<<,<<=,<=,=,>,>=,>>,>>=,HyComplex,HyCons
setlocal lispwords+=HyExpression,HyFloat,HyInteger,HyKeyword,HyList,HyString
setlocal lispwords+=HySymbol,^,^=,_flatten,_numeric-check,and,apply,assert,assoc
setlocal lispwords+=break,calling-module-name,coll?,cons,cons?,continue,curry
setlocal lispwords+=dec,del,dict-comp,disassemble,dispatch-reader-macro,distinct
setlocal lispwords+=do,drop,empty?,eval,eval-and-compile,eval-when-compile
setlocal lispwords+=even?,every?,fake-source-positions,first,flatten,float?
setlocal lispwords+=from,genexpr,gensym,get,global,identity,if,import,in,inc
setlocal lispwords+=instance?,integer,integer-char?,integer?,is,is-not
setlocal lispwords+=iterable?,iterate,iterator?,keyword?,list,list*,list-comp
setlocal lispwords+=macroexpand,macroexpand-1,neg?,nil?,none?,not,not-in,nth
setlocal lispwords+=numeric?,odd?,or,pos?,progn,quasiquote,quote
setlocal lispwords+=recursive-replace,remove,repeatedly,require,rest,second
setlocal lispwords+=set-comp,setlocal,lispwords+=,slice,some,string,string?
setlocal lispwords+=take,take-nth,unquote,unquote-splicing,with*,with-decorator
setlocal lispwords+=yield,yield-from,zero?,\|=,~,\|

function! HyIndent()
	let p = getpos(".")
	let [lnum, lcol] = searchpairpos('{', '', '}', 'b')
	call cursor(p[1], p[2])
	if lnum != 0 && lcol != 0 && lnum < line(".")
		return lcol
	endif

	let [lnum, lcol] = searchpairpos('\[', '', '\]', 'b')
	call cursor(p[1], p[2])
	if lnum != 0 && lcol != 0 && lnum < line(".")
		return lcol
	endif

	return lispindent(".")
endfunction

setlocal indentexpr=HyIndent()
