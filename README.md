vim-searchsavvy
===============

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


Extend/improve mappings to do what you expect
=============================================
Searching
* Visual `g*` and `g#` to search for selected text. (Similar to
  [vim-visual-star-search](https://github.com/nelstrom/vim-visual-star-search)
  but allows you to use `*` in visual mode as normal. Disable with
  `g:searchsavvy_no_g_mappings`.)

* Search within a visual block with `<Leader>/` or customize with
  `<Plug>(searchsavvy-visual-block-search)`.

* Grep for current search query with `<Leader>*` or customize with
  `<Plug>(searchsavvy-grep-current)`.

Substituting
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
