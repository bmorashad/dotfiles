" escape search highlight
nnoremap <leader>/ :noh<CR>

" Use ctrl + hjkl to resize windows
nnoremap <C-j>    :resize -2<CR>
nnoremap <C-k>    :resize +2<CR>
nnoremap <C-h>    :vertical resize -2<CR>
nnoremap <C-l>    :vertical resize +2<CR>

" Use ctrl + mniu to switch panes
nnoremap <C-b> <C-W><C-W>
nnoremap <C-n> <C-W>h
nnoremap <C-m> <C-W>l
nnoremap <C-i> <C-W>k
nnoremap <C-u> <C-W>j

" nnoremap <Leader>o o<Esc>^Da
" nnoremap <Leader>O O<Esc>^Da

" TAB in general mode will move to text buffer
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Alternate way to save
nnoremap <C-s> :w<CR>

" check if works with Coc
" <TAB>: completion.
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" vim-fugitive
nmap <leader>gs :vertical G<CR>
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gc :vertical Gcommit <CR>

"fzf commands
" nnoremap <silent> <Leader>\ :Files<CR>
" nnoremap <silent> <Leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
" nnoremap <silent> <Leader>b :Buffers<CR>
" nnoremap <silent> <Leader>g :GFiles<CR>

"ripgrep and fzf
nnoremap <Leader>rg :Rg<Space>
nnoremap <Leader>RG :Rg!<Space>

" Make file executable
nmap <leader>x :Xbit<CR>
