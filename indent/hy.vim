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
setlocal lispwords+=set-comp,slice,some,string,string?
setlocal lispwords+=take,take-nth,unquote,unquote-splicing,with*,with-decorator
setlocal lispwords+=yield,yield-from,zero?,\|=,~,\|

function! s:PrevPair(begin, end, here)
	call cursor(a:here, 0)
	return searchpairpos(a:begin, '', a:end, 'b')
endfunction

function! s:Compare(i1, i2)
	return a:i1[3] - a:i2[3]
endfunction

function! s:FirstWord(pos)
	call cursor(a:pos[0], a:pos[1] + 1)
	let delim = searchpos('[ \t(\[\{]', 'n', a:pos[0])
	return substitute(getline(a:pos[0])[a:pos[1]:delim[1]-1], '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! HyIndent(lnum)
	if a:lnum == 0
		return 0
	endif

	let braces = s:PrevPair('{', '}', a:lnum)
	let brackets = s:PrevPair('\[', '\]', a:lnum)
	let parens = s:PrevPair('(', ')', a:lnum)

	let braces = braces + [ "braces", abs(braces[0] - a:lnum)]
	let brackets = brackets + [ "brackets", abs(brackets[0] - a:lnum)]
	let parens = parens + [ "parens", abs(parens[0] - a:lnum)]

	let l = [braces, brackets, parens]
	call filter(l, '!(v:val[0] == 0 && v:val[1] == 0) && v:val[0] < + a:lnum')
	let l = sort(l, "s:Compare")

	if len(l) == 0
		" This means we're at the top level
		return 0
	endif

	if l[0][2] == "parens"
		let w = s:FirstWord([l[0][0], l[0][1]])
		if &lispwords =~# '\V\<' . w . '\>'
			return l[0][1] + &shiftwidth - 1
		endif
		return l[0][1] + len(w) + 1
	endif

	return l[0][1]
endfunction

setlocal indentexpr=HyIndent(v:lnum)
