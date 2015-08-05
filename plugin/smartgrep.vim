" Do smarter grep by ignoring files we probably don't want to search.
"

if exists('loaded_smartgrep_grep') || &cp || version < 700
    finish
endif
let loaded_smartgrep_grep = 1

if !exists("g:searchsavvy_smartgrep_auto_enable")
    let g:searchsavvy_smartgrep_auto_enable = 1
endif

" Pass smarter options to grep. Can't use GREP_OPTIONS (it's deprecated and
" breaks things when used globally). When "smart" behaviour is undesireable,
" you can use SmartGrepToggle to turn it back off.
if executable('grep')
    " We always want grep if possible (not findstr). Use -H so it works on a
    " single file. (Apparently some greps may not support -H. How to fix
    " that?)
    let s:standard_args = ' -nH '

    " While GREP_OPTIONS was dangerous, it could be safely used within
    " confined contexts. However, it's no longer supported:
    "   https://lists.gnu.org/archive/html/grep-commit/2014-09/msg00007.html
    " Unfortunately, the only way to pass options is directly on the
    " command-line. The quickfix window title displays the grepprg used, and
    " we use so many options it would be hard to see what you searched for.
    " Use a script to avoid the options obscuring your query in the quickfix
    " window title.
    let s:smart_grepprg = fnamemodify(expand('<sfile>'), ':p:h:h') . '/bin/smartgrep' . s:standard_args

    " Generally, we don't want to look in nonsense files. If you really want
    " these, then toggle off intelligence. Pass 1 to force smartness.
    function! SmartGrepToggle(...)
        let force_on = a:0 && a:1
        if force_on
            let &grepprg = s:smart_grepprg
            return 'grep: smart'
        else
            let &grepprg = 'grep'. s:standard_args
            return 'grep: basic'
        endif
    endfunction

    if g:searchsavvy_smartgrep_auto_enable
        call SmartGrepToggle(1)
    endif
    command! SmartGrepToggle echo SmartGrepToggle()
else
    " If grep isn't installed, then use vimgrep instead of falling back on 
    " findstr or other nonsense!
    set grepprg=internal
endif
