let mapleader = "\\"
set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
" Plugin 'scrooloose/syntastic'
Plugin 'dense-analysis/ale'
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'flazz/vim-colorschemes'
Plugin 'srcery-colors/srcery-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
" ^ just one nerdtree irrespective of tabs
Plugin 'psf/black'
Plugin 'preservim/nerdcommenter'
Plugin 'codota/tabnine-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'xuhdev/vim-latex-live-preview'
Plugin 'prettier/vim-prettier'
Plugin 'tpope/vim-surround'
Plugin 'tweekmonster/django-plus.vim'
Plugin 'sukima/xmledit'
Plugin 'glench/vim-jinja2-syntax'

"Google CodeFMT
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plugin 'google/vim-glaive'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" UNCOMMENT THE REST OF THIS BLOCK ONLY AFTER INSTALLING ALL PLUGINS 
" All of your Plugins must be added before the following line
call vundle#end()            " required for Vundle
filetype plugin indent on    " required for SimpliFold
call glaive#Install()
" Optional Enable codefmt's default mappings on the <Leader>= prefix.
" Glaive codefmt plugin[mappings]
" Glaive codefmt google_java_executable="java -jar /path/to/google-java-format-VERSION-all-deps.jar"

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Fix characters not displaying properly
let &t_TI = ""
let &t_TE = ""

" Make code pretty
let python_highlight_all=1
syntax on

let g:SimpylFold_docstring_preview=1
let g:black_linelength=100

let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
set t_Co=256
set encoding=utf-8
set relativenumber
set number
set showcmd
set mouse=a
set clipboard=unnamedplus
set hlsearch
set textwidth=100
set fo=cq  " dont autowrap text by default (add 't' flag to autowrap)
set wrapmargin=0  " dont wrap based on terminal size
set tabstop=4
set shiftwidth=0
set noexpandtab
imap <Caps> <Esc>
map <leader>o :setlocal spell! spelllang=en_us<CR>
let g:prettier#config#use_tabs = 'true'

"Python formatting shortcut
nnoremap  :Black<CR>

set splitbelow
set splitright

"split navigations
map <c-h> :lclose<CR><c-w>h
map <c-j> :lclose<CR><c-w>j
map <c-k> :lclose<CR><c-w>k
map <c-l> :lclose<CR><c-w>l
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

"ctrl backspace to delete whole words
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

"comment and uncomment code
nmap <C-c> <Plug>NERDCommenterToggle
xmap <C-c> <Plug>NERDCommenterToggle

" Create default mappings
" let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
" let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
" let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
" let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1

" Start NERDTree and leave the cursor in it.
" autocmd VimEnter * NERDTree

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" NERDTree remaps 
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

let NERDTreeShowHidden=1

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za


"Proper indentation for Python and JavaScript
au BufNewFile, BufRead *.py, *.js, *.c, *.cpp, *.h, *.json, *.java, *.bash, *.sh, *.zsh
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set autoindent |
    \ set fileformat=unix |
	\ let g:prettier#config#tab_width=4

"Proper indentation for WebDev languages
au BufNewFile, BufRead *.html, *.css, *.sass, *.scss
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set autoindent |
    \ set fileformat=unix |
	\ let g:prettier#config#tab_width=2

"flag extraneous white space
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Autocomplete stuff
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

"Color scheme picking logic
set termguicolors
if has('gui_gtk3')
  colorscheme srcery
else
  set background=dark
  colorscheme solarized
  "colorscheme zenburn
endif

call togglebg#map("<F5>")

highlight Pmenu ctermbg=Black guibg=Black

"VeryMagic
let g:VeryMagic = 1 " (default is 1) 
let g:VeryMagicSubstitute = 1  " (default is 0)
let g:VeryMagicGlobal = 1  " (default is 0)
let g:VeryMagicVimGrep = 1  " (default is 0)
let g:VeryMagicSearchArg = 1  " (default is 0, :edit +/{pattern}))
let g:VeryMagicFunction = 1  " (default is 0, :fun /{pattern})
let g:VeryMagicHelpgrep = 1  " (default is 0)
let g:VeryMagicRange = 1  " (default is 0, search patterns in command ranges)
let g:VeryMagicEscapeBackslashesInSearchArg = 1  " (default is 0, :edit +/{pattern}))
let g:SortEditArgs = 1  " (default is 0, see below)

" Codefmt
Glaive codefmt clang_format_style="file"
Glaive codefmt js_beautify_executable="js-beautify"
function! Format()
    execute "FormatCode"
    echoh "Formatted Code."
endfunction
autocmd FileType 
    \bzl,c,cpp,proto,arduino,dart,go,gn,html,,css,sass,scss,less,json,java,python,rust,vue nnoremap 
    \<buffer> <C-f> :call Format()<CR>
" Modification for html-django
function! DjangoFormat()
    let l:scrollHeight = winsaveview()
    execute "Prettier"
    silent! %s/\v\{\%/\{\% /ge
    silent! %s/\v\{\%\s+/\{\% /ge
    silent! %s/\v\%\}/ \%\}/ge
    silent! %s/\v\s+\%\}/ \%\}/ge
    silent! %s/\v\{\% extends/\{\% extends /ge
    silent! %s/\v\{\% extends\s+/\{\% extends /ge
    silent! %s/\v\{\% include/\{\% include /ge
    silent! %s/\v\{\% include\s+/\{\% include /ge
    silent! %s/\v\{\% load/\{\% load /ge
    silent! %s/\v\{\% load\s+/\{\% load /ge
    silent! %s/\v\{\% static/\{\% static /ge
    silent! %s/\v\{\% static\s+/\{\% static /ge
    silent! %s/\v\{\% comment/\{\% comment /ge
    silent! %s/\v\{\% comment\s+/\{\% comment /ge
    silent! %s/\v\{\% url/\{\% url /ge
    silent! %s/\v\{\% url\s+/\{\% url /ge
    silent! %s/\v\{\% cycle/\{\% cycle /ge
    silent! %s/\v\{\% cycle\s+/\{\% cycle /ge
    silent! %s/\v\{\% filter/\{\% filter /ge
    silent! %s/\v\{\% filter\s+/\{\% filter /ge
    silent! %s/\v\{\% firstof/\{\% firstof /ge
    silent! %s/\v\{\% firstof\s+/\{\% firstof /ge
    silent! %s/\v\{\% lorem/\{\% lorem /ge
    silent! %s/\v\{\% lorem\s+/\{\% lorem /ge
    silent! %s/\v\{\% now/\{\% now /ge
    silent! %s/\v\{\% now\s+/\{\% now /ge
    silent! %s/\v\{\% regroup/\{\% regroup /ge
    silent! %s/\v\{\% regroup\s+/\{\% regroup /ge
    silent! %s/\v\{\{/\{\{ /ge
    silent! %s/\v\{\{\s+/\{\{ /ge
    silent! %s/\v\}\}/ \}\}/ge
    silent! %s/\v\s+\}\}/ \}\}/ge
    execute "noh"
    call winrestview(l:scrollHeight)
    echom "Django HTML Code Formatted."
endfunction
autocmd FileType htmldjango,javascript,jinja.html nnoremap <buffer> <C-f> :call DjangoFormat()<CR>
" autocmd FileType htmldjango nnoremap <buffer> <C-f>gg=G<C-o>
"
" CodeFMT
" augroup autoformat_settings
"   autocmd FileType bzl AutoFormatBuffer buildifier
"   autocmd FileType c,cpp,proto,arduino AutoFormatBuffer clang-format
"   autocmd FileType javascript AutoFormatBuffer clang-format
"   autocmd FileType dart AutoFormatBuffer dartfmt
"   autocmd FileType go AutoFormatBuffer gofmt
"   autocmd FileType gn AutoFormatBuffer gn
"   autocmd FileType html,htmldjango,jinja.html,css,sass,scss,less,json AutoFormatBuffer js-beautify
"   autocmd FileType java AutoFormatBuffer google-java-format
"   autocmd FileType python AutoFormatBuffer yapf
"   " Alternative: autocmd FileType python AutoFormatBuffer autopep8
"   autocmd FileType rust AutoFormatBuffer rustfmt
"   autocmd FileType vue AutoFormatBuffer prettier
" augroup END

" Syntastic
let g:ycm_show_diagnostics_ui = 0
let g:syntastic_cpp_checkers = ['gcc']

function JustCloseSyntasticWindow()
    "Check which buffer we are in, and if not, return to the main one:
    if &ft == "qf"
        normal ZZ
    endif
    "Since different buffers have different command spaces, check if we've
    "escaped the other buffer and then tell syntastic to stop.
    if &ft != "qf"
       SyntasticReset
       " --- or ----
       SyntasticToggleMode
    endif
endfunction

au FileType buffer1_ft nnoremap :<><CR>:call JustCloseSyntasticWindow()<cr>
au FileType main_win_ft nnoremap :<><CR>:call JustCloseSyntasticWindow()<cr>

let g:syntastic_python_python_exec = 'python3'
let g:syntastic_python_checkers = ['python']

" LaTeX Specific
let g:tex_flavor = "latex"
au FileType tex set tw=100

" Airline
" let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
" let g:Powerline_symbols='unicode'
let g:airline_theme = 'powerlineish'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_inactive_collapse=1
let g:airline_disable_statusline = 0
let g:airline_detect_spelllang=1
let g:airline_detect_spell=1
