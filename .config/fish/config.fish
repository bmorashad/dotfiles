# Entgra Config
export dist="$HOME/Work/Entgra/emm-proprietary-plugins/distribution/ultimate/target/entgra-iot-ultimate-4.1.1-SNAPSHOT"
export carbon="$HOME/Work/Entgra/carbon-device-mgt" 
export plugin="$HOME/Work/Entgra/carbon-device-mgt-plugins" 
export product="$HOME/Work/Entgra/product-iots"
export emm="$HOME/Work/Entgra/emm-proprietary-plugins"

function ctc 
	set -l dir (git diff-tree --no-commit-id --name-only -r $argv[1] | rg 'src/main/java.*' --replace '' | uniq | rg '(.*)' --replace ''$argv[2]'/$0' | fzf)
	if test "$dir" != ""
		cd $dir
	end
end

function etb 
	git diff --name-only -r $argv[1] | rg 'src/main/java.*' --replace '' | uniq | rg '(.*)' --replace ''$argv[2]'/$0'
end
function ecd
	set -l dir (etb $argv[1] $argv[2] | fzf)
	if test "$dir" != ""
		cd $dir
	end

end

function elist
	set -l dir (etb $argv[1] $argv[2] | sed -n "$argv[3] p")
	echo $dir
end

function emi 
	for x in $argv[3..-1]
		set -l dir (etb $argv[1] $argv[2] | sed -n "$x p")
		if test "$dir" != ""
			echo "Building $dir"
			cd $dir
			if test "$status" = 0
				mvn clean install -Dmaven.test.skip=true
			end
		end
	end
end

function entup 
	for x in $argv[3..-1]
		set -l dir (etb $argv[1] $argv[2] | sed -n "$x p")
		if test "$dir" != ""
			echo "Updating $dir" | rg "/home/bmora/Work/Entgra" --replace ""
			set -l war (ls $dir/target | rg '.*war') 
			if test "$war" != ""
				set -l distWar (ls $dist/repository/deployment/server/webapps/ | rg $war)
				set -l warDir (echo $war | rg '.war' --replace '')
				set -l distWarDir (ls $dist/repository/deployment/server/webapps/ | rg "$warDir\$")

				set -l warRm $dist/repository/deployment/server/webapps/$distWar
				set -l dirWarRm $dist/repository/deployment/server/webapps/$distWarDir

				if test "$warRm" != ""
					echo "Deleting $warRm" | rg "/home/bmora/Work/Entgra" --replace ""
					rm -r $warRm
				end
				if test "$dirWarRm" != ""
					echo "Deleting $dirWarRm" | rg "/home/bmora/Work/Entgra" --replace ""
					rm -rf $dirWarRm
				end
				echo "Copying $dir/target/$war to $dist/repository/deployment/server/webapps" | rg "/home/bmora/Work/Entgra" --replace ""

				cp $dir/target/$war $dist/repository/deployment/server/webapps
			else
				set -l jar (ls $dir/target | rg '.*jar') 
				if test "$jar" != ""
					set -l patchDirLs (ls $dist/patches)
					set -l patch0000 (ls $dist/patches | rg patch0000)
					set -l patch5000 (ls $dist/patches | rg patch5000)
					if test "$patchDirLs" = ""
						set patchDir "patch5000"
					else if test "$patch5000" != ""
						set patchDir (math (ls $dist/patches/ | rg '\w*[^\d]' --replace '' | sort -r | sed -n "1 p") + 1 | rg '\d*' --replace 'patch$0')
					else
						set patchDir "patch5000"
					end
					mkdir $dist/patches/$patchDir
					echo "Copying $dir/target/$jar to $dist/patches/$patchDir" | rg "/home/bmora/Work/Entgra" --replace ""
					cp $dir/target/$jar $dist/patches/$patchDir
				else
					echo "No target found"
				end	
			end
		else
			echo "No dir for given args"
		end
	end
end

