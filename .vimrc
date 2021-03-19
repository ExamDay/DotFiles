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
Plugin 'nvie/vim-flake8'
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'flazz/vim-colorschemes'
Plugin 'srcery-colors/srcery-vim'
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'psf/black'
Plugin 'preservim/nerdcommenter'
Plugin 'zxqfl/tabnine-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'xuhdev/vim-latex-live-preview'

"Google CodeFMT
" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plugin 'google/vim-maktaba'
Plugin 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plugin 'google/vim-glaive'


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
set tabstop=4
set shiftwidth=4
autocmd Filetype html setlocal tabstop=2
autocmd Filetype html setlocal shiftwidth=2
set expandtab
imap <Caps> <Esc>
map <leader>o :setlocal spell! spelllang=en_us<CR>

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

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar
nnoremap <space> za

"Proper indentation for Python
au BufNewFile, BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=100 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

"Proper indentation for WebDev languages
au BufNewFile, BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

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
" Glaive codefmt clang_format_style="{BasedOnStyle: llvm, IndentWidth: 4}"
nnoremap <C-f> :FormatCode<CR>

" Syntastic
let g:ycm_show_diagnostics_ui = 0
let g:syntastic_cpp_checkers = ['gcc']

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
