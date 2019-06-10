let db_file = $DOTFILES . "/local/tags/" . substitute($PWD, "\/", "\.", "g")
let db_ctags = db_file . ".ctags"
let db_cscope = db_file . ".cscope"
if filereadable(db_ctags)
  silent execute "set tags+=" . db_ctags
endif
if filereadable(db_cscope)
  silent execute "cs add " . db_cscope
endif

function! GenerateTags(file_base)
  let exists_ctags = filereadable(a:file_base . ".ctags")
  let exists_cscope = filereadable(a:file_base . ".cscope")
  execute "! $DOTFILES/bin/generate_tags"
  if (! exists_ctags)
    execute "set tags+=" . a:file_base . ".ctags"
  endif
  if (! exists_cscope)
    execute "silent cs add " . a:file_base . ".cscope"
  endif
endfunction

command! Tagme :call GenerateTags(db_file)

set csto=1
set notagrelative
