if exists('loaded_searchsavvy') || &cp || version < 700
    finish
endif
let loaded_searchsavvy = 1

if !exists("g:searchsavvy_no_defaults") || !g:searchsavvy_no_defaults
    set ignorecase					" search is case insensitive
    set smartcase					" search case sensitive if caps on
    set hlsearch					" Highlight matches to the search
    set incsearch					" Find as you type
endif

if !exists("g:searchsavvy_no_g_mappings") || !g:searchsavvy_no_g_mappings
    " * and # search for next/previous of selected text when used in visual mode.
    xnoremap g* :<C-u>call searchsavvy#search_for_selection('/')<CR>n
    xnoremap g# :<C-u>call searchsavvy#search_for_selection('?')<Bar>let v:searchforward = 0<CR>n
endif

if !exists("g:searchsavvy_no_ampersand_mappings") || !g:searchsavvy_no_ampersand_mappings
    " Use && like :&&, but on visual selections.
    xnoremap && :&&<CR>
    " Let g& work how I'd expect on visual selections (only act on the visual
    " selection). Different from && because this uses the current search query.
    xnoremap g& :s//~/&<CR>
    if !exists("g:searchsavvy_no_ampersand_builtin_changes")
        " I always want to re-use flags. If I change my mind, I can use :&
        nnoremap & :&&<CR>
    endif
endif

" Quickly toggle between whole word and not whole word search.
nnoremap <Plug>(searchsavvy-toggle-whole-word) :call searchsavvy#ToggleWholeWord()<CR>n
" Search within visual block.
xnoremap <Plug>(searchsavvy-visual-block-search) <Esc>/\%V
nnoremap <Plug>(searchsavvy-visual-block-search) <Esc>/\%V
" Start a grep for current query.
nnoremap <Plug>(searchsavvy-grep-current) :<C-r>=searchsavvy#GetGrepCommand(searchsavvy#GrepCurrentQuery())<CR>

" Make */# case sensitive even when using 'ignorecase' or 'smartcase'.
let g:searchsavvy_always_case_sensitive_star = get(g:, "searchsavvy_always_case_sensitive_star", 0)

if g:searchsavvy_always_case_sensitive_star || (&smartcase && !get(g:, "searchsavvy_no_smartcase_star", 0))
    " If searchsavvy_always_case_sensitive_star is set, always match case.
    " Otherwise, make * and friends follow smartcase's case rules.
    nnoremap <expr>  * searchsavvy#SearchCword(1, "n", g:searchsavvy_always_case_sensitive_star)
    nnoremap <expr>  # searchsavvy#SearchCword(1, "N", g:searchsavvy_always_case_sensitive_star)
    nnoremap <expr> g* searchsavvy#SearchCword(0, "n", g:searchsavvy_always_case_sensitive_star)
    nnoremap <expr> g# searchsavvy#SearchCword(0, "N", g:searchsavvy_always_case_sensitive_star)
endif

if !exists("g:searchsavvy_no_leader_mappings") || !g:searchsavvy_no_leader_mappings
    nmap <Leader>/ <Plug>(searchsavvy-toggle-whole-word)
    " Don't expose nmap for block because it's just kept for legacy reasons.
    xmap <Leader>/ <Plug>(searchsavvy-visual-block-search)
    nmap <Leader>* <Plug>(searchsavvy-grep-current)
endif

command! -range=% -bar ClearAllButMatches <line1>,<line2>call searchsavvy#ClearAllButMatches()
command! -range=% -bar SearchForAnyLine <line1>,<line2>call searchsavvy#SearchForAnyLine()

command! -nargs=+ -bar BufGrep call searchsavvy#ListGrep('buf', <q-args>)
command! -nargs=+ -bar ArgGrep call searchsavvy#ListGrep('arg', <q-args>)

if !exists("g:searchsavvy_no_startsearch") || !g:searchsavvy_no_startsearch
    " Be sure to use 'single quotes' to reduce regex escaping.
    " Search for a non zero integer. Count is maximum digits.
    command! -bar -count=2 StartSearchIntegerNonZero exec searchsavvy#StoreAndStartSearch('\v[^.]\zs<[1-9]\d{0,<count>}>')
    " Search for a float. Count is minimum digits before and after decimal.
    command! -bar -count=2 StartSearchFloat          exec searchsavvy#StoreAndStartSearch('\v\zs<\d{1,<count>}\.\d{1,<count>}>')
endif

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
