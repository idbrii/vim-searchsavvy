vim-searchsavvy
===============

No longer uses GREP_OPTIONS to support grep 2.20!

Smarter/faster grep options
===============================
"Smart grep" will ignore irrelevant files to make your search faster, but uses
your system's grep. If you don't have grep installed, it will use vim's
internal grep.

Smart mode is enabled by default. To prevent auto-enabling, use:

    let g:searchsavvy_smartgrep_auto_enable = 0

Use the `SmartGrepToggle` command to toggle between smart grep and normal grep.


Search tools to help you find
=============================
ToggleWholeWord mapping
* Quickly switch between whole-word matching without re-entering your query
  (ever use `*` when you meant to do `g*`?). Default maps to `<Leader>/` or
  customize with `<Plug>(searchsavvy-toggle-whole-word)`.

ClearAllButMatches command
* Remove all content but what matches your current query. Works with the whole
  file or the current visual selection. It's the opposite of `%s///g`.

SearchForAnyLine command
* Select text and use this command to create a search query for any of the
  selected lines. Works well with ToggleWholeWord.

BufGrep and ArgGrep commands
* Search through all open buffers or all files in the arglist and see the
  results in your quickfix -- just like :grep.

StoreAndStartSearch() function
* Save complex searches to your vimrc as commands that populate your history.

Extend/improve mappings to do what you expect
=============================================
### Searching
* Visual `g*` and `g#` to search for selected text. (Similar to
  [vim-visual-star-search](https://github.com/nelstrom/vim-visual-star-search)
  but allows you to use `*` in visual mode as normal. Disable with
  `g:searchsavvy_no_g_mappings`.)

* When using 'smartcase', `\*`/`#`/`g\*`/`g#` follow smartcase's
  case-sensitivity rules. Use `let g:searchsavvy_no_smartcase_star = 1` to
  disable.

* Use `let g:searchsavvy_always_case_sensitive_star = 1` to make
  `\*`/`#`/`g\*`/`g#` always case-sensitive, regardless of 'ignorecase' and
  'smartcase' settings.

* Search within a visual block with `<Leader>/` or customize with
  `<Plug>(searchsavvy-visual-block-search)`.

* Grep for current search query with `<Leader>*` or customize with
  `<Plug>(searchsavvy-grep-current)`.

### Substituting
* Visual `&&` to do `:&&` on selected text (repeat last substitute with the same flags).

* Make `g&` work how you'd expect on visual selections: only act on the visual
selection. Unlike `&&`, it uses the current search query.

* Change `&` to re-use flags. If you want otherwise, use `:&` or set `let
g:searchsavvy_no_ampersand_builtin_changes = 1`


Better defaults
===============

Enables intelligent case-insensitive, incremental, highlighted searching. So
you can see matches for as you search, see all matches after searching, and
don't need proper casing -- but if you use uppercase it knows to be
case-sensitive.

If you prefer to define your own defaults use your after/plugin directory or
set:

	let g:searchsavvy_no_defaults = 1


Disable at will
===============

Additional options to disable parts of searchsavvy:
* g:searchsavvy_no_leader_mappings
* g:searchsavvy_no_ampersand_mappings
* g:searchsavvy_no_startsearch


External grep script
====================

You can use the bin/smartgrep script from the shell:

	alias gs='~/.vim/bundle/searchsavvy/bin/smartgrep'

Thanks
======

* Peter Rincker for [helping implement ClearAllButMatches](http://stackoverflow.com/a/4521486/79125).
* scrooloose for [inspiring multiple visual star search plugins](http://got-ravings.blogspot.ca/2008/07/vim-pr0n-visual-search-mappings.html).
* Arabesque for [introducing me to GREP_OPTIONS](http://blog.sanctum.geek.nz/default-grep-options/),
  the many [threads](http://archive.today/fg7me) detailing the problems with GREP_OPTIONS,
  and Andy Lester for [ack](http://beyondgrep.com/)
  -- all helped me develop "smart grep".

