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

" highlight 81th column
set colorcolumn=81

" vim-closetag
let g:closetag_regions = {
	\ 'typescript.tsx': 'jsxRegion,tsxRegion',
	\ 'javascript.jsx': 'jsxRegion',
	\ }

let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.erb,*.jsx"
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.erb'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
" let g:closetag_close_shortcut = '<leader>>'

" ale
let g:ale_fixers = {
 \ 'javascript': ['eslint']
 \ }

let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'
let g:ale_fix_on_save = 1

" autocmd
autocmd BufEnter *.jsx set shiftwidth=2 tabstop=2
autocmd BufEnter *.jsx norm zR
autocmd BufEnter *.css set shiftwidth=2 tabstop=2

" nerdcommenter
let g:NERDCreateDefaultMappings = 1
let g:NERDSpaceDelims = 1
let g:NERDCustomDelimiters={
	\ 'javascript': { 'left': '//', 'right': '', 'leftAlt': '{/*', 'rightAlt': '*/}' },
\}
