" =============================================================================
" File:          autoload/ctrlp/haxelibs.vim
" Description:   Haxe libs extension for ctrlp.vim
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['haxelibs']
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'haxelibs',
"         \ 'my_other_extension',
"         \ ]
"

" Load guard
if ( exists('g:loaded_ctrlp_haxelibs') && g:loaded_ctrlp_haxelibs )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_haxelibs = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#haxelibs#init()',
	\ 'accept': 'ctrlp#haxelibs#accept',
	\ 'lname': 'see haxelibs for file',
	\ 'sname': 'haxelibs',
	\ 'type': 'path',
	\ 'opts': 'ctrlp#haxelibs#opts()',
	\ 'sort': 1,
	\ 'specinput': 0,
	\ })


" Provide a list of strings to search in
"
" Return: a Vim's List
"
let s:current_path = expand('<sfile>:p:h')
function! ctrlp#haxelibs#init()
	let neko_location = s:current_path . "/../../haxe/bin/get_libs.n"
	echo neko_location
	let paths = split(system('neko ' . '"' . neko_location . '"' . ' "' . g:vaxe_hxml . '"'), "\n")
	return paths
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#haxelibs#accept(mode, str)
	call ctrlp#exit()
	call ctrlp#init(0, { 'dir': a:str })
endfunction


" (optional) Do something before enterting ctrlp
function! ctrlp#haxelibs#enter()
endfunction


" (optional) Do something after exiting ctrlp
function! ctrlp#haxelibs#exit()
endfunction


" (optional) Set or check for user options specific to this extension
function! ctrlp#haxelibs#opts()
endfunction


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#haxelibs#id()
	return s:id
endfunction


" Create a command to directly call the new search type
"
" Put this in vimrc or plugin/haxelibs.vim
" command! CtrlPHaxelibs call ctrlp#init(ctrlp#haxelibs#id())


" vim:nofen:fdl=0:ts=2:sw=2:sts=2
