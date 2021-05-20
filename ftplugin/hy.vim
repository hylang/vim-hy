" Vim filetype plugin file
" Language:     Hy
" Author:       György Andorka <gyorgy.andorka@protonmail.com>
" URL:          http://github.com/hylang/vim-hy

if exists("b:did_ftplugin")
	finish
endif

" Start with Clojure ftplugin
runtime! ftplugin/clojure.vim

" Use two semicolons: The Hy style guide recommends a single semicolon for
" margin comments only.
setlocal commentstring=;;\ %s
