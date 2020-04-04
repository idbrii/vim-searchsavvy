
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

function! searchsavvy#GetGrepCommand(query)
    if &grepprg =~# '\v<(rg|ack|ag)(\.exe)?>'
        " ripgrep and friends don't accept -E (extended regex) and -e (search
        " expression). ripgrep doesn't expand *, but it's also recursive by
        " default, so pass cwd for clarity instead. Would expand cwd, but then
        " it becomes too much noise.
        return printf('silent grep "%s" .', a:query)
    endif
    return 'silent grep -Ee "'. a:query .'" *'
endf

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
    " Slurp up all lines.
    let search_lines = []
    exec a:firstline .','. a:lastline ."call add(search_lines, getline('.'))"

    " Uniquify (so we don't have the same search query multiple times).
    let search_keys = {}
    for line in search_lines
        " Exclude blank lines.
        if len(line) > 0
            " Escape \ to ensure they're parsed correctly.
            let search_keys[line] = escape(line, '\')
        endif
    endfor

    " Join them with OR.
    let query = join(values(search_keys), '\|')

    " Use very no magic to match the exact text.
    let @/ = '\<\V\('. query .'\)\>'
    " Find next match.
    normal! n
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

function! searchsavvy#ListGrep(list, query)
	" Using lazyredraw helps speed up drawing, especially since we go through
	" all of the buffers
	let save_lazyredraw = &lazyredraw
	set lazyredraw

	" We want to end back at the same point that we started from, so save that
	" buffer.
	let save_bufnr = bufnr('%')

	" Clear the quickfix -- we're adding to it so we want it to start empty
	call setqflist([])

	" For each buffer/arg, if it has a name, then grep for the query in it. We use
	" g to get all matches and j to not jump anywhere -- we'll be on our way
	" to the next buffer anyway.
	exec 'noautocmd '. a:list .'do if !bufname("%") | silent! vimgrepadd/' . a:query . '/gj % | endif'

    " See if our start point still exists.
    if bufexists(save_bufnr)
        " Go back to start point.
        exec save_bufnr . 'buffer'
    else
        " Assume buffer was the (often invalidated) quickfix and open that.
        copen
    endif

	let &lazyredraw = save_lazyredraw
endfunction

