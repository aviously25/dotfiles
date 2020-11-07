set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

call plug#begin(stdpath('data') . '/plugged')
    Plug 'bfrg/vim-cpp-modern'
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree'
    Plug 'mattn/emmet-vim'
    Plug 'dense-analysis/ale'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    " Plug 'jiangmiao/auto-pairs'
    Plug 'arcticicestudio/nord-vim'


"    Plug 'lervag/vimtex'
"    let g:tex_flavor='latex'
"    let g:vimtex_view_method='skim'
"    let g:vimtex_quickfix_mode=0
"    set conceallevel=1
"    let g:tex_conceal='abdmg'
"
"    Plug 'sirver/ultisnips'
"    let g:UltiSnipsExpandTrigger = '<tab>'
"    let g:UltiSnipsJumpForwardTrigger = '<tab>'
"    let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
"    let g:UltiSnipsSnippetDirectories = ["UltiSnips", "my-snippets"]

    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'pangloss/vim-javascript'
    Plug 'maxmellon/vim-jsx-pretty'
    let g:polyglot_disabled = ['jsx']
call plug#end()

" setting color scheme
let g:airline_theme='nord'
colorscheme nord

" automatically opens up nerdtree
autocmd vimenter * NERDTree

" run fuzzy search on Ctrl + P
nmap <C-P> :FZF<CR>

"make emmet work on js files
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}

" cpc config
let g:coc_global_extensions = ['coc-snippets', 'coc-pairs', 'coc-tsserver', 'coc-eslint', 'coc-prettier', 'coc-json']

" map :Prettier to clean up file
command! -nargs=0 Prettier :CocCommand prettier.formatFile

