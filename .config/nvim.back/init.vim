
set nocompatible

" :let mapleader = " "

" polygot disables
let g:polyglot_disabled = ['markdown']

source $HOME/.config/nvim/general/functions.vim
source $HOME/.config/nvim/general/func-maps.vim
source $HOME/.config/nvim/keys/mappings.vim
source $HOME/.config/nvim/keys/coc-mappings.vim
source $HOME/.config/nvim/general/opt.vim
" source $HOME/.config/nvim/theme/lightline.vim

" cSpell:disable "
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')
" If you don't have nodejs and yarn
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Testing
" Plug 'w0rp/ale'

" Inspector (Debugger) 
" Plug 'preservim/nerdcommenter'
Plug 'puremourning/vimspector'

Plug 'doums/darcula'

" R lang
Plug 'jalvesaq/Nvim-R'

Plug 'tpope/vim-surround'

" JSX 8/28/20
Plug 'MaxMEllon/vim-jsx-pretty'

" Plug 'yuezk/vim-js'
" js 8/28/20
Plug 'pangloss/vim-javascript'

" Motions
" To Be Enabled
Plug 'unblevable/quick-scope'

" Theme
" Github Theme

" Plug 'danilo-augusto/vim-afterglow', {'as': 'afterglow'}
" Plug 'romainl/Apprentice', {'as': 'apprentice'}
" Plug 'cseelus/vim-colors-lucid', {'as': 'colors-lucid'}
" Plug 'kamykn/dark-theme.vim', {'as': 'dark-theme'}
" Plug 'joshdick/onedark.vim', {'as': 'onedark'}
" Plug 'phanviet/vim-monokai-pro'
" Selected
" Plug 'itchyny/landscape.vim'
" ref: https://github.com/chriskempson/base16-vim/tree/master/colors
Plug 'chriskempson/base16-vim'
Plug 'patstockwell/vim-monokai-tasty'
" Plug 'christophermca/meta5', {'as': 'meta5'}
" Plug 'drewtempelmeyer/palenight.vim'
Plug 'tomasiser/vim-code-dark', {'as': 'codedark'}
" Plug 'rakr/vim-one'
" Plug 'morhetz/gruvbox', {'as': 'gruvbox'}

" Floating terminal
" Plug 'voldikss/vim-floaterm'

" Syntax highlight
" effects gruvbox in markdown(maybe more), disabled in polyglot_disabled
" variable
Plug 'sheerun/vim-polyglot'

" Smooth Scroll
" To Be Enabled
Plug 'psliwka/vim-smoothie'

" Plug 'lilydjwg/colorizer'
" Plug 'DougBeney/pickachu'
" Plug 'chrisbra/Colorizer'
" Plug 'KabbAmine/vCoolor.vim' 

Plug 'alvan/vim-closetag'

Plug 'pangloss/vim-javascript'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'scrooloose/nerdtree'
" fzf in rust(alternative)
" Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
" fzf
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }  "From missing semester Jose FZF plugin, makes Ctrl-P unnecessary
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'Xuyuanp/nerdtree-git-plugin'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'ryanoasis/vim-devicons' have lua port
" Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax

" Initialize plugin system
" Just Look
" Plug 'itchyny/lightline.vim'

call plug#end()


" set rtp+=$HOME/.fzf

" Reload vimrc
" nmap <leader>t :source ~/.config/nvim/init.vim

"enable undo after close"
if has('persistent_undo')      "check if your vim version supports it
  " Disable due to some files name being too long LOL 
  set undofile                 "turn on the feature  
  set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
endif 

let g:vim_jsx_pretty_colorful_config = 1

augroup qs_colors
  autocmd!
  autocmd ColorScheme * highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme * highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END 

" save sudo files with w!!
cmap w!! w !sudo tee % >/dev/null

" Fix recent coc error when using tabs
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

nnoremap s S
":syntax on

" let g:vim_monokai_tasty_italic = 1

set termguicolors
" let g:vim_monokai_tasty_italic = 1
" let g:lightline = { 'colorscheme': 'powerline' }
" let g:lightline = {
	 " \ 'colorscheme': 'solarized dark',
	 " \ }

" let g:gruvbox_italic = '1'
" let g:gruvbox_transparent_bg = '1'
" let g:gruvbox_contrast_dark = 'medium'
" let g:gruvbox_invert_signs = '1'
" colorscheme gruvbox
" hi MinimapCurrentLine ctermfg=Green guifg=#50FA7B guibg=#32302f
" let g:minimap_highlight = 'MinimapCurrentLine'

" autocmd BufEnter * colorscheme base16-solarflare
" autocmd BufEnter * colorscheme base16-solarized-dark
" autocmd BufLeave * colorscheme base16-solarized-dark

" autocmd BufEnter *.py colorscheme gruvbox
" autocmd BufLeave *.py colorscheme gruvbox

" autocmd BufEnter *.md colorscheme gruvbox
" autocmd BufLeave *.md colorscheme gruvbox

" autocmd BufEnter *.java colorscheme darcula
" autocmd BufEnter *.java colorscheme gruvbox
" autocmd BufLeave *.java colorscheme gruvbox
" set background=dark
" let g:one_allow_italics = 1
" let g:palenight_terminal_italics=1

" change default background color
" hi Normal guibg=#1a1a1a

" hi HopNextKey guifg=#fc4fc4
" hi HopNextKey1 guifg=#fc4fc4
" hi HopNextKey2 guifg=#fc4fc4

