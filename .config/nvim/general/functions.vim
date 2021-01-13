" Run :Xbit to make file executable
function! SetExecutableBit()
	let fname = expand("%:p")
	checktime
	execute "au FileChangedShell " . fname . " :echo"
	silent !chmod a+x %
	checktime
	execute "au! FileChangedShell " . fname
endfunction
command! Xbit call SetExecutableBit()

function! CompileRun()
	"if &filetype == 'c'
	"exec "!gcc % -o %<"
	"exec "!time ./%<"
	"elseif &filetype == 'cpp'
	"exec "!g++ % -o %<"
	"exec "!time ./%<"
	if &filetype == 'java'
		if !empty(glob("./.compile-run.sh"))
			exec "term ./.compile-run.sh"
		else
			exec "w !javac -sourcepath ./ -d out -classpath out %"
			exec "w !time java -cp out %:t:r"
			" exec "w !time java -cp %:p:h %:t:r"
		endif
	elseif &filetype == 'sh'
		exec "w !time bash %"
	elseif &filetype == 'python'
		exec "w !time python %"
	elseif &filetype == 'html'
		exec "w !chrome % &"
	elseif &filetype == 'mkd'
		exec "!~/.vim/markdown.pl % > %.html &"
		exec "!firefox %.html &"
	endif
endfunc
command! CompileRun call CompileRun()

function! CompileRunInTerm()
	if &filetype == 'java'
		exec "term javac %"
		exec "term time java -cp %:p:h %:t:r"
	elseif &filetype == 'python'
		exec "term time python %"
	endif
endfunc
command! CompileRunInTerm call CompileRunInTerm()
