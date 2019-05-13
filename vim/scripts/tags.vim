let db_file = $DOTFILES . "/local/tags/" . substitute($PWD, "\/", "\.", "g")
let db_ctags = db_file . ".ctags"
let db_cscope = db_file . ".cscope"
if filereadable(db_ctags)
  silent execute "set tags=" . db_ctags
endif
if filereadable(db_cscope)
  silent execute "cs add " . db_cscope
endif

function! GenerateCtags()
  let db_ctags = $DOTFILES . "/local/tags/" . substitute($PWD, "\/", "\.", "g") . ".ctags"
  execute "! $DOTFILES/bin/generate_ctags " . db_ctags
  execute "set tags=" . db_ctags
endfunction
function! GenerateCscope()
  let db_cscope = $DOTFILES . "/local/tags/" . substitute($PWD, "\/", "\.", "g") . ".cscope"
  let exists = filereadable(db_cscope)
  execute "! $DOTFILES/bin/generate_cscope " . db_cscope
  if (! exists)
    execute "cs add " . db_cscope
  endif
endfunction
function! GenerateTags()
  call GenerateCtags()
  call GenerateCscope()
endfunction

command Tagme :call GenerateTags()

nnoremap <Leader>g :cstag <C-R>=expand("<cword>")<CR><CR>
nnoremap <Leader>c :cs find c <C-R>=expand("<cword>")<CR><CR>
