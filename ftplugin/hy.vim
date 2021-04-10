" Vim filetype plugin file
" Language:     Hy
" Author:       György Andorka <gyorgy.andorka@protonmail.com>
" URL:          http://github.com/hylang/vim-hy

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1
let b:undo_ftplugin = "setlocal iskeyword< suffixesadd< comments< commentstring<"

let s:cpo_save = &cpo
set cpo&vim

" TODO figure out proper 'iskeyword' values

setlocal suffixesadd=.hy,.py

setlocal comments=n:;
" Commenter plugins tend to depend on this variable, and two semicolons seems a
" better default, as the Hy style guide recommends a single semicolon for margin
" comments only.
setlocal commentstring=;;\ %s

let &cpo = s:cpo_save
unlet s:cpo_save
