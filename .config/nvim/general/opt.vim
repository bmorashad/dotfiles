" start at last edit position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
" buffer and tab related
set hidden
" enable mouse navigation
set mouse=a
" case insensitive search
set ignorecase
set smartcase

set splitright
set splitbelow
" set clipboard=unamedplus
