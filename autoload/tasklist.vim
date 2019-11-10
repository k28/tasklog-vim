" ===========================================================
" タスクのログ管理する
" File:     tasklog.vim
" Author:   k28 <k28@me.com>
" Version:  0.1
" Lisence:  VIM LICENSE

let s:save_cpo = &cpo
set cpo&vim

function! tasklist#hoge()
  echo "hoge"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim ts=2 sw=2 sts=2:
