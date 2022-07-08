set number
set noswapfile
set completeopt=menu,menuone,noselect
set signcolumn=yes
set nospell
set undodir=$HOME/nvim/undo
set undofile
set ignorecase
set smartcase
set hlsearch
set incsearch
set splitbelow
set splitright
set noswapfile
set hidden
set wildmenu
" set wildmode=longest,list,full
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
set updatetime=1000
set laststatus=3 " global status line
set fillchars=horiz:━,horizup:┻,horizdown:┳,vert:┃,vertleft:┨,vertright:┣,verthoriz:╋

set breakindent
set breakindentopt=shift:2
set showbreak=↳

" Bindings
nnoremap <SPACE> <Nop>
let mapleader = ' '
nnoremap <leader>f :Telescope find_files<cr>
nnoremap <leader>a :lua find_files_all()<cr>
nnoremap <leader>h :Telescope oldfiles<cr>
nnoremap <leader>r :Telescope registers<cr>
nnoremap <leader>p :!prettier -w %<cr>
nnoremap <leader>y @q
nnoremap <leader><space> :Telescope live_grep<cr>
nnoremap <leader>/ :nohlsearch<cr>
vnoremap p "_dP | "
nnoremap <leader>s :call TrimWhitespace()<cr>
nnoremap - :NvimTreeToggle<cr>
nnoremap <leader>o :only<cr>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" :W writes
command! -bar -nargs=* -complete=file -range=% -bang W         <line1>,<line2>write<bang> <args>

command! Date r!date "+\%F"
command! Now r!date

" Nvim-tree
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif

" Resize buffers when window changes sizes
autocmd VimResized * execute "normal! \<c-w>="

autocmd BufReadPost *.conf setl ft=conf
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun


