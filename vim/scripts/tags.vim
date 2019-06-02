let db_file = $DOTFILES . "/local/tags/" . substitute($PWD, "\/", "\.", "g")
let db_ctags = db_file . ".ctags"
let db_cscope = db_file . ".cscope"
if filereadable(db_ctags)
  silent execute "set tags+=" . db_ctags
endif
if filereadable(db_cscope)
  silent execute "cs add " . db_cscope
endif

function! GenerateCtags(file)
  let exists = filereadable(a:file)
  execute "! $DOTFILES/bin/generate_ctags " . a:file
  if (! exists)
    execute "set tags+=" . a:file
  endif
endfunction
function! GenerateCscope(file)
  let exists = filereadable(a:file)
  execute "! $DOTFILES/bin/generate_cscope " . a:file
  if (! exists)
    execute "silent cs add " . a:file
  endif
endfunction
function! GenerateTags(file_base)
  call GenerateCtags(a:file_base . ".ctags")
  call GenerateCscope(a:file_base . ".cscope")
endfunction

command Tagme :call GenerateTags(db_file)

set csto=1
set notagrelative
nnoremap <Leader>g :cstag <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>f :cs find f <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>i :cs find i <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>a :cs find a <C-R>=expand("<cword>")<CR><CR>
