" This code is almost verbatim from fireplace by Tim Pope.

augroup fireplace_connect
	autocmd FileType hy command! -buffer -bar -nargs=*
		\ Connect FireplaceConnect <args>
augroup END

function! s:set_up_eval() abort
	command! -buffer -bang -range=0 -nargs=? Eval :exe s:Eval(<bang>0, <line1>, <line2>, <count>, <q-args>)
	command! -buffer -bar -nargs=1 -complete=customlist,fireplace#eval_complete Doc     :exe s:Doc(<q-args>)

	nmap <buffer> cp <Plug>FireplacePrint
	nmap <buffer> cpp <Plug>FireplaceCountPrint

	nmap <buffer> cm <Plug>FireplaceMacroExpand
	nmap <buffer> cmm <Plug>FireplaceCountMacroExpand

	nmap <buffer> cqp <Plug>FireplacePrompt

	map! <buffer> <C-R>( <Plug>FireplaceRecall

	nmap <buffer> K <Plug>FireplaceK
endfunction

if !exists('s:qffiles')
  let s:qffiles = {}
endif

function! s:buf() abort
  if exists('s:input')
    return s:input
  elseif has_key(s:qffiles, expand('%:p'))
    return s:qffiles[expand('%:p')].buffer
  else
    return '%'
  endif
endfunction

function! s:buffer_path(...) abort
  let buffer = a:0 ? a:1 : s:buf()
  if getbufvar(buffer, '&buftype') =~# '^no'
    return ''
  endif
  let path = substitute(fnamemodify(bufname(buffer), ':p'), '\C^zipfile:\(.*\)::', '\1/', '')
  for dir in fireplace#path(buffer)
    if dir !=# '' && path[0 : strlen(dir)-1] ==# dir && path[strlen(dir)] =~# '[\/]'
      return path[strlen(dir)+1:-1]
    endif
  endfor
  return ''
endfunction

function! s:Eval(bang, line1, line2, count, args) abort
  let options = {}
  if a:args !=# ''
    let expr = a:args
  else
    if a:count ==# 0
      let open = '[[{(]'
      let close = '[]})]'
      let [line1, col1] = searchpairpos(open, '', close, 'bcrn', g:fireplace#skip)
      let [line2, col2] = searchpairpos(open, '', close, 'rn', g:fireplace#skip)
      if !line1 && !line2
        let [line1, col1] = searchpairpos(open, '', close, 'brn', g:fireplace#skip)
        let [line2, col2] = searchpairpos(open, '', close, 'crn', g:fireplace#skip)
      endif
      while col1 > 1 && getline(line1)[col1-2] =~# '[#''`~@]'
        let col1 -= 1
      endwhile
    else
      let line1 = a:line1
      let line2 = a:line2
      let col1 = 1
      let col2 = strlen(getline(line2))
    endif
    if !line1 || !line2
      return ''
    endif
    let options.file_path = s:buffer_path()
    let expr = repeat("\n", line1-1).repeat(" ", col1-1)
    if line1 == line2
      let expr .= getline(line1)[col1-1 : col2-1]
    else
      let expr .= getline(line1)[col1-1 : -1] . "\n"
            \ . join(map(getline(line1+1, line2-1), 'v:val . "\n"'))
            \ . getline(line2)[0 : col2-1]
    endif
    if a:bang
      exe line1.','.line2.'delete _'
    endif
  endif
  if a:bang
    try
      let result = fireplace#session_eval(expr, options)
      if a:args !=# ''
        call append(a:line1, result)
        exe a:line1
      else
        call append(a:line1-1, result)
        exe a:line1-1
      endif
    catch /^Clojure:/
    endtry
  else
    call fireplace#echo_session_eval(expr, options)
  endif
  return ''
endfunction

augroup fireplace_bindings
	autocmd FileType hy call s:set_up_eval()
augroup END

function! s:Doc(symbol) abort
	let info = fireplace#info(a:symbol)
	if has_key(info, 'ns') && has_key(info, 'name')
		echo info.ns . ' ' . info.name
	elseif has_key(info, "name")
		echo info.name
	endif
	if get(info, 'arglists-str', 'nil') !=# 'nil'
		echo info['arglists-str']
	endif
	if !empty(get(info, 'doc', ''))
		echo "\n" . info.doc
	endif
	return ''
endfunction

function! s:K() abort
	let word = expand('<cword>')
	return 'Doc '.word
endfunction
