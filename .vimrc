" Vim Configuration - Modern and user-friendly

" Basic Settings
set nocompatible              " Disable vi compatibility
syntax enable                 " Enable syntax highlighting
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set ruler                     " Show cursor position
set showcmd                   " Show incomplete commands
set showmatch                 " Highlight matching brackets
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive when uppercase present
set autoread                  " Auto reload files changed outside vim
set hidden                    " Allow hidden buffers
set wildmenu                  " Enhanced command line completion
set wildmode=longest:full,full
set backspace=indent,eol,start " Make backspace work properly

" Indentation
set autoindent                " Auto indent new lines
set smartindent               " Smart indent
set expandtab                 " Use spaces instead of tabs
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Soft tab width
set shiftround                " Round indent to multiple of shiftwidth

" Visual
set background=dark           " Dark background
set cursorline                " Highlight current line
set scrolloff=8               " Keep 8 lines above/below cursor
set sidescrolloff=8           " Keep 8 columns left/right of cursor
set wrap                      " Wrap long lines
set linebreak                 " Break lines at word boundaries
set showbreak=↪               " Character to show at line breaks
set list                      " Show invisible characters
set listchars=tab:→\ ,trail:·,extends:⟩,precedes:⟨,nbsp:·

" File handling
set encoding=utf-8            " Use UTF-8 encoding
set fileformat=unix           " Use Unix line endings
set backup                    " Enable backups
set backupdir=~/.vim/backup// " Backup directory
set directory=~/.vim/swap//   " Swap file directory
set undofile                  " Persistent undo
set undodir=~/.vim/undo//     " Undo directory

" Create directories if they don't exist
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "p", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "p", 0700)
endif

" Key Mappings
let mapleader = " "           " Set leader key to space

" Better navigation
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlight
nnoremap <leader>/ :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Tab navigation
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>tc :tabclose<CR>
nnoremap <leader>th :tabprevious<CR>
nnoremap <leader>tl :tabnext<CR>

" Split windows
nnoremap <leader>v :vsplit<CR>
nnoremap <leader>h :split<CR>

" Resize windows
nnoremap <leader>+ :resize +5<CR>
nnoremap <leader>- :resize -5<CR>
nnoremap <leader>> :vertical resize +5<CR>
nnoremap <leader>< :vertical resize -5<CR>

" Copy/paste from system clipboard
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Toggle paste mode
set pastetoggle=<F2>

" File navigation
nnoremap <leader>e :Explore<CR>

" Quick edit vimrc
nnoremap <leader>ev :edit $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" Visual mode improvements
vnoremap < <gv
vnoremap > >gv

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR># Dotfiles Repository Structure

## Repository Layout
