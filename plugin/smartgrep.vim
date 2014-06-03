" Do smarter grep by ignoring files we probably don't want to search.
"

if exists('loaded_smartgrep_grep') || &cp || version < 700
    finish
endif
let loaded_smartgrep_grep = 1

if !exists("g:searchsavvy_smartgrep_auto_enable")
    let g:searchsavvy_smartgrep_auto_enable = 1
endif

" Use GREP_OPTIONS within vim. Can't use it globally or it breaks things. If
" it breaks things within vim, then you can use SmartGrepToggle to turn it
" back off.
if executable('grep')
    " We always want grep (not findstr). Use -H so it works on a single file.
    " (Apparently some greps may not support -H. How to fix that?)
    let &grepprg='grep -nH'

    " Generally, we don't want to look in nonsense files. If you really want
    " these, then toggle off intelligence. Pass 1 to force smartness.
    function! SmartGrepToggle(...)
        let smart_options = '--binary-files=without-match'
                    \ .' --exclude-dir=.cvs'
                    \ .' --exclude-dir=.git'
                    \ .' --exclude-dir=.hg'
                    \ .' --exclude-dir=.svn'
                    \ .' --exclude=*.swp'
                    \ .' --exclude=cscope.*'
                    \ .' --exclude=filelist'
                    \ .' --exclude=tags'

        " If changing GREP_OPTIONS breaks something
        " (http://stackoverflow.com/q/11713507/79125), you could set grepprg
        " instead, but it will be impossible to see the search query in the
        " quickfix statusbar:
        "let &grepprg='grep -nH ' . smart_options

        let force_on = a:0 && a:1
        if force_on || !exists('$GREP_OPTIONS')
            let $GREP_OPTIONS = smart_options
            return 'grep: smart'
        else
            let $GREP_OPTIONS = ''
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
