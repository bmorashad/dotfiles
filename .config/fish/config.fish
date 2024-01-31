# IMPORTANT
# fd
# NOTE: echo "You may want to use fd with -I and -H flag to search for jar/war/etc files"
# rg
# NOTE: echo "You may want to use fd with --no-ignore and --hidden flag to search for jar/war/etc files"
#
set store "$HOME/.config/fish/store"

function svg_to_png
    if test (count $argv) -eq 2
        magick -background none $argv[1] -channel RGB $argv[2]
    else if test (count $argv) -gt 2
        echo "ERROR: You must only provide input file and output file"
    else
        echo "ERROR: You must provide both input file and output file"
    end
end

function trash
    mkdir -p ~/.trash
    if test "$argv[1]" = ls
        ls ~/.trash
        return
    end
    if test "$argv[1]" = clear
        set clear (ls ~/.trash | fzf -m --reverse)
        rm -rf ~/.trash/$clear
        echo cleared "~"/.trash/$clear
        return
    end
    mv $argv ~/.trash
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
    if ! test -z (echo $TODO)
        for todo in $TODO
            echo "[TODO]: $todo" | rg "\[TODO\]" --color always --colors match:bg:blue --colors match:fg:white --passthru | rg ":" --color always --colors match:fg:blue --passthru
            echo
        end
    end
    # Tempory delete once done or when You have no idea what this is
    # echo  'grafana-sso/dashboard --> regex-w.o-iframe/query/grafana-sso' | \
    # rg "\-->" --colors match:fg:green --color always | rg "\w.*" --colors match:fg:blue
    # echo 'grafana-sso/dashboard --> regex/query/grafana-sso' | \
    # rg "\-->" --colors match:fg:green --color always | rg "\w.*" --colors match:fg:blue
    # echo  'grafana-sso/dashboard --> puppeteer/query/grafana-sso' | \
    # rg "\-->" --colors match:fg:green --color always | rg "\w.*" --colors match:fg:blue
    # echo

    # echo 'api/grafana/analytics-mgt' | \
    # rg "\w.*" --colors match:fg:blue
    # echo 'api/master/grafana/analytics-mgt' | \
    # rg "\w.*" --colors match:fg:blue
    # echo 'revert/feature/no/sync/ui/sp-apps' | \
    # rg "\w.*" --colors match:fg:blue
    # echo
end

set TODO
function tdo
    set content (echo "$argv")
    set -a TODO $content
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
    if count $argv >/dev/null
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
    # https http://slmuslims.com | rg "(\d{1,}\s*:\s*\d{2}\s*(am|pm))|id\s*=\s*\"\s*(fajr|sunrise|luhar|asar|magrib|ishah)\s*\"" \
    # --replace '$1$3' -o | tr '\n' '|' | rg  "([a|p]m)\s*\|" --replace '$1|||' | sed 's/|||/\n/g' | sed -e "s/\(^\w\)/\u\1/g" \
    # | rg '(\D)(\d{1}:)' --replace '$1,0$2' --passthru | sed 's/,//g' | column -t -s '|' | \
    # rg '^\w+' --colors 'match:fg:cyan' --color always| rg '\d{1,}:.*' --colors 'match:fg:blue'

    set curr_date (date '+%m-%d-%Y')
    if count $argv >/dev/null
        set curr_date $argv[1]
    end
    # Get prayer times
    set prayer_times (http --form POST http://www.slmuslims.com/index.php \
                Content-Type:application/x-www-form-urlencoded \
                cookie:14ccc78b2c2f38ca6d23b656cfb3aa86=1dj0c3r209q3ufufckcjpacai4 \
                option=com_prayertime \
                task=getPrayerTimes \
                format=json \
                args=$curr_date \
              --body | sed 's/]//g' | sed 's/\[//g' | sed 's/,/\n/g' | sed 's/"//g')

    set prayers Fajr Sunrise Luhar Asr Maghrib Isha
    echo DATE: $curr_date
    echo
    set i 1
    for time in $prayer_times
        echo "$prayers[$i]|$time"
        set i (math $i + 1)
    end | sed '$ d' | column -t -s \| | rg '^\w+' --colors 'match:fg:cyan' --color always | rg '\d{1,}:.*' --colors 'match:fg:blue'
end

function store_prayer_times
    set store_loc "$store/prayer/times.txt"
    if count $argv >/dev/null
        prayer $argv[1] >>$store_loc
    else
        prayer >$store_loc
    end
    echo >>$store_loc
end

function store_prayer_times_for_month
    set curr_date (date "+%m-%d-%Y")
    set date_default_form (date "+%Y-%m-%d")

    for i in (seq 1 31)
        store_prayer_times $curr_date
        echo Prayer times saved successfully for $curr_date
        set curr_date (date "+%m-%d-%Y" -d "+$i day $date_default_form")
    end
end

# alias func to find binary files after installation
function find_binary
    fd -H -t f . / | rg "$argv[1]\$"
end



# make dir if not exist and cd into
function mcd --description "mkdir if not exist and cd into"
    mkdir -p $argv[1]
    cd $argv[1]
end

# GIT

function gdiff_file
    git diff --name-only $argv[1] | fzf -m | xargs -ro git diff $argv[1]
end

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
    if count $argv >/dev/null
        # fd -e $argv[1] -0 | xargs -0 -r cat >> copied.txt
        fd -e $argv[1] -X cat >>copied.txt
    else
        # fd -t f -0 | xargs -0 -r cat >> copied.txt
        fd -t f -X cat >>copied.txt
    end
end

# eopkg with fzf
function install_with_fzf
    # if arguments passed(i.e install_with_fzf neovim)
    if count $argv >/dev/null
        # if last argument contains '-'(dash) in it(i.e install_with_fzf neovim -e)
        if test (expr substr $argv[-1] 1 1) = -
            # if so pass the last argument(with the dash) to fzf command as an argument and remaining args to eopkg search
            eopkg search $argv[1..-2] | fzf --ansi -m -0 $argv[-1] --height '30%' | awk '{print $1}' | xargs -o -r sudo eopkg it
        else
            # else pass the all args to eopkg search
            eopkg search $argv | fzf --ansi -m -0 --height '30%' | awk '{print $1}' | xargs -o -r sudo eopkg it
        end
        # if no arguments passed(i.e install_with_fzf)
    else
        # eopkg la | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
        eopkg la | fzf --ansi -m --height '30%' | awk '{print $1}' | xargs -o -r sudo eopkg it
    end
    # eopkg search $argv | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
    # Begin test Test

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
    if count $argv >/dev/null
        eopkg la | fzf --ansi -m -q "$argv"
    else
        eopkg la | fzf --ansi -m
    end
end

# fzf  shortcuts
function open_with_fzf
    builtin cd $HOME && fd -t f -d 6 | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-
end

function nvi_with_fzf
    set -l curr_dir (pwd)
    builtin cd && fd -i -d 6 -t f | fzf -i -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" nvim 2>&-
    cd $curr_dir
end

function cd_with_fzf
    if count $argv >/dev/null
        builtin cd $HOME && builtin cd (fd -i -t d -d 10 | fzf -q "$argv" --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    else
        # builtin cd / && builtin cd (fd -i -t d -d 10 . . $HOME/.config -E /home/burhan | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
        builtin cd $HOME && builtin cd (fd -i -t d -d 10 | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    end
end

function ad_with_fzf
    if count $argv >/dev/null
        builtin cd $HOME && builtin cd (fd -H -i -t d -E .cache -E Games | fzf -q "$argv[1]" $argv[2..-1] --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    else
        builtin cd $HOME && builtin cd (fd -H -i -t d -E .cache -E Games | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    end
end

function rd_with_fzf
    if count $argv >/dev/null
        builtin cd / && builtin cd (fd -i -t d -H -E /home | fzf -q "$argv[1]" $argv[2..-1] --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    else
        builtin cd / && builtin cd (fd -i -t d -H -E /home | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)
    end
end


# Notes With FZF

function preview_note_with_fzf
    if count $argv >/dev/null
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
    if count $argv >/dev/null
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
        | rg "/[^/]+.md" --passthru --colors match:fg:yellow --colors match:style:nobold --color=always | rg "$NOTES_CLI_HOME/" --replace "" | fzf -m --bind "change:reload:rg {q} $NOTES_CLI_HOME \
	-l --smart-case --color=always --colors path:fg:green | rg '/[^/]+.md' --passthru \
	--colors match:fg:yellow --colors match:style:nobold --color=always | sed 's/\/home\/bmora\/.notes\///' ||true" \
        --ansi --phony --query "" --layout=reverse \
        --prompt 'regex: ' \
        --preview "rg {q} $NOTES_CLI_HOME/{} --smart-case --color=always --context 5 | bat --style plain --color always -l md" \
        --preview-window sharp:wrap:right:65% --bind J:preview-down,K:preview-up --color prompt:166,border:#4a4a4a \
        --border sharp | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0}' | xargs -r -d '\n' nvim -O
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
    if count $argv >/dev/null
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
                printf "note name changed from \u001b[33m$note \033[0mto \u001b[33m$new_name.md\033[0m \n"

                sed -i "1s/.*/$new_name/" $note_dir/$new_name.md
                # remove '.md' from note file name for better printing
                set note (echo "$note" | rg "\.md" --replace "")
                printf "note heading changed from \u001b[33m$note \033[0mto \u001b[33m$new_name \n"
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
    if count $argv >/dev/null
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
    if count $argv >/dev/null
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
    set notes_to_restore (ls -t -1 $NOTES_CLI_HOME/.trash | while read -l file; set note_name $file; set note_path (grep -r -m 1 'Category' $NOTES_CLI_HOME/.trash/$file | cut -d ' ' -f 3); printf "\u001b[33m$note_path\u001b[0m/\u001b[32m$note_name\n"; end | fzf --ansi -m | cut -d '/' -f 2 | string collect)
    if ! test -z "$notes_to_restore"
        echo $notes_to_restore | while read -l note
            set category_dir (grep -r -m 1 'Category' $NOTES_CLI_HOME/.trash/$note | cut -d ' ' -f 3)
            if test -f $NOTES_CLI_HOME/$category_dir/$note
                printf '\033[0;31merror: \033[0ma note with the same name already exist :/\n'
                echo setting restore name...
                set restore_name (echo $note | sed 's/\.md.*//' | awk '{print $0"_RESTORED.md"}')
                mv $NOTES_CLI_HOME/.trash/$note $NOTES_CLI_HOME/$category_dir/$restore_name
                printf "\u001b[33m$category_dir\u001b[0m/\u001b[32m$note \u001b[0mrestored as \u001b[33m$category_dir\u001b[0m/\u001b[32m$restore_name\n"
            else
                mkdir -p $NOTES_CLI_HOME/$category_dir
                mv $NOTES_CLI_HOME/.trash/$note $NOTES_CLI_HOME/$category_dir
                printf "\u001b[33m$category_dir\u001b[0m/\u001b[32m$note \u001b[0mrestored\n"
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
        set argv none $argv
    end
    set -l paths (rg --pcre2 "(?<=#)([a-zA-Z0-9]|-)+|""" $NOTES_CLI_HOME -o --no-line-number --sortr $argv --heading |\
	sed '/^[[:space:]]*$/d'| rg '^..*' --replace '$0,,,'|\
	rg "/[^/]+?\.md" --replace '$0^' --passthru) \
        && echo -e "$paths" | perl -pe 's/(,,,\s+[^,]+?\/)/\n$1/g' | rg "^,,,[ ]+|,,,\$" --replace "" --passthru | rg ",,, " --replace "," --passthru | rg "\^," --replace "^" --passthru | rg --pcre2 "(?<=\^).+" --colors match:fg:white --color always --passthru \
        | column -t -s "^"
end
# Deprecated
function __get_all_notes_with_hashtag_old__
    set -l paths (rg --pcre2 "(?<=#)([a-zA-Z0-9]|-)+" $NOTES_CLI_HOME -o --no-line-number --sort modified --heading \
	--replace '$0,,,'|\
	rg "/[^/]+?\.md" --replace '$0^' --passthru) \
        && echo -e "$paths" | perl -pe 's/(,,,\s+[^,]+?\/)/\n$1/g' | rg "^,,,[ ]+|,,,\$" --replace "" --passthru | rg ",,, " --replace "," --passthru | rg --pcre2 "(?<=\^).+" --colors match:fg:white --color always | column -t -s "^"

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
    if count $argv >/dev/null
        set valid_folder true
        for arg in $argv
            if test -d $arg
                if ! count (fd . $arg -t f -e ttf -e otf -d 1) >/dev/null
                    set valid_folder false
                    echo "$arg folder doesn't contain any fonts (at depth 1)"
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
            fc-cache -f -v >/dev/null
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
    echo "$font_paths" | while read font_path
        set font_path_store (echo $font_path | string collect)
        echo "$installed_font_paths" | while read installed_font_path
            set noodle (math $noodle + 1)
            if diff -x .\* -q $installed_font_path $font_path >/dev/null
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

# add pyenv

# change golang version
function go18
    set PATH $HOME/sdk/go1.18/bin $PATH
end

function go20
    set PATH /usr/bin $PATH
end

# NOTE: old func uses virtualenv while it's in the process of replacing it with pyenv
# Removing virtualenv ATM is a problem since pyenv deactivate function doesn't undo the prompt change
# Hence must depend on virtualenv deactivate function for that

# pyenv helpers
function pyactivate
    pyenv activate $argv
    source $PYENV_ROOT/versions/$argv/bin/activate.fish
end
function pydeactivate
    source $PYENV_ROOT/versions/$argv/bin/activate.fish
    deactivate
    pyenv deactivate
end


# switch local python3 evn
function toggle_local_py_env
    if test -n "$VIRTUAL_ENV"
        pydeactivate
    else
        pyenv activate py3_env
        source $PYENV_ROOT/versions/py3_env/bin/activate.fish
    end
end

# NOTE: old func uses virtualenv while it's in the process of replacing it with pyenv
function toggle_local_py_env_old
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
    if count $argv >/dev/null
        nmap $argv $IP
    else
        nmap -sn $argv $IP
    end

end

# Git with FZF

function git_checkout_fzf
    set branch (git for-each-ref refs/heads/ --format='%(refname:short)' | fzf)
    if count $branch >/dev/null
        git checkout $branch
    end
end
function git_commits_with_fzf
    git log --pretty=oneline --abbrev-commit --color="always" | fzf -i --no-sort --reverse --height "100%" --preview-window=right:70%:wrap --bind Shift-tab:preview-page-up,tab:preview-page-down,k:preview-up,j:preview-down --ansi --preview 'echo {} | cut -f 1 -d " " | xargs git show --color=always'
end

# Tmux functions

function tmux_create_session
    if count $argv >/dev/null
        tmux has-session -t=$argv 2>/dev/null
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
    if count $argv >/dev/null
        tmux has-session -t=$argv 2>/dev/null
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
    if ! count $argv >/dev/null
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
            tmux has-session -t "$SESSION" 2>/dev/null
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

# kill process
function kill_process --description "Kill processes"
    if test "$argv" != ""
        echo $argv | xargs -p kill -9
    else
        set -l __kp__pid (ps aux | fzf --ansi --height '50%' -m | awk '{print $2}')
        # set -l __kp__pid (procs --color="always" | fzf --ansi --height '50%' -m | awk '{print $1}')

        if test "$__kp__pid" != ""
            # kill_process
            echo $__kp__pid | xargs -p kill -9
        end
    end
end


# List Listening Ports
function lport
    sudo ss -tulnp | grep LISTEN
end

# fzf kill Listening Ports
function kill_lport
    set -l listening_procs (sudo ss -tulnp | grep LISTEN)
    if test "$listening_procs" != ""
        begin
            for x in $listening_procs
                echo $x
            end
        end | fzf --ansi --height '50%' -m | rg '(pid=)(\d+)(,)' --replace '$2' -o | xargs -p -r kill -9
    end
end

function cpip
    # ip addr show | grep inet | grep -v '127.0.0.1' | awk '{print $2}' | cut -d/ -f1
    set ip (ip route get 1 | awk '{print $7}')
    echo $ip
    echo $ip | xclip -r -selection clipboard
end

# docker remove none images
function drmi_none
    # set -l removed_none_img (docker rmi (docker images -f 'dangling=true' -q))
    # echo $removed_none_img | rg must
    docker_rmi_none
end

# delete containers fzf
function drm
    docker rm (docker ps -a | tail -n +2 | fzf -m --height=30% $argv | awk '{print $1}')
end

# delete images fzf
function drmi
    docker rmi (docker images | tail -n +2 | fzf -m --height=30% $argv | awk '{print $3}')
end

# docker release
function dockrelease
    set dockFile $argv[3]
    if ! test -z $dockFile
        set dockFile Dockerfile
    end
    docker build -f $argv[3] $argv[4..-1] -t $argv[1] . && docker tag $argv[1] $argv[2] && docker push $argv[1]
end

# copy pod name to clipboard FZF
function cppod
    kubectl get pods $argv | tail -n +2 | fzf | awk '{print $1}' | xclip -r -selection clipboard
end

# k8s
function cping
    kubectl get ing -A | tail -n +2 | fzf | awk '{print $5}' | xclip -r -selection clipboard
end
function cpsvc
    kubectl get svc -A | tail -n +2 | fzf | awk '{print $5":"$6}' | rg ":\d{5}/TCP.*" -r "" | xclip -r -selection clipboard
end


# helper
function echo_output_var

end

# git annoying helper
function remove_large_file_from_git
    git filter-branch -f --tree-filter "rm -f $argv" HEAD --all
end

# Entgra functions
source $HOME/.config/fish/entgra.fish

# Netbeans executable
set PATH $HOME/netbeans-8.2rc/bin $PATH
# IntelliJ Community executable
set PATH $HOME/Downloads/IntelliJ.Community/ideaIC-2021.2.2/idea-IC-212.5284.40/bin $PATH

# set go 1.18 as default
# set PATH $HOME/sdk/go1.18/bin $PATH

# set go <latest> as default
set PATH /usr/bin $PATH



# TMUX
export DEFAULT_TMUX_SESSION="alacritty"

set PATH /usr/local/bin $PATH
# rust cargo bin
set PATH $HOME/.cargo/bin $PATH
# local bin
set PATH $HOME/.local/bin $PATH

# jenv for fish
# function jenv
# bash -i -c "jenv $argv"
# end

#Zoxide fast navigation
zoxide init fish | source


set PATH $HOME/.jenv/bin $PATH
# status --is-interactive; and source (jenv init -|psub)
# status --is-interactive; and jenv init - fish | source


#Expo CLI
# set PATH $HOME/.nvm/versions/node/v12.18.3/lib/node_modules/npm/node_modules/bin $PATH
# set PATH $HOME/.nvm/versions/node/ $PATH
set PATH $HOME/.local/share/nvm/v20.11.0/bin $PATH
set PATH $HOME/.local/share/nvm/v20.11.0/lib/node_modules/ $PATH

# Spring Boot CLI Path
# export SPRING_HOME = "$HOME/.spring-boot-cli"
set PATH $HOME/.spring-boot-cli/bin $PATH


# SBT (for playframework)
set PATH $HOME/sbt-1.4.0/sbt/bin $PATH

# Gcloud
set PATH /usr/share/google-cloud-sdk/bin $PATH
# Gcloud
set PATH ~/.thirdparty-app/gcp/google-cloud-sdk/bin $PATH

#k9s
set PATH /snap/k9s/155/bin $PATH
set PATH /snap/bin $PATH


#linkerd
set PATH ~/.linkerd2/bin $PATH
#isitio
# set PATH ~/.thirdparty-app/internet/istio-1.19.3/bin $PATH
set PATH ~/.thirdparty-app/internet/istio-1.20.0/bin $PATH
#vegeta testing tool
set PATH ~/.thirdparty-app/internet/vegeta $PATH

# xremap (keyboard remapper, Rust alternative to AutoKey)
set PATH $THIRDPARTY_APP_DIR/github/xremap $PATH

#JENV
# set PATH $HOME/.jenv/bin $PATH

# #JDK
set PATH /opt/java/jdk1.8.0_391/bin $PATH
# set PATH /opt/jdk1.8.0_241/bin $PATH
# # set PATH /opt/jdk-11.0.6/bin $PATH
#
set -x JAVA_HOME /opt/java/jdk1.8.0_391 $JAVA_HOME
# set -x JAVA_HOME /opt/jdk-11.0.6 $JAVA_HOME


# # set PATH for thirdparty bin
set PATH $HOME/.thirdparty-app/bin $PATH
#
# # set PATH $HOME/.notes-cli $PATH
set PATH $HOME/go/bin $PATH
#
# # diff-so-fancy(better diff)
# set PATH $HOME/diff-so-fancy $PATH
#
# # directory for thridparty apps
export THIRDPARTY_APP_DIR="$HOME/.thirdparty-app"
export GITHUB_APP_DIR="$THIRDPARTY_APP_DIR/github"
#
# # virtual python env directory
export PYTHON_ENV_DIR="$HOME/.py_env"
export PYTHON_ENV3_DIR="$PYTHON_ENV_DIR/py_env3"
export PYTHON_ENV2_DIR="$PYTHON_ENV_DIR/py_env2"
#
# #pyenv
# # export PYENV_ROOT="$THIRDPARTY_APP_DIR/github/pyenv"
# # set PATH $PYENV_ROOT/bin $PATH
# # pyenv init - | source
#
pyenv init - | source


# set -gx EDITOR nvim
export EDITOR=nvim
# # sudoedit
export VISUAL=nvim
export SUDO_EDITOR=nvim
#
export NOTES_CLI_EDITOR="nvim '+ normal G'"
export NOTES_CLI_HOME="$HOME/.notes"
export DEFAULT_CATEGORY='myNotes'
#
# # re-check what to settle with
# # export PAGER=bat
# # export PAGER="most"
#
# # Start autojump zoxide
# zoxide init fish | source
#
# # MISCELLANEOUS
# # WiFi IP (i.e scanify<alias> uses)
# export WIFI_IP="192.168.8.1"
#
# # DEFAULT STYLES
# # FZF styles
export FZF_DEFAULT_OPTS='--reverse --bind \?:toggle-preview --preview-window sharp --height "80%" --color hl:#a83afc,hl+:#a83afc --color prompt:166,border:#4a4a4a,bg+:#212121 --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ "'
# export FORGIT_LOG_FZF_OPTS="--height 100% --no-sort --reverse --bind Shift-tab:preview-page-down,tab:preview-page-up,k:preview-up,j:preview-down -i --preview-window sharp"
# export FORGIT_FZF_DEFAULT_OPTS=' --exact --border --cycle --reverse --height "80%" --prompt="➤  " --pointer="➤ " --marker="➤ " --bind Shift-tab:preview-page-down,tab:preview-page-up,k:preview-up,j:preview-down'
export NOTES_CLI_FZF="--prompt='Select note: ' --reverse --color prompt:166,border:#4a4a4a --bind K:preview-up,J:preview-down -i"
export NOTES_CLI_FZF_PREVIEW="--preview=\"bat --color=always (echo $NOTES_CLI_HOME/(echo {} | sed 's/\.md.*//').md)\" --preview-window sharp:hidden:wrap"
#
# # nnn file manager
# export NNN_OPTS="d"
# export NNN_FIFO='/tmp/nnn.fifo'
# export NNN_PLUG='p:preview-tui;P:pdfview;f:fzcd;o:fzopen;D:diffs;v:imgview;z:fzz'
# export NNN_BMS='i:~/Documents/IIT_L5;d:~/Downloads/'
#
# # run below line to set default nvm version
# # set --universal nvm_default_version v16
#
# # The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/bmora/.thirdparty-app/gcloud/google-cloud-sdk/path.fish.inc' ]
    . '/home/bmora/.thirdparty-app/gcloud/google-cloud-sdk/path.fish.inc'
end


# export GOPROXY="https://nexus.mytaxi.lk/repository/go-group/"
export GO111MODULE=on
export GONOSUMDB="git.mytaxi.lk/*"
export GOPRIVATE="git.mytaxi.lk/*"

# PickMe
export ETCD_CONF_NODES="10.120.51.196:2379"
export ETCD_CONF_PASS="MjkqP53D"
export ETCD_CONF_USER="delivery-reader-protected"

# elastic
export ELASTIC_PASSWORD="S*AynOntKN6KUA5=rasv"
export ELASTIC_OTHER_TOKEN="eyJ2ZXIiOiI4LjExLjMiLCJhZHIiOlsiMTcyLjI4LjAuMjo5MjAwIl0sImZnciI6IjljN2QyNWIyNmVlNzA2MTgyMWIyMjEzMjQ1YmQ0MzJjZDMxMjkzN2M5NDYxYjZjNzkzM2JhMzJhNjk1MjZkMzEiLCJrZXkiOiJMRmFENkl3QllMakx4QWVia0dySDpZX1hEdWNSbVR0U0JVYWZ4YjI1OVhBIn0="
export ELASTIC_KIBANA_TOKEN="eyJ2ZXIiOiI4LjExLjMiLCJhZHIiOlsiMTcyLjI4LjAuMjo5MjAwIl0sImZnciI6IjljN2QyNWIyNmVlNzA2MTgyMWIyMjEzMjQ1YmQ0MzJjZDMxMjkzN2M5NDYxYjZjNzkzM2JhMzJhNjk1MjZkMzEiLCJrZXkiOiJLbGFENkl3QllMakx4QWVia0dyRTp4ZE9pR1p4eFNYeW9TNzhCTjN1eC1RIn0="

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/rashad/.thirdparty-app/gcp/google-cloud-sdk/path.fish.inc' ]
    . '/home/rashad/.thirdparty-app/gcp/google-cloud-sdk/path.fish.inc'
end
kubectl completion fish | source
