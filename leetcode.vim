" vim:set ts=2 sts=2 sw=2 expandtab:

function! CloseAllTerm()
  for i in range(1, bufnr('$'))
    if getbufvar(i, '&buftype')==# "terminal"
      exec ':bd!'.i
    endif
  endfor
endfunction

function! ExecInTerm(cmd)
  let tbid = -1
  for i in range(1, bufnr('$'))
    if getbufvar(i, '&buftype')==# "terminal"
      let tbid = i
      break
    endif
  endfor

  if tbid == -1
    vert terminal
    let tbid = bufnr('')
  endif
 call term_sendkeys(tbid, a:cmd . "\<cr>")
endfunction

au BufWritePost ~/src/leetcode/*.java call ExecInTerm('lctest '.expand('%:p'))
nnoremap <leader>lp :!leetcode show -gxe --learn 5<CR>
nnoremap <leader>ls :call ExecInTerm('leetcode submit '.expand('%:p'))
nnoremap <leader>lT :call ExecInTerm('leetcode test '.expand('%:p'))<cr>
nnoremap <leader>lt :call ExecInTerm('lctest '.expand('%:p'))<cr>
