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

# GIT

function fco -d "Fuzzy-find and checkout a branch"
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
end

function fcoc -d "Fuzzy-find and checkout a commit"
  git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end

# eopkg with fzf
function install_with_fzf 
  if count $argv > /dev/null
    # eopkg search $argv | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
    eopkg search $argv | fzf --ansi -m | awk '{print $1}' | xargs -o -r sudo eopkg it;
  else
    # eopkg la | fzf --ansi -m | awk '{print $1}' | tr '\n' ' ' | xargs -r sudo eopkg it $argv;
    eopkg la | fzf --ansi -m | awk '{print $1}' | xargs -o -r sudo eopkg it;
  end
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
  builtin cd $HOME && fd -a -t f -H -I | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-;
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
        printf '\033[0;31mError: \033[0mnote exist with the same name\n' 
      # proceed
      else
        mv $note $note_dir/$new_name.md
        set note (echo "$note" | rev | cut -d '/' -f 1 | rev)
        printf "note name changed from \u001b[33m$note \033[0mto \u001b[33m$new_name.md \n" 
      end
    end
  else
    printf '\033[0;31mError: \033[0mnote name must be provided to rename \n' 
  end
end

function new_note_with_fzf
  notes new myNotes $argv
end

function remove_note 
  if count $argv > /dev/null
    set note (notes ls -A --oneline |  fzf --ansi -m -q "$argv" | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
    if ! test -z "$note"
      mv $note $NOTES_CLI_HOME/.trash 
    end
  else
    set note (notes ls -A --oneline |  fzf --ansi -m | sed 's/\.md.*//' | awk -v notes_path="$NOTES_CLI_HOME/" '{print notes_path $0".md"}')
    if ! test -z "$note"
      mv $note $NOTES_CLI_HOME/.trash 
    end
  end
end

function restore_notes
  set notes_to_restore (ls -t -1 $NOTES_CLI_HOME/.trash | while read -l file; set note_name $file; set note_path (grep -m 1 'Category' $NOTES_CLI_HOME/.trash/$file | cut -d ' ' -f 3); printf "\u001b[33m$note_path\u001b[0m/\u001b[32m$note_name\n"; end | fzf --ansi -m | cut -d '/' -f 2 | string collect); 
  if ! test -z "$notes_to_restore" 
    echo $notes_to_restore | while read -l note 
    set category_dir (grep -m 1 'Category' $NOTES_CLI_HOME/.trash/$note | cut -d ' ' -f 3)
    mv $NOTES_CLI_HOME/.trash/$note $NOTES_CLI_HOME/$category_dir   
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


# jenv for fish
function jenv
  bash -i -c "jenv $argv"
end

function nvm
  bash -i -c "nvm $argv"
end


set JAVA_HOME /opt/jdk1.8.0_241


# set PATH $HOME/.jenv/bin $PATH
# status --is-interactive; and source (jenv init -|psub)
# status --is-interactive; and jenv init - fish | source

set PATH /home/bmora/.notes-cli $PATH
export NOTES_CLI_EDITOR=nvim
export EDITOR=nvim
export NOTES_CLI_HOME='/home/bmora/.notes'
