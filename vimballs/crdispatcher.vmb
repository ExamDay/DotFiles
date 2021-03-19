" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
plugin/crdispatcher.vim	[[[1
17
" Author: Marcin Szamotulski
" Email:  mszamot [AT] gmail [DOT] com
" License: vim-license, see :help license

let g:CRDispatcher = crdispatcher#CRDispatcher
fun! CRDispatch()
    return g:CRDispatcher.dispatch()
endfun
cno <C-M> <CR>
" When g: scope is missing, 'debug-mode' complains that the variable does not
" exists.
cno <Plug>CRDispatch <C-\>eg:CRDispatcher.dispatch()<CR><CR>
" Mod out 'debug-mode' to prevent recursive loop when deugging the plugin
" itself.
cm <expr> <CR> index(['>', ''], getcmdtype()) != -1 ? '<CR>' :  '<Plug>CRDispatch'
" Clever <c-f> fix:
cno <c-f> <C-\>eCRDispatcher.dispatch(1)<CR><c-f>
autoload/crdispatcher.vim	[[[1
109
" Author: Marcin Szamotulski
" Email:  mszamot [AT] gmail [DOT] com
" License: vim-license, see :help license

let crdispatcher#CRDispatcher = {
	    \ 'callbacks': [],
	    \ 'state': 0
	    \ }
" each call callback is called with part of the command line. Command line is
" split by "|".  Each callback has access to crdispatcher#CRDispatcher and can
" change its state: 0 (pattern has not matched, in this case next cmdline
" fragrment will be appended and the callback will be retried), 1 (go to next
" fragment), 2 (go to next callback).
fun! crdispatcher#CRDispatcher.dispatch(...) dict "{{{
    if a:0 >= 1
	let self.ctrl_f = a:1
    else
	let self.ctrl_f = 0
    endif
    if a:0 >= 2
	let self.cmdline_orig = a:2
    else
	let self.cmdline_orig = getcmdline()
    endif
    if a:0 >= 3
	let self.cmdtype = a:3
    else
	let self.cmdtype = getcmdtype()
    endif
    let self.line = self.cmdline_orig
    let self.cmds = vimlparsers#ParseCommandLine(self.cmdline_orig, self.cmdtype)
    let cidx = 0
    let clen = len(self.callbacks)
    while cidx < clen
	let F = self.callbacks[cidx]
	let cidx += 1
	let self.idx = -1
	while self.idx < len(self.cmds) - 1
	    let self.state = 0
	    let self.idx += 1
	    let idx = self.idx
	    let self.cmd = self.cmds[idx]
	    " every callback has accass to whole self and can change
	    " self.cmdline (and self.range) and should set self.state
	    if type(F) == 4
		call F.__transform_cmd__(self)
	    elseif type(F) == 2
		call F(self)
	    endif
	    if self.state == 2
		" slicing in VimL does not raise exceptions [][100:] is []
		break
	    elseif self.state == 3
		break
	    endif
	endwhile
	unlet F
    endwhile
    let cmdline = ''
    let clen = len(self.cmds)
    for idx in range(clen)
	let cmd = self.cmds[idx]
	let cmdl = cmd.Join()
	let cmdline .= cmdl
	if !cmd.global && idx != clen - 1
	    let cmdline .= '|'
	endif
    endfor
    return cmdline
endfun "}}}

let crdispatcher#CallbackClass = {}
fun! crdispatcher#CallbackClass.__init__(vname, cmdtype, pattern, ...) dict  "{{{
    let self.variableName = a:vname
    let self.cmdtype = a:cmdtype
    let self.pattern = a:pattern
    if a:0 >= 1
	let self.tr = a:1
    else
	let self.tr = 1
    endif
endfun  "}}}
fun! crdispatcher#CallbackClass.__transform_args__(current_dispatcher, cmd_args) dict  "{{{
    " This callback is used only be g command to transform patterns hidden in
    " commands in its argument part: g/\vpat1/s/pat2/\U&\E/ -> s/\vpat2/...
    return a:cmd_args
endfun  "}}}
fun! crdispatcher#CallbackClass.__transform_cmd__(dispatcher) dict  "{{{
    if !{self.variableName} || a:dispatcher.cmdtype !=# self.cmdtype
	let a:dispatcher.state = 1
	return
    endif
    let matched = a:dispatcher.cmd.cmd =~# self.pattern
    if matched
	let a:dispatcher.state = 1
	let cmd = a:dispatcher.cmd
	let cmd.args = self.__transform_args__(a:dispatcher, cmd.args)
	let pat = cmd.pattern
	let pat_len = len(pat[1:]) - 1
	if pat[0] ==# pat[-1]
	    let pat_len -= 1
	endif
	if pat !~# g:DetectVeryMagicPattern && pat_len
	    let cmd.pattern = pat[0].'\v'.pat[1:]
	endif
	let a:dispatcher.cmd = cmd
	let a:dispatcher.cmdline = cmd.Join()
    endif
endfun  "}}}
autoload/vimlparsers.vim	[[[1
387
" Author: Marcin Szamotulski
" Email:  mszamot [AT] gmail [DOT] com
" License: vim-license, see :help license

" let vimlparsers#splitargs_pat = '\v%(%(\\@1<!%(\\\\)*)@>)@<=\|'
let s:range_modifier = '(\s*[+-]+\s*\d*)?'
fun! vimlparsers#ParseRange(cmdline) " {{{
    let range = ""
    let cmdline = a:cmdline
    while len(cmdline)
	let cl = cmdline
	if cmdline =~ '^\s*%'
	    let range = matchstr(cmdline, '^\s*%\s*')
	    return [range, cmdline[len(range):], 0]
	elseif &cpoptions !~ '\*' && cmdline =~ '^\s*\*'
	    let range = matchstr(cmdline, '^\s*\*\s*')
	    return [range, cmdline[len(range):], 0]
	elseif cmdline =~ '^\s*\d'
	    let add = matchstr(cmdline, '\v^\s*\d+'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 1
	    " echom range
	elseif cmdline =~ '^\s*[-+]'
	    let add = matchstr(cmdline, '\v^\s*'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 2
	elseif cmdline =~ '^\.\s*'
	    let add = matchstr(cmdline, '\v^\s*\.'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 3
	    " echom range
	elseif cmdline =~ '^\s*\\[&/?]'
	    let add = matchstr(cmdline, '^\v\s*\\[/&?]'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 4
	    " echom range
	elseif cmdline =~ '^\s*[?/]'
	    let add = matchstr(cmdline, '^\v\s*[?/]@=')
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    let [char, pattern] = vimlparsers#ParsePattern(cmdline)
	    " echom cmdline.":".add.":".char.":".pattern
	    let range .= char . pattern . char
	    let cmdline = cmdline[len(pattern)+2:]
	    let add = matchstr(cmdline, '^\v'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 5
	    " echom range . "<F>".cmdline."<"
	elseif cmdline =~ '^\s*\$'
	    let add = matchstr(cmdline, '\v^\s*\$'.s:range_modifier)
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 6
	    " echom range
	elseif cmdline =~ '^\v[[:space:];,]+'  " yes you can do :1,^t;;; ,10# and it will work like :1,10#
	    let add = matchstr(cmdline,  '^\v[[:space:];,]+')
	    let range .= add
	    let cmdline = cmdline[len(add):]
	    " echom 7
	elseif cmdline =~ '^\v\s*[''`][a-zA-Z<>`'']'
	    let add = matchstr(cmdline, '^\v\s*[''`][a-zA-Z<>`'']') 
	    let range .= add
	    let cmdline = cmdline[len(add):]
	elseif cmdline =~ '^\s*\w'
	    return [range, cmdline, 0]
	endif
	if cl == cmdline
	    " Parser didn't make a step (so it falls into a loop)
	    " for example when there is no range, or for # command
	    return [range, cmdline, 1]
	endif
    endwhile
    return [range, cmdline, 0]
endfun " }}}

fun! vimlparsers#ParsePattern(line, ...) " {{{
    " Parse /pattern/ -> return ['/', 'pattern']
    " this is useful for g/pattern/ type command
    if a:0 >= 1
	let escape_char = a:1
    else
	let escape_char = '\'
    endif
    let char = a:line[0]
    let line = a:line[1:]
    let pattern = ''
    let escapes = 0
    for nchar in split(line, '\zs')
	if nchar == escape_char
	    let escapes += 1
	endif
	if nchar !=# char || (escapes % 2)
	    let pattern .= nchar
	else
	    break
	endif
	if nchar != escape_char
	    let escapes = 0
	endif
    endfor
    return [char, pattern]
endfun " }}}

fun! vimlparsers#ParseString(str)  "{{{
    let i = 0
    while i < len(a:str)
	let i += 1
	let c = a:str[i]
	if c != "'"
	    cont
	else
	    if a:str[i+1] == "'"
		let i += 1
		con
	    else
		break
	    endif
	endif
    endwhile
    return a:str[:i]
endfun  "}}}

let vimlparsers#s_cmd_pat = '^\v\C\s*('.
	    \ 'g%[lobal]\s*|'.
	    \ 'v%[global]\s*|'.
	    \ 'vim%[grep]\s*|'.
	    \ 'lv%[imgrep]\s*'.
	    \ ')($|\W@=)'

" s:CmdLineClass {{{
let s:CmdLineClass = {
	    \ 'decorator': '',
	    \ 'global': 0,
	    \ 'range': '',
	    \ 'cmd': '',
	    \ 'pattern': '',
	    \ 'args': '',
	    \ }
fun! s:CmdLineClass.Repr() dict
    return '<CmdLine: ' .self['decorator'].':'.self['range'].':'.self['cmd'].':'.self['pattern'].':'.self['args'].'>'
endfun
fun! s:CmdLineClass.Join() dict
    return self['decorator'].self['range'].self['cmd'].self['pattern'].self['args']
endfun  "}}}
" TODO :help function /{pattern}
" see :help :\bar (the list below does not include global and vglobal
" commands)
let vimlparsers#bar_cmd_pat = '^\v\C\s*('.
	    \ 'argdo!?|'.
	    \ 'au%[tocmd]|'.
	    \ 'bufdo!?|'.
	    \ 'com%[mand]|'.
	    \ 'cscope|'.
	    \ 'debug|'.
	    \ 'foldopen!?|'.
	    \ 'foldclose!?|'.
	    \ 'function!?|'.
	    \ 'h%[elp]|'.
	    \ 'helpf%[ind]|'.
	    \ 'lcscope|'.
	    \ 'make|'.
	    \ 'norm%[al]|'.
	    \ 'pe%[rl]|'.
	    \ 'perldo?|'.
	    \ 'promptf%[ind]|'.
	    \ 'promptr%[epl]|'.
	    \ 'pyf%[ile]|'.
	    \ 'py%[thon]|'.
	    \ 'reg%[isters]|'.
	    \ 'r%[ead]\s+!|'.
	    \ 'scscope|'.
	    \ 'sign|'.
	    \ 'tcl|'.
	    \ 'tcldo?|'.
	    \ 'tclf%[ile]|'.
	    \ 'windo|'.
	    \ 'w%[rite]\s+!|'.
	    \ 'helpg%[rep]|'.
	    \ 'lh%[elpgrep]|'.
	    \ '%(r%[ead]\s*)?\!.*'.
	\ ')\s*%(\W|$)@='
let vimlparsers#edit_cmd_pat = '^\v\C\s*('.
		\ 'e%[dit]!?|'.
		\ 'view?|'.
		\ 'r%[ead]|'.
		\ 'sp%[lit]!?|'.
		\ 'vs%[plit]!?|'.
		\ 'find?!?|'.
		\ 'sf%[ind]!?|'.
		\ 'sv%[iew]!?|'.
		\ 'new!?|'.
		\ 'vnew?!?|'.
		\ 'vi%[sual]!?'.
	    \ ')%($|\W@=)'

fun! vimlparsers#ParseCommandLine(cmdline, cmdtype)  "{{{
    " returns command line splitted by |
    let cmdlines = []
    let idx = 0
    let cmdl = copy(s:CmdLineClass)
    let global = 0
    let new_cmd = 1  " only after | or g command
    let fun = 0  " expect call <...> or let <...>
    let check_range = 1 " as above but it is reset on the begining, so it cannot be used later
    if a:cmdtype == '/' || a:cmdtype == '?'
	let cmdl.pattern = a:cmdline
	call add(cmdlines, cmdl)
	return cmdlines
    endif
    let cmdline = a:cmdline
    while !empty(cmdline)
	" echo 'cmdline: <'.cmdline.'>'
	if check_range == 1
	    let decorator = matchstr(cmdline, '^\v\C(:|\s)*(sil%[ent]!?\s*|debug\s*|\d*verb%[ose]\s*)*\s*($|\S@=)')
	    let cmdline = cmdline[len(decorator):]
	    let cmdl.decorator = decorator
	    let [range, cmdline, error] = vimlparsers#ParseRange(cmdline)
	    let check_range = 0
	    let cmdl.range = range
	    let idx += len(range) + 1
	    let after_range = 1
	    " echo cmdl.Repr()
	    con
	else
	    let after_range = 0
	endif
	let match = matchstr(cmdline, g:vimlparsers#s_cmd_pat)
	if !empty(match) && !fun 
	    let global = (cmdline =~ '^\v\C\s*%(g%[lobal]|v%[global])\s*%($|\W@=)' ? 1 : 0)
	    let cmdl.global = global
	    let cmdl.cmd .= match
	    let idx += len(match)
	    let cmdline = cmdline[len(match):]
	    let [char, pat] = vimlparsers#ParsePattern(cmdline)
	    let cmdl.pattern .= char.pat
	    let d = len(char.pat)
	    let idx += d
	    let cmdline = cmdline[(d):]
	    if cmdline[0] == char
		let cmdl.pattern .= char
		let idx += 1
		let cmdline = cmdline[1:]
	    endif
	    if global
		call add(cmdlines, cmdl)
		let global = 0
		let cmdl = copy(s:CmdLineClass)
		let check_range = 1
	    endif
	    let idx += 1
	    let new_cmd = (global ? 1 : 0)
	    con
	endif
	let match = matchstr(cmdline, '^\v\C\s*s%[ubstitute]\s*($|\W@=)') 
	if !empty(match) && !fun
	    " echom "cmdline (sub): ".cmdline
	    let new_cmd = 0
	    let cmdl.cmd .= match
	    let d = len(match)
	    let idx += d
	    let cmdline = cmdline[(d):]
	    let [char, pat] = vimlparsers#ParsePattern(cmdline)
	    let cmdl.pattern .= char.pat
	    let d = len(char.pat)
	    let idx += d
	    let cmdline = cmdline[(d):]
	    let [char, pat] = vimlparsers#ParsePattern(cmdline)
	    let cmdl.pattern .= char
	    let cmdl.args .= pat
	    let d = len(char.pat)
	    let idx += d
	    " echom "cmdline (sub): ".cmdline
	    let cmdline = cmdline[(d):]
	    if cmdline[0] == char
		let idx += 1
		let cmdl.args .= char
		let cmdline = cmdline[1:]
		let flags = matchstr(cmdline, '^\C[\&cegiInp\#lr[:space:]]*')
		let cmdl.args .= flags
		let cmdline = cmdline[len(flags):]
	    endif
	    let idx += 1
	endif
	let match = matchstr(cmdline, g:vimlparsers#bar_cmd_pat . '.*')
	if !empty(match) && new_cmd && !fun
	    let cmdl.cmd .= match
	    break
	endif
	let match = matchstr(cmdline, '^\C\v\s*se%[t]([^\|]|%(%(\\\\)*)@>\\\|)*')
	if !empty(match) && new_cmd && !fun
	    let cmdl.cmd .= match
	    let idx += len(match)
	    let cmdline = cmdline[len(match):]
	endif
	let match = matchstr(cmdline, g:vimlparsers#edit_cmd_pat)
	if !empty(match) && new_cmd && !fun
	    let match = matchstr(cmdline, '^\v\w+!?\s+'.
			\ '%('.
			    \ '\+\/%([^[:space:]]|'.
				\ '%(%(%(\\\\)*)@>\\)@10<=\s'.
			    \ ')*|'.
			    \ '%('.
				\ '[^|]|'.
				\ '%(%(%(\\\\)*)@>\\)@10<=\|'.
			    \ ')*'.
			\ ')*')
	    let cmdl.cmd .= match
	    let idx += len(match)
	    let cmdline = cmdline[len(match):]
	endif
	let matches = matchlist(cmdline, '^\v\C(fu%[nction]\s+)(\/.*)')
	if !empty(matches) && new_cmd && !fun
	    let cmdl.cmd .= matches[1]
	    let cmdl.pattern = matches[2]
	    let idx = len(matches[1])
	    let cmdline = ''
	endif
	unlet matches
	let match = matchstr(cmdline, '^\v\C%(call|let|echo)($|\W@=)\s*')
	if !empty(match) && !fun
	    let cmdl.cmd .= match
	    let idx += len(match)
	    let cmdline = cmdline[len(match):]
	    let fun = 1
	endif
	if fun
	    let match = matchstr(cmdline, '^(\w:)?\w\+')
	else
	    let match = matchstr(cmdline, '^\w\+')
	endif
	if !empty(match)
	    if !empty(cmdl.pattern)
		let cmdl.args .= match
	    else
		let cmdl.cmd .= match
	    endif
	    let idx += len(match)
	    let cmdline = cmdline[len(match):]
	endif
	let c = cmdline[0]
	if c ==# '"'
	    let [char, str] = vimlparsers#ParsePattern(cmdline)
	    if !empty(cmdl.pattern)
		let cmdl.args .= char.str.char
	    else
		let cmdl.cmd .= char.str.char
	    endif
	    let d= len(char.str.char)
	    let idx += d + 1
	    let cmdline = cmdline[(d):]
	elseif c ==# "'"
	    let str = vimlparsers#ParseString(cmdline)
	    if !empty(cmdl.pattern)
		let cmdl.args .= str
	    else
		let cmdl.cmd .= str
	    endif
	    let d = len(str)
	    let idx += d + 1
	    let cmdline = cmdline[(d):]
	elseif c ==# "|"
	    call add(cmdlines, cmdl)
	    let cmdline = cmdline[1:]
	    let cmdl = copy(s:CmdLineClass)
	    let idx += 1
	    let check_range = 1
	    let new_cmd = 1
	    con
	else
	    if !empty(cmdl.pattern)
		let cmdl.args .= c
	    else
		let cmdl.cmd .= c
	    endif
	    let idx += 1
	    let cmdline = cmdline[1:]
	endif
	let new_cmd = 0
    endwhile
    call add(cmdlines, cmdl) 
    return cmdlines
endfun  "}}}
