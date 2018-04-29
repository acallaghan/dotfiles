call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-sensible'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-rails'
  Plug 'vim-ruby/vim-ruby'
  Plug 'scrooloose/nerdtree'
  Plug 'mileszs/ack.vim'
  Plug 'tmux-plugins/vim-tmux'
  Plug 'kien/ctrlp.vim'
  Plug 'airblade/vim-gitgutter'
  Plug 'junegunn/seoul256.vim'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'kchmck/vim-coffee-script'
call plug#end()

" Easier split navigation - use ctrl+j for up, ctrl+h for left
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set number
set cursorline
set ignorecase
set showmatch
set splitbelow
set splitright

set noerrorbells visualbell t_vb=    	" Disable all bells
set showcmd                          	" show command that is being entered in the lower right
set backspace=indent,eol,start       	" Allow extended backspace behaviour
set virtualedit=block                	" allow placing the cursor after the last char

" Unified color scheme (default: dark)
let g:seoul256_background = 233
colo seoul256

filetype plugin indent on 		        " Automatically detect file types.
syntax on
set mouse=a 				                  " enable mouse mode

if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

" 2-space soft tabs by defaults
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" --- Wrapping
set autoindent 				" Remember indent level after going to the next line.
set nowrap 				    " Do not visually wrap lines by default.

let mapleader = "-"

" NERDTree
" Shortcut to open/close
map <Leader>n :NERDTreeToggle<CR>
" Highlight the current buffer (think of 'find')
map <Leader>f :NERDTreeFind<CR>

let NERDTreeMinimalUI=1
let NERDTreeShowHidden=1 " show hidden files at startup
let NERDTreeIgnore = ['\.pyc$', '\.class$'] "
" http://superuser.com/questions/184844/hide-certain-files-in-nerdtree
let NERDTreeAutoDeleteBuffer=1 " automatically replace/close the corresponding buffer when a file is moved/deleted

" Start NERDTree up if no files are specified when starting
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" -------------
" --- CtrlP ---
" -------------

let g:ctrlp_show_hidden = 1
" open new file with <c-y> in the current window instead of v-split, to be
" consistent with the behaviour of the `:edit' command
let g:ctrlp_open_new_file = 'r'
" the max height for the results is still 10, but can be scrolled up if there
" are more
let g:ctrlp_match_window = 'results:100'
" when opening multiple files (selected with <c-z> and <c-o>)...
"   - open the first in the current window, and the rest as hidden
"     buffers (option 'r')
"   - set the maximum number of splits to use to '1' (which means only the
"     current one, no new splits will be created)
" unlike 'ij', this also works when the only buffer is the no-name buffer
let g:ctrlp_open_multiple_files = 'r1'

" only effective if `ag' not available
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.git|\.hg|\.svn|\.bundle|bin|node_modules|tmp|log|vendor)$',
  \ 'file': '\v\.(exe|so|dll|class|pyc)$',
  \ }

" Use ag if available, because faster.
" Normally ag excludes directories like `git', but the `--hidden' option
" overrides that. We need therefore to explicitly specify the paths to be
" ignored.
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'.
        \' --ignore-dir=.git'.
        \' --ignore-dir=.hg'.
        \' --ignore-dir=.svn'.
        \' --ignore-dir=.bundle'.
        \' --ignore-dir=.bin'.
        \' --ignore-dir=vendor'.
        \' --ignore-dir=log'.
        \' --ignore-dir=node_modules'.
        \' --ignore=*.exe'.
        \' --ignore=*.so'.
        \' --ignore=*.class'.
        \' --ignore=*.dll'.
        \' --ignore=*.pyc'.
        \' --ignore=tags'
endif

" use ctrlp in a single shortcut to navigate buffers
noremap <Leader>b :CtrlPBuffer<CR>

" Search and replace current word
nnoremap <Leader>r :%s/\<<C-r><C-w>\>/

" Remap leader-d to delete buffer
nmap <Leader>d :bd

" Remap gc comments to leader-c
nmap <Leader>c gcc
vmap <Leader>c gc

" --- Whitespace
set listchars=tab:»·,trail:·,extends:>,precedes:<
" toggle hidden characters highlighting:
nmap <silent> <Leader>h :set nolist!<CR>

function! <SID>StripTrailingWhitespaces()
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e " end of lines
  %s/\n\{3,}/\r\r/e " multiple blank lines
  silent! %s/\($\n\s*\)\+\%$// " end of file
  call cursor(l, c)
endfun

autocmd FileType Dockerfile,make,c,coffee,cpp,css,eruby,eelixir,elixir,html,java,javascript,json,markdown,php,puppet,python,ruby,scss,sh,sql,text,tmux,typescript,vim,yaml autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()

" Allow the `enter' key to chose from the omnicompletion window, instead of <C-y>
" http://vim.wikia.com/wiki/Make_Vim_completion_popup_menu_work_just_like_in_an_IDE
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

set pastetoggle=<F3>

set wildignore+=*.swp,*/tmp/
set noswapfile
set noundofile

" Modify ctrl+p file finder behaviour, allowing spaces
let g:ctrlp_abbrev = {
  \ 'gmode': 'i',
  \ 'abbrevs': [
    \ {
      \ 'pattern': ' ',
      \ 'expanded': '',
      \ 'mode': 'pfrz',
    \ },
    \ ]
  \ }
" ---------------------------------
" --- RSpec syntax highlighting ---
" ---------------------------------

autocmd BufRead {*_spec.rb,spec_helper.rb} syn keyword rubyRspec
      \ after
      \ before
      \ class_double
      \ context
      \ describe
      \ described_class
      \ double
      \ expect
      \ include_context
      \ include_examples
      \ instance_double
      \ it
      \ it_behaves_like
      \ it_should_behave_like
      \ its
      \ let
      \ object_double
      \ raise_error
      \ setup
      \ shared_context
      \ shared_examples
      \ shared_examples_for
      \ specify
      \ subject
      \ xit

highlight def link rubyRspec Function
