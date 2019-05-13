set omnifunc=syntaxcomplete#Complete
filetype plugin on
set completeopt=longest,menuone
function! TabComplete(forwards)
	if (pumvisible())
		return a:forwards ? "\<C-N>" : "\<C-P>"
	endif
  let line = getline('.')
  let substr = strpart(line, col('.')-3, 2)
  let substr = matchstr(substr, "[^ \t]*$")
  if (strlen(substr)==0)
    return "\<tab>"
  endif
  let has_slash = match(substr, '\/') != -1
  let has_dot = match(substr, '\.') != -1
  if (has_dot)
    return "\<C-X>\<C-O>"
  elseif (has_slash)
    return "\<C-X>\<C-F>"
  else
    return "\<C-N>"
  endif
endfunction
inoremap <Tab> <c-r>=TabComplete(1)<CR>
inoremap <S-Tab> <c-r>=TabComplete(0)<CR>
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"

