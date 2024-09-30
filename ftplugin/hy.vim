" Vim filetype plugin file
" Language:     Hy
" Author:       György Andorka <gyorgy.andorka@protonmail.com>
" URL:          http://github.com/hylang/vim-hy

if exists("b:did_ftplugin")
	finish
endif

" Start with Clojure ftplugin
runtime! ftplugin/clojure.vim
setlocal iskeyword-=.

" Hy specific lispwords:
" All core macros in https://hylang.org/hy/doc/v1.0.0/api
" with a simple rule: it should be indented specially (as lispwords) only if
" its first argument is special.
setlocal lispwords=let,if,when,while,for,lfor,dfor,gfor,sfor,with,match,try,
			\defn,fn,defmacro,defreader,defclass,except,except*
"
" Hyrule listwords:
" http://hylang.org/hyrule/doc/v0.6.0
" same rule as above
setlocal lispwords+=ap-if,ap-each,ap-each-while,ap-dotimes,ap-when,ap-with,
			\->,->>,as->,some->,doto,block,branch,case,cfor,
			\defmain,do-n,ebranch,ecase,list-n,loop,unless,defn+,
			\defn/a+,fn+,fn/a+,let+,defmacro-kwargs,defmacro!,
			\with-gensyms,seq,defseq,smacrolet

" Use two semicolons: The Hy style guide recommends a single semicolon for
" margin comments only.
setlocal commentstring=;;\ %s
