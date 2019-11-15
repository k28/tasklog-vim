" ===========================================================
" Manage task as log.
" File:     tasklog.vim
" Author:   k28 <k28@me.com>
" Version:  0.1
" Lisence:  VIM LICENSE

"
" g:tasklog_filename_prefix_none
" g:tasklog_path
" g:tasklog_current_task_dir_name
" g:tasklog_done_task_dir_name
" g:tasklog_template_dir_path
" g:tasklog_task_suffix
" g:tasklog_title_pattern
"

if &cp || exists("g:autoloaded_tasklog")
  finish
endif
let g:autoloaded_tasklog = '1'

let s:cpo_save = &cpo
set cpo&vim

"
" setting
"

if !exists('g:tasklog_current_task_dir_name')
  let g:tasklog_current_task_dir_name = "current"
endif

if !exists('g:tasklog_done_task_dir_name')
  let g:tasklog_done_task_dir_name = "done"
endif

if !exists('g:tasklog_task_suffix')
  let g:tasklog_task_suffix = "md"
endif

if !exists('g:tasklog_template_dir_path')
  " TODO Fix path
  let g:tasklog_template_dir_path = "/tmp/hoge"
endif

if !exists('g:tasklog_task_suffix')
  let g:tasklog_task_suffix = "md"
endif

if !exists('g:tasklog_title_pattern')
  let g:tasklog_title_pattern = "[ /\\'\"]"
endif

if !exists('g:tasklog_task_date')
  let g:tasklog_task_date = "%Y-%m-%d %H:%M"
endif

if !exists('g:tasklog_delimiter_yaml_array')
  let g:tasklog_delimiter_yaml_array = " "
endif

function! s:join_without_empty(list, ...)
  if empty(a:list) | return '' | endif
  let pattern = a:0 > 0 ? a:1 : '\v\s+'
  return join(type(a:list) == type([]) ? a:list : split(a:list, pattern),
        \ g:tasklog_delimiter_yaml_array)
endfunction

function! s:esctitle(str)
  let str = a:str
  let str = tolower(str)
  let str = substitute(str, g:tasklog_title_pattern, '-', 'g')
  let str = substitute(str,'\(--\)+', '-', 'g')
  let str = substitute(str,'\(^-\|-$\)+', '-', 'g')
  return str
endfunction

function! s:escarg(s)
  return escape(substitute(a:s, '\\', '/', 'g'), ' ')
endfunction

function! tasklog#task_path(kind)
  let tasklog_full_path = expand(g:tasklog_path)
  if a:kind == g:tasklog_taskkind_all
    return tasklog_full_path
  elseif a:kind == g:tasklog_taskkind_current
    return tasklog_full_path . "/" . g:tasklog_current_task_dir_name
  elseif a:kind == g:tasklog_taskkind_done
    return tasklog_full_path . "/" . g:tasklog_done_task_dir_name
  endif

  " default
  return tasklog_full_path . "/" . g:tasklog_current_task_dir_name
endfunction

function! tasklog#movefile(src, target)
  
endfunction

" move task file to done directory
function! tasklog#done()
  let current_file_dir = expand("%:p:h")
  if current_file_dir != tasklog#task_path(g:tasklog_taskkind_current)
    echomsg "this file is not taskfile."
    return
  endif

  let task_file_name = expand("%:t")
  let current_task_file_path = expand("%:p")
  let done_file_dir = tasklog#task_path(g:tasklog_taskkind_done) 
  let done_file_path = done_file_dir . "/" . task_file_name

  if !isdirectory(done_file_path)
    call mkdir(iconv(done_file_dir, &encoding, &termencoding), 'p')
  endif

  if rename(current_task_file_path, done_file_path) == 0
    " move to done file.
    execute("edit " . done_file_path)
    if delete(current_task_file_path) != 0
      " TODO delete always error, but success...
      echomsg "delete failed...."
    endif
  endif
endfunction

function! tasklog#_complete_ymdhms(...)
  return [strftime("%Y%m%d%H%M")]
endfunction

function! tasklog#list(kind)
  let list_search_path = tasklog#task_path(a:kind)
  " TODO ADD more source support, Denite, FZF
  if get(g:, 'tasklog_vimfiler', 0) != 0
    " TODO test
    exe "VimFiler" g:tasklog_vimfler_option s:escarg(list_search_path)
  elseif get(g:, 'tasklog_unite', 0) != 0
    " TODO Code and test
  else
    exe "e" s:escarg(list_search_path)
  endif
endfunction

function! tasklog#grep(word)
  let kind = g:tasklog_taskkind_current
  let grep_target_dir = tasklog#task_path(kind)

  let word = a:word
  if word == ''
    let word = input("TaskGrep word: ")
  endif
  if word == ''
    return
  endif

  try
    if get(g:, 'tasklog_qfixgrep', 0) != 0
      exe "Vimgrep -r" s:escarg(word) s:escarg(grep_target_dir . "/*")
    else
      exe "vimgrep" s:escarg(word) s:escarg(grep_target_dir . "/*")
    endif
  catch
    redraw | echohl ErrorMsg | echo v:exception | echohl None
  endtry

endfunction

function! tasklog#new(title)
  call tasklog#new_with_meta(a:title, [], [])
endfunction

function! tasklog#new_with_meta(title, tags, categories)
  let items = {
        \ 'title'       : a:title,
        \ 'date'        : localtime(),
        \ 'tags'        : s:join_without_empty(a:tags),
        \ 'categories'  : s:join_without_empty(a:categories),
        \}

  let kind = g:tasklog_taskkind_current
  let task_create_dir_path = tasklog#task_path(kind)

  if g:tasklog_task_date != 'epoch'
    let items['date'] = strftime(g:tasklog_task_date)
  endif

  if items['title'] == ''
    let items['title'] = input("Task title: ", "", "customlist, tasklog#_complete_ymdhms")
  endif
  if items['title'] == ''
    return
  endif

  if get(g:, 'tasklog_filename_prefix_none', 0) != 0
    let file_name = s:esctitle(items['title'])
  else
    let file_name = strftime("%Y-%m-%d-") . s:esctitle(items['title'])
  endif
  if stridx(items['title'], '.') == -1
    let file_name = file_name . "." . g:tasklog_task_suffix
  endif

  " Create directory if not exist.
  if !isdirectory(task_create_dir_path)
    call mkdir(iconv(task_create_dir_path, &encoding, &termencoding), 'p')
  endif

  echo "Making that task " . file_name
  exe (&l:modified ? "sp" : "e") s:escarg(task_create_dir_path . "/" . file_name)

  if !filereadable(s:escarg(task_create_dir_path . "/" . file_name))
    " task template
    let template = s:default_template
    if g:tasklog_template_dir_path != ""
      let path = expand(g:tasklog_template_dir_path, ":p")
      let path = path . "/" . g:tasklog_task_suffix . ".txt"
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
      \ 'tags: [{{_tags_}}]',
      \ 'categories: [{{_categories_}}]',
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
