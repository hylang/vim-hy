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

" Use the Clojure indenting
runtime! indent/clojure.vim

if exists("*searchpairpos")

  function! GetHyIndent()
    let l:clojure_align_multiline_strings = g:clojure_align_multiline_strings
    let l:clojure_special_indent_words = g:clojure_special_indent_words
    if !exists('g:hy_align_multiline_strings')
      let g:hy_align_multiline_strings = 1
    endif
    let g:clojure_special_indent_words = ''
    try
      let l:ret = GetClojureIndent()
    finally
      let g:clojure_align_multiline_strings = l:clojure_align_multiline_strings
      let g:clojure_special_indent_words = l:clojure_special_indent_words
    endtry
    return l:ret
  endfunction

  setlocal indentexpr=GetHyIndent()

endif
