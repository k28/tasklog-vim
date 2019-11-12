" ===========================================================
" タスクのログ管理する
" File:     tasklog.vim
" Author:   k28 <k28@me.com>
" Version:  0.1
" Lisence:  VIM LICENSE

"
" g:tasklist_filename_prefix_none
" g:tasklist_path
" g:tasklist_template_dir_path
" g:tasklist_task_suffix
" g:tasklist_title_pattern
"

if &cp || exists("g:autoloaded_tasklist")
  finish
endif
let g:autoloaded_tasklist = '1'

let s:cpo_save = &cpo
set cpo&vim

"
" setting
"

if !exists('g:tasklist_task_suffix')
  let g:tasklist_task_suffix = "markdown"
endif

" TODO delete ...
if !exists('g:tasklist_path')
  let g:tasklist_path = "/tmp/hoge"
endif

if !exists('g:tasklist_template_dir_path')
  let g:tasklist_template_dir_path = "/tmp/hoge"
endif

if !exists('g:tasklist_task_suffix')
  let g:tasklist_task_suffix = "md"
endif

if !exists('g:tasklist_title_pattern')
  let g:tasklist_title_pattern = ""
endif

function! tasklist#hoge()
  echo "hoge"
endfunction

function! tasklist#new(title)
  call tasklist#new_with_meta(a:title, [], [])
endfunction

function! tasklist#_complete_ymdhms(...)
  return [strftime("%Y%m%d%H%M")]
endfunction

function! s:esctitle(str)
  let str = a:str
  let str = tolower(str)
  let str = substitute(str, g:tasklist_title_pattern, '-', 'g')
  let str = substitute(str,'\(--\)+', '-', 'g')
  let str = substitute(str,'\(^-\|-$\)+', '-', 'g')
  return str
endfunction

function! s:escarg(s)
  return escape(substitute(a:s, '\\', '/', 'g'), ' ')
endfunction

function! tasklist#new_with_meta(title, tags, categories)
  let items = {
        \ 'title' : a:title,
        \ 'date'  : localtime(),
        \}

  if items['title'] == ''
    let items['title'] = input("Task title: ", "", "customlist, tasklist#_complete_ymdhms")
  endif
  if items['title'] == ''
    return
  endif

  if get(g:, 'tasklist_filename_prefix_none', 0) != 0
    let file_name = s:esctitle(items['title'])
  else
    let file_name = strftime("%Y-%m-%d-") . s:esctitle(items['title'])
  endif
  if stridx(items['title'], '.') == -1
    let file_name = file_name . "." . g:tasklist_task_suffix
  endif

  echo "Making that task " . file_name
  exe (&l:modified ? "sp" : "e") s:escarg(g:tasklist_path . "/" . file_name)

  if !filereadable(s:escarg(g:tasklist_path . "/" . file_name))
    " task template
    let template = s:default_template
    if g:tasklist_template_dir_path != ""
      let path = expand(g:tasklist_template_dir_path, ":p")
      let path = path . "/" . g:tasklist_task_suffix . ".txt"
      if filereadable(path)
        let template = readfile(path)
      endif
    endif

    " apply template
    let old_undolevels = &undolevels
    set undolevels=-1
    call append(0, s:apply_template(template, items))
    let &undolevels = old_undolevels
    set nomodified
  endif

endfunction

let s:default_template = [
      \ 'title: {{_title_}}',
      \ '========',
      \ 'date: {{_date_}}',
      \ 'tags: {{_tags_}}',
      \ 'categories: {{_categories_}}',
      \ '- - -',
      \]

function! s:apply_template(template, items)
  let mx = '{{_\(\w\+\)_}}'
  return map(copy(a:template), "
        \ substitute(v:val, mx, 
        \ '\\=has_key(a:items, submatch(1)) ? a:items[submatch(1)] : submatch(0)' , 'g')
        \ ")
endfunction


let &cpo = s:cpo_save

" vim:set ft=vim ts=2 sw=2 sts=2:
