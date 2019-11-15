# tasklog-vim

This is a vimscript for create and manage task. tasklist-vim is inspired by [memolist.vim](https://github.com/glidenote/memolist.vim).

## Setup
- Set task directory (default is #HOME/taskllog)
```
let g:tasklog_path = /path/to/tasklog
```

## Commands

| Command            | Action                              |
|--------------------|-------------------------------------|
| :TaskLog           | Open task list                      |
| :TaskLogDoneList   | Open done task list                 |
| :TaskLogAllList    | Open done/current task list         |
| :TaskLogDone       | Move current task to done directory |
| :TaskLogGrep       | Grep current task                   |
| :TaskLogNew        | Create new task                     |

## Options

let value = default

```
" current task directory name
let g:tasklog_current_task_dir_name = "current"

" done task directory name
let g:tasklog_done_task_dir_name = "done"

" new task suffix (if not specified)
let g:tasklog_task_suffix = "md"

" task template file direcotry (default: same as g:tasklog_path)
let g:tasklog_template_dir_path = g:tasklog_path

" task template file name
let g:tasklog_template_file_name = "template.txt"

" date format
let g:tasklog_task_date = "%Y-%m-%d %H:%M"

```

## License
Lcense: Same terms as Vim itself (see [license](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license))