" Color Picker key map
nnoremap <A-c> :Pickachu<CR>

" default key remaps change
" noremap :X :wq<cr>
" nnoremap s S
nnoremap w W
nnoremap K }
nnoremap <A-o> }
nnoremap <A-i> {

" switch buffers
" nnoremap <C-b> :bn<cr>
" map gn :bn<cr>
" map gp :bp<cr>

" copy to system clipboard
noremap <C-c> "+y
noremap <C-p> "+p

" let g:smoothie_no_default_mappings = 1 
" nmap L <Plug>(SmoothieDownwards)
" nmap : <Plug>(SmoothieUpwards)
"silent! nmap <unique> <A-l>          <Plug>(SmoothieDownwards)
"silent! nmap <unique> <A-:>          <Plug>(SmoothieUpwards)
" silent! nmap <unique> <C-F>      <Plug>(SmoothieForwards)
" silent! nmap <unique> <S-Down>   <Plug>(SmoothieForwards)
" silent! nmap <unique> <PageDown> <Plug>(SmoothieForwards)
" silent! nmap <unique> <C-B>      <Plug>(SmoothieBackwards)
" silent! nmap <unique> <S-Up>     <Plug>(SmoothieBackwards)
" silent! nmap <unique> <PageUp>   <Plug>(SmoothieBackwards)

" Mouse Scroll
" nmap <ScrollWheelUp> <Plug>(SmoothieUpwards)
" nmap <ScrollWheelDown> <Plug>(SmoothieDownwards)

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" inoremap jk <ESC>
nnoremap ; :
nnoremap ,w <C-W><C-W>
" nnoremap H Hzz
" map <C-n> :NERDTreeToggle<CR>
" nnoremap ,e :NERDTreeToggle<CR>
" map <C-p> :FZF 

" comment, uncomment
" vmap ,c <plug>NERDCommenterToggle
" nmap ,c <plug>NERDCommenterToggle
" nmap ,a <plug>NERDCommenterAltDelims

let g:NERDSpaceDelims = 1

" fzf
" fzf bug fix
" set shell= /bin/bash
set rtp+=/usr/share/fzf
nnoremap ,d :FZF ~/Documents/<cr>
nnoremap ,F :Files<cr>  
nnoremap ,f :GFiles<cr>  
nnoremap ,b :Buffers<cr>  
" nnoremap ,g :FZF ~/<cr>

" open NERDTree automatically
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * NERDTree

" let g:NERDTreeGitStatusWithFlags = 1
"let g:WebDevIconsUnicodeDecorateFolderNodes = 1
"let g:NERDTreeGitStatusNodeColorization = 1
"let g:NERDTreeColorMapCustom = {
      "\ "Staged"    : "#0ee375",  
      "\ "Modified"  : "#d9bf91",  
      "\ "Renamed"   : "#51C9FC",  
      "\ "Untracked" : "#FCE77C",  
      "\ "Unmerged"  : "#FC51E6",  
      "\ "Dirty"     : "#FFBD61",  
      "\ "Clean"     : "#87939A",   
      "\ "Ignored"   : "#808080"   
      "\ }                         


" let g:NERDTreeIgnore = ['^node_modules$']

let g:vim_jsx_pretty_highlight_close_tag = 1
" code folding javascript
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END
" vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
" run prettier on save
"let g:prettier#autoformat = 0
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync


" ctrlp
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" set relativenumber
set nu
"set rnu

"set cursorline highlight 
set cursorline
set smarttab
set cindent
set tabstop=2
set shiftwidth=2
" always uses spaces instead of tab characters
" set expandtab

" sync open file with NERDTree
" " Check if NERDTree is open or active
" function! IsNERDTreeOpen()        
" return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
" endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
" function! SyncTree()
" if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"    NERDTreeFind
"    wincmd p
"  endif
" endfunction

" Highlight currently open buffer in NERDTree
" autocmd BufEnter * call SyncTree()

" coc config
"\ 'coc-prettier', 
" \ 'coc-eslint',
let g:coc_global_extensions = [
      \ 'coc-snippets',
      \ 'coc-pairs',
      \ 'coc-tsserver',
      \ 'coc-json', 
	  \ 'coc-actions',
	  \ ]
" \ 'coc-java',
" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup 
" Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
" set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate mispellins/diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> ^ :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"  if (index(['vim','help'], &filetype) >= 0)
"    execute 'h '.expand('<cword>')
"  else
"    call CocAction('doHover')
"  endif
" endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)
nmap ,r <Plug>(coc-rename)

" Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Toggle spell check

" augroup mygroup
  " autocmd!
  " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>n  <Plug>(coc-codeaction-selected)
" nmap <leader>m  <Plug>(coc-codeaction-selected)
xmap <leader>n  <Plug>(coc-codeaction-selected)
nmap <leader>n  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select)"
"xmap <silent> <C-d> <Plug>(coc-range-select)"

" Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Python Path
" TODO: add setup of this in bootstrap.sh
" if filereadable(expand('~') . '/.py_env/py_env2/bin/python')
	" let g:python_host_prog = expand('~') . '/.py_env/py_env2/bin/python'
" endif
" if filereadable(expand('~') . '/.py_env/py_env3/bin/python')
	" let g:python3_host_prog = expand('~') . '/.py_env/py_env3/bin/python'
" endif
let g:python3_host_prog='$HOME/.py_env/py_env3/bin/python'
let g:python_host_prog='$HOME/.py_env/py_env2/bin/python'
lua require 'init'
