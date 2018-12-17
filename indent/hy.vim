" Vim indent file
" Language:    Hy
" Maintainer:  Gregor Best <gbe@unobtanium.de>
" URL:         https://github.com/hylang/vim-hy
" Last Change: 2015 Jun 01
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

setlocal iskeyword+=-,?,!,=,>,*,/,.

" hyConstant
setlocal lispwords+=null,nil,NaN,Inf

" hyBoolean
setlocal lispwords+=false,true

" hySpecial
setlocal lispwords+=macro-error,defmacro-alias,let,if-python2,def,setv,fn,fn/a,lambda
setlocal lispwords+=self

" hyException
setlocal lispwords+=throw,raise,try,except,catch,else,finally

" hyCond
setlocal lispwords+=cond,if-not,lisp-if,lif,lif-not,when,unless

" hyRepeat
setlocal lispwords+=loop,for*,while,lfor,sfor,dfor,gfor,for/a,recur

" hyDefine
setlocal lispwords+=defmacro/g!,defmain,defn-alias,defun-alias,defmulti,defnc
setlocal lispwords+=defclass,defmacro,defmacro!,defreader,defn,defun,defn/a
setlocal lispwords+=defsharp,deftag

" hyMacro
setlocal lispwords+=,->,->>,ap-dotimes,ap-each,ap-each-while,ap-filter,ap-first,ap-pipe
setlocal lispwords+=ap-compse,xi,ap-if,ap-last,ap-map,ap-map-when,ap-reduce,ap-reject,car,cdr
setlocal lispwords+=defnc,delete-route,fnc,fnr,for,for*,macroexpand-all,post-route
setlocal lispwords+=postwalk,prewalk,profile/calls,profile/cpu,put-route,route
setlocal lispwords+=route-with-methods,walk,with,with/a,with-gensyms

" hyFunc
setlocal lispwords+=,!=,%,%=,&,&=,*,**,**=,*=,+,+=,\,,-,--trampoline--,-=,.,/
setlocal lispwords+=,//,//=,/=,<,<<,<<=,<=,=,>,>=,>>,>>=,HyComplex,HyCons
setlocal lispwords+=HyExpression,HyFloat,HyInteger,HyKeyword,HyList,HyString
setlocal lispwords+=HySymbol,^,^=,_flatten,_numeric-check,and,kwapply,apply,assert,assoc

setlocal lispwords+=break,return,*map,accumulate,butlast,calling-module-name,chain
setlocal lispwords+=combinations,comp,complement,compress,constantly,count,cut
setlocal lispwords+=cycle,mangle,unmable,doto,drop-last,drop-while,filter,fraction
setlocal lispwords+=interleave,interpose,is_not,islice,juxt,keyword,last,merge-with
setlocal lispwords+=multicombinations,name,partition,permutations,product,range
setlocal lispwords+=read,read-str,reduce,repeat,symbol?,tee,xor,zip,zip-longest

setlocal lispwords+=coll?,cons,cons?,continue,curry
setlocal lispwords+=dec,del,dict-comp,disassemble,dispatch-reader-macro,distinct,do,drop
setlocal lispwords+=empty?,eval,eval-and-compile,eval-when-compile,even?,every?
setlocal lispwords+=fake-source-positions,first,flatten,float?,from
setlocal lispwords+=genexpr,gensym,get,global,nonlocal
setlocal lispwords+=identity,if,if*,import,in,inc,instance?,integer,integer-char?,integer?,is,is-not
setlocal lispwords+=iterable?,iterate,iterator?
setlocal lispwords+=keyword?
setlocal lispwords+=list,list*,list-comp
setlocal lispwords+=macroexpand,macroexpand-1,map
setlocal lispwords+=neg?,nil?,none?,not,not-in,nth,numeric?
setlocal lispwords+=odd?,or,pos?,progn,quasiquote,quote
setlocal lispwords+=recursive-replace,remove,repeatedly,require,rest
setlocal lispwords+=second,set-comp,slice,some,string,string?
setlocal lispwords+=take,take-nth,take-while
setlocal lispwords+=unquote,unquote-splicing,unquote-splice
setlocal lispwords+=with*,with-decorator
setlocal lispwords+=yield,yield-from,zero?,\|=,~,\|
setlocal lispwords+=print

let s:indent_path = fnamemodify(expand("<sfile>"), ":p:h")

if has("python3")
    command! -nargs=1 Python py3 <args>
    command! -nargs=1 Pyeval py3eval <args>
else
    command! -nargs=1 Python py <args>
    command! -nargs=1 Pyeval pyeval <args>
endif

Python import sys
exe 'Python sys.path.insert(0, "' . escape(s:indent_path, '\"') . '")'
Python import hy
Python import hy_indent
Python import vim

function! HyIndent(lnum)
  echo 'hy_indent.do_indent(' . a:lnum .')'
	Python hy_indent.do_indent(vim.eval('a:lnum'))
endfunction

setlocal indentexpr=HyIndent(a:lnum)
