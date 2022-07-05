call plug#begin(has('nvim') ? '~/.config/nvim/plugged' : '~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'github/copilot.vim'
Plug 'morhetz/gruvbox'

"Note: run :CocInstall coc-tsserver"
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'preservim/nerdtree'
"Note: see https://github.com/ryanoasis/vim-devicons
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" status line
Plug 'feline-nvim/feline.nvim'
Plug 'kyazdani42/nvim-web-devicons' " for icons
Plug 'lewis6991/gitsigns.nvim' " git icon

Plug 'rking/ag.vim'

call plug#end()

set number
set relativenumber
set scrolloff=8
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set encoding=utf-8

syntax on
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
let g:gruvbox_termcolors=16
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"
let base16colorspace=256
colorscheme gruvbox 

let mapleader = " "
inoremap jk <Esc>
inoremap <A-c> <Esc>

nnoremap <leader>er :Vex<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader><CR> :so ~/.vimrc<CR>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-s> :Files<CR>

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1

" ================= "
" COC configuration "
" ================= "
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap r :CocCommand document.renameCurrentWord 
