""" Settings
set ignorecase					" search is case insensitive
set smartcase					" search case sensitive if caps on
set hlsearch					" Highlight matches to the search
set incsearch					" Find as you type

" * and # search for next/previous of selected text when used in visual mode.
" Add leading \V to prevent magic and escape \ and either / or ?
xnoremap g* y/\V<C-R>=escape(@", '/\')<CR><CR>
xnoremap g# y?\V<C-R>=escape(@", '?\')<CR><CR>

" Use && like :&&, but on visual selections.
xnoremap && :&&<CR>
" Let g& work how I'd expect on visual selections (only act on the visual
" selection). Different from && because it uses the current search query.
xnoremap g& :s//~/&<CR>
" I always want to re-use flags. If I change my mind, I can use :&
nnoremap & :&&<CR>

" Redo search with whole word toggled
function! <SID>ToggleWholeWord()
    " Adds or removes the \<\> word boundary markers on the current search
    " Note: Only applies to search query as a whole

    " remove whole word boundaries if they exists
    let search = substitute(@/, '\\<\(.*\)\\>', '\1', '')
    if search == @/
        " there were no whole word flags, so add them
        let search = '\<' . search . '\>'
    endif
    let @/ = search
endfunction
nnoremap <Leader>/ :call <SID>ToggleWholeWord()<CR>n

" Search within visual block
xnoremap <Leader>/ <Esc>/\%V

" Easy grep for current query
nnoremap <Leader>* :grep -e "<C-r>/" *

" Do smarter grep by ignoring files we probably don't want to search.
"
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
    call SmartGrepToggle(1)
	command! SmartGrepToggle echo SmartGrepToggle()
else
    " If grep isn't installed, then use vimgrep instead of falling back on 
    " findstr or other nonsense!
    set grepprg=internal
endif


"""""""""""
" Commands {{{1

" Remove all text except what matches the current search result. Will put each
" match on its own line. This is the opposite of :%s///g (which clears all
" instances of the current search).
function! s:ClearAllButMatches() range
    let is_whole_file = a:firstline == 1 && a:lastline == line('$')

    let old_c = @c

    let @c=""
    exec a:firstline .','. a:lastline .'sub//\=setreg("C", submatch(0), "l")/g'
    exec a:firstline .','. a:lastline .'delete _'
    put! c

    " I actually want the above to replace the whole selection with c, but I'll
    " settle for removing the blank line that's left when deleting the file
    " contents.
    if is_whole_file
        $delete _
    endif

    let @c = old_c
endfunction
command! -range=% ClearAllButMatches <line1>,<line2>call s:ClearAllButMatches()

" Create a query out of selected lines. You can use ToggleWholeWord to turn
" off whole word.
function! s:SearchForAnyLine() range
    let n_lines = a:lastline - a:firstline

    " Replace newlines with bar
    exec a:firstline .','. a:lastline .'s/\n/\\|/g'
    " Remove trailing bar
    exec a:firstline .','. a:firstline .'s/\\|$/'

    let @/ = '\<\('. getline(a:firstline) .'\)\>'
    " Undo our changes. TODO: Should probably slurp up lines and modify them
    " as a list instead.
    normal! un
endf
command! -range=% SearchForAnyLine <line1>,<line2>call s:SearchForAnyLine()

"}}}

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
