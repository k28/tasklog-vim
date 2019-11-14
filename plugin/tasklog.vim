" ===========================================================
" Manage task as log.
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
  let g:tasklist_path = $HOME . "/tasklist"
endif

" task kind
if !exists('g:tasklist_taskkind_current')
  let g:tasklist_taskkind_all     = 0
  let g:tasklist_taskkind_current = 1
  let g:tasklist_taskkind_done    = 2
endif

command! -nargs=0 TaskList          :call tasklist#list(g:tasklist_taskkind_current)
command! -nargs=0 TaskListDoneList  :call tasklist#list(g:tasklist_taskkind_done)
command! -nargs=0 TaskListAllList   :call tasklist#list(g:tasklist_taskkind_all)
command! -nargs=0 TaskListDone      :call tasklist#done()
command! -nargs=? TaskListGrep      :call tasklist#grep(<q-args>)
command! -nargs=? TaskListNew       :call tasklist#new(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim ts=2 sw=2 sts=2:
