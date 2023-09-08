" Disable compatibility with vi, which can cause some unexpected issues
set nocompatible

" Set title of terminal to document name
set title
set titlestring=%t\ -\ vim

" Disable showing mode in command bar (for use with airline statusline)
set noshowmode

" Disable showing file information in command bar (for use with airline
" statusline)
set shortmess+=F

" Enable filetype detection
filetype on

" Enable filetype/syntax highlighting for assembly
au BufRead,BufNewFile *.asm setfiletype asm

" Enable plugins and load plugins for the detected filetype
filetype plugin on

" Load indent files for detected filetypes
filetype indent on

" Use syntax highlighting
syntax on

" Display hybrid line numbers on the left hand side
set number relativenumber

" Highlight line that the cursor is on
set cursorline

" Map leader to tab
let mapleader = "\<tab>" 

" Show leader key when pressed
set showcmd

" Set tabstop to 4 spaces
set softtabstop=4

" Use spaces instead of tabs
set expandtab

" Use highlighting when doing a search
set hlsearch

" Map leader-h to turn off search highlighting
map <leader>h :noh<CR>

" Use incremental search
set incsearch

" Save more commands in history (default is 20)
set history=1000

" Enable switching buffers without saving
set hidden

" Set text width
set wrap linebreak

" Map j/k to navigate soft lines rather than physical lines
" Allows to navigate within wrapped lines
" nnoremap <expr> j v:count ? 'j' : 'gj'
" nnoremap <expr> k v:count ? 'k' : 'gk'
" https://vi.stackexchange.com/questions/88/how-do-i-deal-with-very-long-lines-in-text-500-characters
vmap <C-j> gj
vmap <C-k> gk
vmap <C-4> g$
vmap <C-6> g^
vmap <C-0> g^
nmap <C-j> gj
nmap <C-k> gk
nmap <C-4> g$
nmap <C-6> g^
nmap <C-0> g^

" Map alias for next/prev buffer
map <leader>k :bnext<CR>
map <leader>j :bprevious<CR>

" Map alias for NERDTreeToggle
nmap <silent> <C-t> :NERDTreeToggle<CR>

" Enable auto-indent
set autoindent
set smartindent
set breakindent

" Enable backspace through the following elements
set backspace=indent,eol,start

set scrolloff=1

" Set indent to 4 spaces
set shiftwidth=4

" When shifting lines, round indentation to nearest multiple of shiftwidth
set shiftround

" Turn off system bell
set visualbell
set t_vb=

" MARKDOWN --------------------------------------------- {{{

" Enable vim-surround bolding via e.g. 'ysiwb'
autocmd FileType markdown let b:surround_{char2nr('b')} = "**\r**"
" let b:surround_{char2nr('b')} = "**\r**"

" Add code block syntax highlighting
let g:markdown_fenced_languages = ['java', 'c', 'python', 'html', 'latex', 'tex']
let g:vim_markdown_fenced_languages = ['java', 'c', 'python', 'html', 'latex', 'tex']
let g:markdown_minlines = 100

" Fix for autoindent issue after end of list
" https://stackoverflow.com/questions/46876387/vim-with-markdown-how-to-remove-blankspace-after-bullet-point
" https://www.reddit.com/r/vim/comments/78gvle/vim_with_markdown_how_to_remove_blankspace_after/
let g:vim_markdown_new_list_item_indent = 0

" Disable markdown folding in vim-markdown
" let g:vim_markdown_folding_disabled = 1

" Conceal formatting
set conceallevel=2

" }}}

" LATEX ------------------------------------------------ {{{

" Configure viewer for vimtex
let g:vimtex_view_method = 'skim'

" Setup vim-surround for use with vimtex
augroup latexSurround
autocmd!
autocmd FileType tex call s:latexSurround()
augroup END

function! s:latexSurround()
let b:surround_{char2nr("e")}
\ = "\\begin{\1environment: \1}\n\t\r\n\\end{\1\1}"
let b:surround_{char2nr("c")} = "\\\1command: \1{\r}"
endfunction

" }}}

" PLUGINS ---------------------------------------------- {{{
call plug#begin()

" Vim airline statusline
Plug 'vim-airline/vim-airline'
"
" Disable airline word count
let g:airline#extensions#wordcount#enabled = 0

" Enable airline buffer list and show only filename
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" Change line and col symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ' line: '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.colnr = ' col: ' 
" let g:airline_symbols.colnr = ' ㏇:'

" Disable whitespace error checks
" let g:airline#extensions#whitespace#checks = []
  " \  [ 'indent', 'trailing', 'long', 'mixed-indent-file', 'conflicts' ]

" Override default airline sections at right
let g:airline_section_error = ''
let g:airline_section_warning = ''

" Default airline sections at right
" let g:airline_section_error   (ycm_error_count, syntastic-err, eclim,
"                                 languageclient_error_count)
" let g:airline_section_warning (ycm_warning_count, syntastic-warn,
"                                 languageclient_warning_count, whitespace)


" NerdTree file browsing
Plug 'preservim/nerdtree'
" Close NerdTree after opening file
let NERDTreeQuitOnOpen=1

" Buffer navigation
Plug 'jeetsukumaran/vim-buffergator'

" Vimtex for latex
Plug 'lervag/vimtex'

" Syntax highlighting via polyglot
Plug 'sheerun/vim-polyglot'

" Visual markers for indentation
Plug 'Yggdroot/indentLine'
let g:indentLine_char = '|'
let g:indentLine_setConceal = 0

" Markdown drawer (navigation using markdown headings)
" Plug 'Scuilion/markdown-drawer', { 'for': 'markdown' }

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" For additional markdown functionality like concealing, folding, etc
" Plug 'godlygeek/tabular'
" Plug 'preservim/vim-markdown'

" Pandoc integration
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'

" Surround plugin for surrounding text with parens, brackets, etc
Plug 'tpope/vim-surround'

" Enable automatically line wrapping parameters
Plug 'FooSoft/vim-argwrap'
nnoremap <silent> <leader>w :ArgWrap<CR>

" Disable search highlighting when done searching
Plug 'romainl/vim-cool'

" Vim/git integration
Plug 'tpope/vim-fugitive'

" Indent-object plugin for selecting by indent levels
Plug 'michaeljsmith/vim-indent-object'

" Highlights yanked text
Plug 'machakann/vim-highlightedyank'

" Commands for commenting lines/blocks/selection
Plug 'tpope/vim-commentary'

" FZF plugin
Plug 'junegunn/fzf'

" Add everforest color theme
Plug 'sainnhe/everforest'

" Flake8 plugin for Python/PEP8
Plug 'nvie/vim-flake8'

" Initialize plugin system
call plug#end()

"}}}

" Set color scheme
if has('termguicolors')
  set termguicolors
endif

set background=dark

" Set color to everforest and fix comment highlighting
let &t_ZH="\e[3m"
"let &t_ZR="\e[23m"
let g:everforest_ui_contrast = 'high'
colorscheme everforest

" Run flake8 on python files on write
autocmd BufWritePost *.py call flake8#Flake8()

