" ===========================================================
" タスクのログ管理する
" File:     tasklog.vim
" Author:   k28 <k28@me.com>
" Version:  0.1
" Lisence:  VIM LICENSE

if exists('g:loaded_task_list')
  finish
endif
let g:loaded_task_list = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:tasklist_path')
  let g:tasklist_path = $HOME . "/tasklog"
endif

command! -nargs=0 TaskList     :call tasklist#list()
command! -nargs=? TaskListNew  :call tasklist#new(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim ts=2 sw=2 sts=2:
