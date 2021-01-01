# key-bindings
function fish_user_key_bindings
  bind \ao 'clear;'
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

# make dir if not exist and cd into
function mcd --description "mkdir if not exist and cd into"
	mkdir -p $argv[1]
	cd $argv[1]
end

# kill process
function kill_process --description "Kill processes"
	set -l __kp__pid (procs --color="always" | fzf --ansi --height '50%' -m | awk '{print $1}')
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
	youtube-dlc -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio' -c --playlist-start 1
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
		# builtin cd / && builtin cd (fd -i -t d -d 10 . . /home/bmora/.config -E /home/burhan | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
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
		set note (notes ls -A --oneline |  fzf --ansi -m -q "$argv" | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			nvim -O $note
		end
	else
		set note (notes ls -A --oneline |  fzf --ansi -m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
		if ! test -z (echo $note)
			nvim -O $note
		end
	end
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
	set notes_to_restore (ls -t -1 $NOTES_CLI_HOME/.trash | while read -l file; set note_name $file; set note_path (grep -m 1 'Category' $NOTES_CLI_HOME/.trash/$file | cut -d ' ' -f 3); printf "\u001b[33m$note_path\u001b[0m/\u001b[32m$note_name\n"; end | fzf --ansi -m | cut -d '/' -f 2 | string collect); 
	if ! test -z "$notes_to_restore" 
		echo $notes_to_restore | while read -l note 
		set category_dir (grep -m 1 'Category' $NOTES_CLI_HOME/.trash/$note | cut -d ' ' -f 3)
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
	set font_paths (dirname (fd . /home/bmora -t f -e ttf -e otf -d 5 | sort | uniq ) | uniq | string collect)
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


set PATH /usr/local/bin $PATH
# rust cargo bin
set PATH $HOME/.cargo/bin $PATH

# jenv for fish
# function jenv
# bash -i -c "jenv $argv"
# end

set JAVA_HOME /opt/jdk1.8.0_241 $JAVA_HOME

#Zoxide fast navigation
zoxide init fish | source


set PATH $HOME/.jenv/bin $PATH
# status --is-interactive; and source (jenv init -|psub)
# status --is-interactive; and jenv init - fish | source


#Expo CLI
set PATH /home/bmora/.nvm/versions/node/v12.18.3/lib/node_modules/npm/node_modules/bin $PATH

# Spring Boot CLI Path
# export SPRING_HOME = '/home/bmora/.spring-boot-cli'
set PATH /home/bmora/.spring-boot-cli/bin $PATH


# SBT (for playframework)
set PATH /home/bmora/sbt-1.4.0/sbt/bin $PATH
#JENV
set PATH /home/bmora/.jenv/bin $PATH

#JDK
set PATH /opt/jdk1.8.0_241/bin $PATH
set PATH /opt/jdk-11.0.6/bin $PATH

# set PATH /home/bmora/.notes-cli $PATH
set PATH /home/bmora/go/bin $PATH

# diff-so-fancy(better diff)
set PATH /home/bmora/diff-so-fancy $PATH

export NOTES_CLI_EDITOR=nvim
export EDITOR=nvim
export NOTES_CLI_HOME='/home/bmora/.notes'
export DEFAULT_CATEGORY='myNotes'

# FZF styles
export FZF_DEFAULT_OPTS='--height "80%" --color hl:46,hl+:46 --color prompt:166,border:32 --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ "'
# commented due to a bug: https://github.com/sharkdp/bat/issues/1413
# export PAGER=bat
# export PAGER="most"

# Start autojump zoxide
zoxide init fish | source
