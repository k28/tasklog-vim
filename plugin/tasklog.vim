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

if !exists('g:tasklog_path')
  let g:tasklog_path = $HOME . "/tasklog"
endif

" task kind
if !exists('g:tasklog_taskkind_current')
  let g:tasklog_taskkind_all     = 0
  let g:tasklog_taskkind_current = 1
  let g:tasklog_taskkind_done    = 2
endif

command! -nargs=0 TaskLog          :call tasklog#list(g:tasklog_taskkind_current)
command! -nargs=0 TaskLogDoneList  :call tasklog#list(g:tasklog_taskkind_done)
command! -nargs=0 TaskLogAllList   :call tasklog#list(g:tasklog_taskkind_all)
command! -nargs=0 TaskLogDone      :call tasklog#done()
command! -nargs=? TaskLogGrep      :call tasklog#grep(<q-args>)
command! -nargs=? TaskLogNew       :call tasklog#new(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set ft=vim ts=2 sw=2 sts=2:
