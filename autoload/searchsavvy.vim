
" Redo search with whole word toggled
function! searchsavvy#ToggleWholeWord()
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

" Easy grep for current query.
"
" If notgrep is installed, will use its conversion to prevent invalid grep
" expressions.
function! searchsavvy#GrepCurrentQuery()
    if exists('g:notgrep_loaded') && g:notgrep_loaded
        return notgrep#search#ConvertRegexVimToPerl(@/)
    else
        return @/
    endif
endfunction

" Remove all text except what matches the current search result. Will put each
" match on its own line. This is the opposite of :%s///g (which clears all
" instances of the current search).
function! searchsavvy#ClearAllButMatches() range
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

" Create a query out of selected lines. You can use ToggleWholeWord to turn
" off whole word.
function! searchsavvy#SearchForAnyLine() range
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

" Searches for selection with some escaping
"
" Add leading \V to prevent magic (ignore embedded *, etc), convert newlines,
" escape backslash, and escape search direction character (/ or ?).
function! searchsavvy#search_for_selection(search_cmd)
    let clobber = @c

    normal! gv"cy
    let query = @c
    let query = escape(query, a:search_cmd . '\')

    " Why doesn't this work? It just replaces it with a literal newline
    "let query = substitute(query, "\n", "\\n", "g")
    " Instead, let's do it the dumb way.
    let query = join(split(query, "\n", 1), "\\n")

    let @/ = '\V'. query

    let @c = clobber
endf

