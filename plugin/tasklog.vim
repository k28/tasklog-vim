" ===========================================================
" タスクのログ管理する
" File:     tasklog.vim
" Author:   k28 <k28@me.com>
" Version:  0.1
" Lisence:  VIM LICENSE

if exists('g:loaded_task_log')
  finish
endif
let g:loaded_task_log = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:tasklog_path')
  let g:tasklog_path = $HOME . "/tasklog"
endif

command! -nargs=0 TaskLogHoge :call tasklist#hoge()

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim ts=2 sw=2 sts=2:
