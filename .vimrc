call plug#begin('~/.vim/plugged') " ????
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  "From missing semester Jose FZF plugin, makes Ctrl-P unnecessary
Plug 'junegunn/fzf.vim'
call plug#end()
