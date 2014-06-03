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
    " Add leading \V to prevent magic and escape \ and either / or ?
    xnoremap g* y/\V<C-R>=escape(@", '/\')<CR><CR>
    xnoremap g# y?\V<C-R>=escape(@", '?\')<CR><CR>
endif

if !exists("g:searchsavvy_no_ampersand_mappings") || !g:searchsavvy_no_ampersand_mappings
    " Use && like :&&, but on visual selections.
    xnoremap && :&&<CR>
    " Let g& work how I'd expect on visual selections (only act on the visual
    " selection). Different from && because it uses the current search query.
    xnoremap g& :s//~/&<CR>
    if !exists("g:searchsavvy_no_ampersand_builtin_changes")
        " I always want to re-use flags. If I change my mind, I can use :&
        nnoremap & :&&<CR>
    endif
endif

" Quickly toggle between whole word and not whole word search.
nnoremap <Plug>(searchsavvy-toggle-whole-word) :call searchsavvy#ToggleWholeWord()<CR>n
" Search within visual block.
nnoremap <Plug>(searchsavvy-visual-block-search) <Esc>/\%V
" Start a grep for current query.
nnoremap <Plug>(searchsavvy-grep-current) :grep -e "<C-r>=searchsavvy#GrepCurrentQuery()<CR>" *

if !exists("g:searchsavvy_no_leader_mappings") || !g:searchsavvy_no_leader_mappings
    nmap <Leader>/ <Plug>(searchsavvy-toggle-whole-word)
    xmap <Leader>/ <Plug>(searchsavvy-visual-block-search)
    nmap <Leader>* <Plug>(searchsavvy-grep-current)
endif

command! -range=% ClearAllButMatches <line1>,<line2>call searchsavvy#ClearAllButMatches()
command! -range=% SearchForAnyLine <line1>,<line2>call searchsavvy#SearchForAnyLine()

" vi: et sw=4 ts=4 fdm=marker fmr={{{,}}}
