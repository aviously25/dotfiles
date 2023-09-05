" VIM setup by avi
" ---------------------------------------------
" Useful keybindings
"   - type "jk" fast in insert mode to excape to normal mode
"   - <shift+j> goes to previous buffer, <shift+k> goes to next buffer
"   - <,fc> to close the current file
"   - <ctrl + w><v> create a vertical split
"   - <ctrl + w><h> create a horizontal split
"   - ":bo term" to create a terminal at the bottom of the screen
"   - select some text in visual mode and type <,y> to copy it to computer
"   clipbloard
syntax on
filetype plugin indent on
set number

set hlsearch
set incsearch
set ignorecase
set smartcase
set mouse=a
set splitbelow
set splitright

set nowrap
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab

set termwinsize=30x0

set viminfo='100,<1000
let mapleader=','

set laststatus=2

" remaps
inoremap jk <Esc>
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k

" change buffers using K and J
nnoremap K :bnext<CR>
nnoremap J :bprev<CR>

" Switch between different windows by their direction`
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

" Exit Terminal to Normal mode
tnoremap <Esc> <C-\><C-n>
tnoremap jk <C-\><C-n>


" close buffer
map <Leader>fc :bp<bar>sp<bar>bn<bar>bd<CR>

" yank over ssh
map <Leader>y <Plug>(operator-poweryank-osc52)

" automatically install vimplug if not installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" -------------------------- PLUGINS -------------------------------
call plug#begin()
  " nerd tree
  Plug 'preservim/nerdtree'

  " airline
  Plug 'vim-airline/vim-airline'

  " nord theme
  Plug 'arcticicestudio/nord-vim'

  " yank(copy) over ssh
  Plug 'haya14busa/vim-poweryank'

call plug#end()

" -------------------------- SETUP FOR PLUGINS ----------------------
"  Automatically display all buffers when there's only one remaining
let g:airline#extensions#tabline#enabled = 1

" Start NERDTree and leave the cursor in it.
autocmd VimEnter * NERDTree

" Exit Vim if NERDTree is the only window or tab remaining in the buffer
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" set default nerd tree size
let g:NERDTreeWinSize = 25

" set colorscheme
colorscheme nord