# surpress fish greeting
# set fish_greeting
function fish_greeting
	# echo
	echo -e (uname -ro | awk '{print "\\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print "\\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (echo (uname -n)"\033[0;34m@\033[0m$USER" | awk '{print "\\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	# echo -e " \\e[1mDisk usage:\\e[0m"
	# echo
	# echo -ne (\
	# df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
	# awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
	# sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
	# paste -sd ''\
	# )
	echo
end

# prompt
# starship init fish | source

# set tab selection color
set fish_color_search_match --background=blue
# key-bindings
function fish_user_key_bindings
	bind \ao 'clear;'
end

# get diff intitue way
function dfa
	diff --suppress-blank-empty -E -Z -b -B -u $argv[1] $argv[2] | grep -E "^\+" | rg '^\+' --replace ""
end
function dfd
	diff --suppress-blank-empty -E -Z -b -B -u $argv[1] $argv[2] | grep -E "^\-" | rg '^\-' --replace ""
end

# compresss vid with simple config with same original vid quality output
function handbrake_compress
	if count $argv > /dev/null
		HandBrakeCLI -i $argv[1] -o $argv[2] -e x264 -r 15 -B 64 -O
	else
		echo "Invalid arguments provided"
	end
end

# make alias
#function alias --argument-names alias_name function
#if count $argv > 2
#if test -f $HOME/.config/fish/functions/$alias_name.fish 
#echo "Error: alias already exist" 1>&2
#else
#touch $HOME/.config/fish/functions/$alias_name.fish
#echo "alias $alias_name='$function'" > $HOME/.config/fish/functions/$alias_name.fish
#funcsave $alias_name
#end
#else 
#echo "Erro: need two arguments" 1>&2
#end
#end

# print prayer times
function prayer
	http http://slmuslims.com | rg "(\d{1,}\s*:\s*\d{2}\s*(am|pm))|id\s*=\s*\"\s*(fajr|sunrise|luhar|asar|magrib|ishah)\s*\"" \
	--replace '$1$3' -o | tr '\n' '|' | rg  "([a|p]m)\s*\|" --replace '$1|||' | sed 's/|||/\n/g' | sed -e "s/\(^\w\)/\u\1/g" \
	| rg '(\D)(\d{1}:)' --replace '$1,0$2' --passthru | sed 's/,//g' | column -t -s '|' | \
	rg '^\w+' --colors 'match:fg:cyan' --color always| rg '\d{1,}:.*' --colors 'match:fg:blue'
end


# make dir if not exist and cd into
function mcd --description "mkdir if not exist and cd into"
	mkdir -p $argv[1]
	cd $argv[1]
end

# kill process
function kill_process --description "Kill processes"
	set -l __kp__pid (ps aux | fzf --ansi --height '50%' -m | awk '{print $2}')
	# set -l __kp__pid (procs --color="always" | fzf --ansi --height '50%' -m | awk '{print $1}')
	set -l __kp__kc $argv[1]

	if test "x$__kp__pid" != "x"
		if test "x$argv[1]" != "x"
			echo $__kp__pid | xargs -p kill $argv[1]
		else
			echo $__kp__pid | xargs -p kill -9
		end
		# kill_process
	end
end

# GIT

function fco -d "Fuzzy-find and checkout a branch"
	git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fcoc -d "Fuzzy-find and checkout a commit"
	git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

# Download from youtube
function ydl -d "youtube-dlc download playlist at highest quality"
	# youtube-dlc -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' -c --playlist-start 1
	youtube-dlc -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' $argv
end

# Copy File Content
function copy_to_new_file -d "copy all files with given extension to a new file withing a dir"
	if count $argv > /dev/null
		# fd -e $argv[1] -0 | xargs -0 -r cat >> copied.txt
		fd -e $argv[1] -X cat >> copied.txt
	else
		# fd -t f -0 | xargs -0 -r cat >> copied.txt
		fd -t f -X cat >> copied.txt
	end
end

# eopkg with fzf
function install_with_fzf 
	# if arguments passed(i.e install_with_fzf neovim)
	if count $argv > /dev/null
		# if last argument contains '-'(dash) in it(i.e install_with_fzf neovim -e)
		if test (expr substr $argv[-1] 1 1) = "-" 
			# if so pass the last argument(with the dash) to fzf command as an argument and remaining args to eopkg search
			eopkg search $argv[1..-2] | fzf --ansi -m -0 $argv[-1] | awk '{print $1}' | xargs -o -r sudo eopkg it;
		else
			# else pass the all args to eopkg search
			eopkg search $argv | fzf --ansi -m -0 | awk '{print $1}' | xargs -o -r sudo eopkg it;
		end
		# if no arguments passed(i.e install_with_fzf)
	else
		# eopkg la | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
		eopkg la | fzf --ansi -m | awk '{print $1}' | xargs -o -r sudo eopkg it;
	end
	# eopkg search $argv | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
	# Begin Test

	# set arg_str_len (expr length "$argv")
	# set rest_str (echo $argv | cut -s -d "-" -f 2-)
	# set rest_str_len (expr length "$rest_str")
	# set dash_indx (expr $arg_str_len - $rest_str_len)
	# set pre_dash_indx (expr $dash_indx - 1)

	# if test (expr substr "$argv" $pre_dash_indx 1) = " "
	# echo "yes"
	# end

	# End
end

function apps_with_fzf
	if count $argv > /dev/null 
		eopkg la | fzf --ansi -m -q "$argv";
	else
		eopkg la | fzf --ansi -m;
	end
end

# fzf  shortcuts
function open_with_fzf 
	builtin cd $HOME && fd -t f -d 6 | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-;
end

function nvi_with_fzf 
	set -l curr_dir (pwd)
	builtin cd && fd -i -d 6 -t f | fzf -i -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" nvim 2>&- ; cd $curr_dir
end

function cd_with_fzf
	if  count $argv > /dev/null
		builtin cd $HOME && builtin cd (fd -i -t d -d 10 | fzf -q "$argv" --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	else 
		# builtin cd / && builtin cd (fd -i -t d -d 10 . . $HOME/.config -E /home/burhan | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
		builtin cd $HOME && builtin cd (fd -i -t d -d 10 | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	end
end

function ad_with_fzf
	if  count $argv > /dev/null
		builtin cd $HOME && builtin cd (fd -H -i -t d -E .cache -E Games | fzf -q "$argv[1]" $argv[2..-1] --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	else 
		builtin cd $HOME && builtin cd (fd -H -i -t d -E .cache -E Games | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	end
end

function rd_with_fzf
	if count $argv > /dev/null
		builtin cd / && builtin cd (fd -i -t d -H -E /home | fzf -q "$argv[1]" $argv[2..-1] --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	else
		builtin cd / && builtin cd (fd -i -t d -H -E /home | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
	end
end


# Notes With FZF

function preview_note_with_fzf
	if count $argv > /dev/null
		set note (notes ls -A --oneline |  fzf --ansi -m -q "$argv" | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			glow -p $note
		end
	else
		set note (notes ls -A --oneline |  fzf --ansi -m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			glow -p $note
		end
	end
end

function notes_with_fzf
	if count $argv > /dev/null
		set note (notes ls -A --oneline | env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $NOTES_CLI_FZF_PREVIEW" fzf --ansi -m -q "$argv" | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			nvim -O $note
		end
	else
		set note (notes ls -A --oneline | env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $NOTES_CLI_FZF_PREVIEW" fzf --ansi -m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			nvim -O $note
		end
	end
end

# TODO: complete, bug fix
function notes_grep_fzf
	rg -l "" $NOTES_CLI_HOME --column --line-number --smart-case --color=always --colors path:fg:green \
	| rg "/[^/]+.md" --passthru --colors match:fg:yellow --colors match:style:nobold --color=always | rg "$NOTES_CLI_HOME/" --replace "" |\
	fzf -m --bind "change:reload:rg {q} $NOTES_CLI_HOME \
	-l --smart-case --color=always --colors path:fg:green | rg '/[^/]+.md' --passthru \
	--colors match:fg:yellow --colors match:style:nobold --color=always | sed 's/\/home\/bmora\/.notes\///' ||true" \
	--ansi --phony --query "" --layout=reverse \
	--prompt 'regex: '\
	--preview "rg {q} $NOTES_CLI_HOME/{} --smart-case --color=always --context 5 | bat --style plain --color always -l md"\
	--preview-window sharp:wrap:right:65% --bind J:preview-down,K:preview-up --color prompt:166,border:#4a4a4a \
	--border sharp|\
	awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0}' | xargs -r -d '\n' nvim -O
end

function notes_hashtag_fzf
	set -l tag (rg "#[a-zA-Z0-9]+" $NOTES_CLI_HOME -o --no-line-number --color=always --sort created --no-heading --no-filename --colors match:fg:blue| uniq |\
	fzf --ansi --reverse --preview 'rg {} $NOTES_CLI_HOME -l --color=always --heading --colors path:fg:green | rg '/[^/]+.md' --passthru \
	--colors match:fg:yellow --colors match:style:nobold --color=always | rg "$NOTES_CLI_HOME/" --replace ""' --preview-window 80%)
	! test -z $tag && set -l note (rg $tag "$NOTES_CLI_HOME" -l --colors path:fg:green --color always| rg --color always "$NOTES_CLI_HOME/"\
	--replace "" |\
	rg "/[^/]+.md" --passthru --colors match:fg:yellow --colors match:style:nobold --color=always|\
	env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $NOTES_CLI_FZF_PREVIEW" fzf -m --ansi --reverse --preview-window nohidden \
	--preview-window 75%|\
	awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0}')

	set -l selected (echo $note)
	! test -z $selected && nvim -o $note
	! test -z $tag && test -z $selected && notes_hashtag_fzf

end

function rename_note_with_fzf
	if count $argv > /dev/null
		set new_name (echo "$argv")
		set note (notes ls -A --oneline | fzf --ansi +m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		# proceed only if a note is selected
		if ! test -z $note
			set note_dir (dirname $note)
			set is_exist (ls $note_dir | grep $new_name.md | wc -l)
			if test $is_exist -gt 0
				printf '\033[0;31merror: \033[0mnote exist with the same name\n' 
				# proceed
			else
				mv $note $note_dir/$new_name.md
				set note (echo "$note" | rev | cut -d '/' -f 1 | rev)
				printf "note name changed from \u001b[33m$note \033[0mto \u001b[33m$new_name.md \n" 
			end
		end
	else
		printf '\033[0;31merror: \033[0mnote name must be provided to rename \n' 
	end
end

function new_note_with_fzf
	notes new $DEFAULT_CATEGORY $argv
end

function notes_change_category
	if count $argv > /dev/null
		export DEFAULT_CATEGORY=$argv[1]
	else
		set fzf_preview "--preview=\"exa $NOTES_CLI_HOME/{} --icons --color always\" --preview-window bottom:sharp:wrap"
		set category (fd -t d . $NOTES_CLI_HOME | rg "$NOTES_CLI_HOME/" --replace "" --passthru |\
		rg --pcre2 "[^/]+(?=/)|(?<=/)[^/]+|[^/]+" --colors match:fg:green \
		--colors match:style:nobold --color always --passthru|\
		# rg "/" --passthru --colors match:fg:blue --colors match:style:nobold --color always|\
		env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $fzf_preview" fzf --ansi --reverse \
		--preview-window 20%)
		if ! test -z $category
			export DEFAULT_CATEGORY=$category
		end
	end
end

function remove_note 
	if count $argv > /dev/null
		set note (notes ls -A --oneline |  fzf --ansi -m -q "$argv" | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z "$note"
			mv $note $NOTES_CLI_HOME/.trash 
			printf "These files were removed\n"
			printf "\u001b[34m$note\n"
		end
	else
		set note (notes ls -A --oneline |  fzf --ansi -m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z "$note"
			mv $note $NOTES_CLI_HOME/.trash 
			printf "These files were removed\n"
			printf "\u001b[34m$note\n"
		end
	end
end

function restore_notes
	set notes_to_restore (ls -t -1 $NOTES_CLI_HOME/.trash | while read -l file; set note_name $file; set note_path (grep -r -m 1 'Category' $NOTES_CLI_HOME/.trash/$file | cut -d ' ' -f 3); printf "\u001b[33m$note_path\u001b[0m/\u001b[32m$note_name\n"; end | fzf --ansi -m | cut -d '/' -f 2 | string collect); 
	if ! test -z "$notes_to_restore" 
		echo $notes_to_restore | while read -l note 
			set category_dir (grep -r -m 1 'Category' $NOTES_CLI_HOME/.trash/$note | cut -d ' ' -f 3)
			if test -f $NOTES_CLI_HOME/$category_dir/$note
				printf '\033[0;31merror: \033[0ma note with the same name already exist :/\n' 
				echo setting restore name...
				set restore_name (echo $note | sed 's/\.md.*//' | awk '{print $0"_RESTORED.md"}') 
				mv $NOTES_CLI_HOME/.trash/$note $NOTES_CLI_HOME/$category_dir/$restore_name
				printf "\u001b[33m$category_dir\u001b[0m/\u001b[32m$note \u001b[0mrestored as \u001b[33m$category_dir\u001b[0m/\u001b[32m$restore_name\n";
			else
				mkdir -p $NOTES_CLI_HOME/$category_dir
				mv $NOTES_CLI_HOME/.trash/$note $NOTES_CLI_HOME/$category_dir   
				printf "\u001b[33m$category_dir\u001b[0m/\u001b[32m$note \u001b[0mrestored\n";
			end
		end
	end
end

function notes_hashtag_with_name_fzf
	set -l note (__get_all_notes_with_hashtag__ $argv |\
	rg "$NOTES_CLI_HOME/" --replace "" --passthru |\
	rg --pcre2 "[^/]+(?=/)" --colors match:fg:green --colors match:style:nobold --color always |\
	rg --pcre2 "(?<=/)[^/]+\.md" --color always --colors match:fg:yellow --colors match:style:nobold |\
	env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $NOTES_CLI_FZF_PREVIEW" fzf -m --ansi --reverse --preview-window hidden \
	--preview-window 70% | sed 's/\.md.*/\.md/')

	set -l selected (echo $note)
	! test -z $selected && nvim "$NOTES_CLI_HOME/"$note
end
function __get_all_notes_with_hashtag__
	if test -z $argv
		set argv "none" $argv
	end
	set -l paths (rg --pcre2 "(?<=#)([a-zA-Z0-9]|-)+|""" $NOTES_CLI_HOME -o --no-line-number --sortr $argv --heading |\
	sed '/^[[:space:]]*$/d'| rg '^..*' --replace '$0,,,'|\
	rg "/[^/]+?\.md" --replace '$0^' --passthru) \
	&& echo -e "$paths" | perl -pe 's/(,,,\s+[^,]+?\/)/\n$1/g' | rg "^,,,[ ]+|,,,\$" --replace "" --passthru |\
	rg ",,, " --replace "," --passthru | rg "\^," --replace "^" --passthru |\
	rg --pcre2 "(?<=\^).+"  --colors match:fg:white --color always --passthru \
	| column -t -s "^";
end
# Deprecated
function __get_all_notes_with_hashtag_old__
	set -l paths (rg --pcre2 "(?<=#)([a-zA-Z0-9]|-)+" $NOTES_CLI_HOME -o --no-line-number --sort modified --heading \
	--replace '$0,,,'|\
	rg "/[^/]+?\.md" --replace '$0^' --passthru) \
	&& echo -e "$paths" | perl -pe 's/(,,,\s+[^,]+?\/)/\n$1/g' | rg "^,,,[ ]+|,,,\$" --replace "" --passthru |\
	rg ",,, " --replace "," --passthru |\
	rg --pcre2 "(?<=\^).+"  --colors match:fg:white --color always | column -t -s "^";

	rg --pcre2 "(?<=#)([a-zA-Z0-9]|-)+" $NOTES_CLI_HOME --sort modified --files-without-match
end

# Deprecated
function notes_hashtag_with_name_fzf_old
	set -l note (__get_all_notes_with_hashtag_old__ | sed 's/\^,/\^/' | column -t -s '^' |\
	env FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $NOTES_CLI_FZF $NOTES_CLI_FZF_PREVIEW" fzf -m --ansi --reverse --preview-window nohidden |\
	sed 's/\.md.*/\.md/')
	set -l selected (echo $note)
	! test -z $selected && nvim -o "$NOTES_CLI_HOME/"$note
	# xargs -r -d '\n' nvim -o
end


# install fonts

function install_fonts
	if count $argv > /dev/null
		set valid_folder true
		for arg in $argv
			if test -d $arg
				if ! count (fd . $arg -t f -e ttf -e otf -d 1) > /dev/null 
					set valid_folder false
					echo "$arg folder doesn't contain any fonts(at depth 1)"
					break
				end
			else
				set valid_folder false 
				echo "$arg is not a directory"
				break
			end
		end
		if test $valid_folder = true
			sudo cp -r $argv /usr/share/fonts/truetype/
			fc-cache -f -v > /dev/null
		end
	else
		echo "no font folder giver"
	end
end

function show_not_installed_available_fonts
	set valid_fonts
	set noodle
	set font_path_store
	set not_valid
	set font_paths (dirname (fd . $HOME -t f -e ttf -e otf -d 5 | sort | uniq ) | uniq | string collect)
	set installed_font_paths (dirname (fd . /usr/share/fonts/truetype -t f -e ttf -e otf | sort | uniq ) | uniq | string collect)
	echo "$font_paths" | while read font_path; 
		set font_path_store (echo $font_path | string collect)
		echo "$installed_font_paths" | while read installed_font_path;
			set noodle (math $noodle + 1)
			if diff -x .\* -q $installed_font_path $font_path > /dev/null 
				set not_valid true
				break
			else
				set not_valid false
			end
		end
		if test $not_valid = false
			set -a valid_fonts \n$font_path_store
		end
	end
	echo $valid_fonts | sed '/^[[:space:]]*$/d' | fzf -m
end

# switch local python3 evn
function toggle_local_py_env
	if test -n "$VIRTUAL_ENV"
		deactivate
	else
		source $PYTHON_ENV3_DIR/bin/activate.fish
	end
end
function activate_local_py_env3
	source $PYTHON_ENV3_DIR/bin/activate.fish
end
function deactivate_local_py_env3
	if test -n "$VIRTUAL_ENV"
		deactivate
	end
end

function restart_shell
	exec fish -l
end
function reload_shell
	source $HOME/.config/fish/config.fish
end

# scan sy wifi for all connected devices
function scan_connected_ip_on_wifi
	set -l IP (echo $WIFI_IP | cut -d "." -f 1-3 | awk '{print $1".0/24"}')
	if count $argv > /dev/null
		nmap $argv $IP
	else
		nmap -sn $argv $IP
	end

end

# Git with FZF

function git_checkout_fzf
	set branch (git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)	
	if count $branch > /dev/null
		git checkout $branch
	end
end
function git_commits_with_fzf 
	git log --pretty=oneline --abbrev-commit --color="always"| fzf -i --no-sort --reverse --height "100%" --preview-window=right:70%:wrap --bind Shift-tab:preview-page-up,tab:preview-page-down,k:preview-up,j:preview-down --ansi --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always'
end

# Tmux functions

function tmux_create_session
	if count $argv > /dev/null
		tmux has-session -t=$argv 2> /dev/null
		if test $status -ne 0
			TMUX='' tmux new-session -d -s "$argv"
			# else
			# tmux switch-client -t "$argv"
		end
		if test -z "$TMUX"
			tmux attach -t "$argv"
		else
			tmux switch-client -t "$argv"
		end
	else
		if test -z "$TMUX"
			tmux attach -t "$DEFAULT_TMUX_SESSION"
		else
			tmux switch-client -t "$DEFAULT_TMUX_SESSION"
		end
	end
end

function tmux_kill_session
	if count $argv > /dev/null
		tmux has-session -t=$argv 2> /dev/null
		if test $status -eq 0
			tmux kill-session -t $argv
		else
			echo "no such session"
		end
	end
end

# Tmux with FZF
function tmux_sessions_fzf
	# set LIST_DATA "#{window_name} #{pane_title} #{pane_current_path} #{pane_current_command}"
	# set TARGET_SPEC "#{session_name}"

	set SESSION "$argv[1]"
	if ! count $argv > /dev/null
		if test -n "( tmux ls )"
			set SESSION (tmux ls -F "#{session_name}^#{pane_current_path}^#{pane_current_command}" | column -t -s '^'|\
			# sed 's/:.*//g' |\
			fzf --height 30% --layout=reverse --prompt "Choose session: "\
			--preview 'tmux ls'\
			--preview-window up:1 | awk '{print $1}')
			tmux switch-client -t "$SESSION" || tmux attach -t "$SESSION"
		end	
	else
		if test -z "$TMUX"
			tmux attach -t "$SESSION" || tmux new -s "$SESSION"
		else
			tmux has-session -t "$SESSION" 2> /dev/null
			if test $status -eq 0
				tmux switch-client -t "$SESSION"
			else
				set SESSION (tmux ls -F "#{session_name}^#{pane_current_path}^#{pane_current_command}" | column -t -s '^'\
				| sed 's/:.*//g' | fzf -q "$argv" --height 30% --layout=reverse --prompt "Choose session: "\
				--preview 'tmux ls'\
				--preview-window up:1 | awk '{print $1}')
				tmux switch-client -t "$SESSION"
			end

		end
	end
end

# Netbeans executable
set PATH $HOME/netbeans-8.2rc/bin $PATH

# TMUX
export DEFAULT_TMUX_SESSION="alacritty"

set PATH /usr/local/bin $PATH
# rust cargo bin
set PATH $HOME/.cargo/bin $PATH

# jenv for fish
# function jenv
# bash -i -c "jenv $argv"
# end

set -x JAVA_HOME /opt/jdk1.8.0_241 $JAVA_HOME
# set -x JAVA_HOME /opt/jdk-11.0.6 $JAVA_HOME

#Zoxide fast navigation
zoxide init fish | source


set PATH $HOME/.jenv/bin $PATH
# status --is-interactive; and source (jenv init -|psub)
# status --is-interactive; and jenv init - fish | source


#Expo CLI
# set PATH $HOME/.nvm/versions/node/v12.18.3/lib/node_modules/npm/node_modules/bin $PATH
# set PATH $HOME/.nvm/versions/node/ $PATH
set PATH $HOME/.local/share/nvm/v14.15.5/lib/node_modules/ $PATH

# Spring Boot CLI Path
# export SPRING_HOME = "$HOME/.spring-boot-cli"
set PATH $HOME/.spring-boot-cli/bin $PATH


# SBT (for playframework)
set PATH $HOME/sbt-1.4.0/sbt/bin $PATH
#JENV
# set PATH $HOME/.jenv/bin $PATH

#JDK
set PATH /opt/jdk1.8.0_241/bin $PATH
# set PATH /opt/jdk-11.0.6/bin $PATH

# set PATH for thirdparty bin
set PATH $HOME/.thirdparty-app/bin $PATH

# set PATH $HOME/.notes-cli $PATH
set PATH $HOME/go/bin $PATH

# diff-so-fancy(better diff)
set PATH $HOME/diff-so-fancy $PATH

# directory for thridparty apps
export THIRDPARTY_APP_DIR="$HOME/.thirdparty-app"
export GITHUB_APP_DIR="$THIRDPARTY_APP_DIR/github"

# virtual python env directory
export PYTHON_ENV_DIR="$HOME/.py_env"
export PYTHON_ENV3_DIR="$PYTHON_ENV_DIR/py_env3"
export PYTHON_ENV2_DIR="$PYTHON_ENV_DIR/py_env2"

set -gx EDITOR nvim
export EDITOR=nvim

export NOTES_CLI_EDITOR="nvim '+ normal G'"
export NOTES_CLI_HOME="$HOME/.notes"
export DEFAULT_CATEGORY='myNotes'

# re-check what to settle with
# export PAGER=bat
# export PAGER="most"

# Start autojump zoxide
zoxide init fish | source

# MISCELLANEOUS
# WiFi IP (i.e scanify<alias> uses)
export WIFI_IP="192.168.8.1"

# DEFAULT STYLES
# FZF styles
export FZF_DEFAULT_OPTS='--bind \?:toggle-preview --preview-window sharp --height "80%" --color hl:#a83afc,hl+:#a83afc --color prompt:166,border:#4a4a4a,bg+:#212121 --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ "'
export FORGIT_LOG_FZF_OPTS="--height 100% --no-sort --reverse --bind Shift-tab:preview-page-down,tab:preview-page-up,k:preview-up,j:preview-down -i --preview-window sharp"
export NOTES_CLI_FZF="--prompt='Select note: ' --reverse --color prompt:166,border:#4a4a4a --bind K:preview-up,J:preview-down -i"
export NOTES_CLI_FZF_PREVIEW="--preview=\"bat --color=always (echo $NOTES_CLI_HOME/(echo {} | sed 's/\.md.*//').md)\" --preview-window sharp:hidden:wrap"

# nnn file manager
export NNN_OPTS="d"
export NNN_FIFO='/tmp/nnn.fifo'
export NNN_PLUG='p:preview-tui;P:pdfview;f:fzcd;o:fzopen;D:diffs;v:imgview;z:fzz'
export NNN_BMS='i:~/Documents/IIT_L5;d:~/Downloads/'
