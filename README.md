# Installation

- REFERENCE: https://www.atlassian.com/git/tutorials/dotfiles
```
# Prior to the installation make sure you have committed the alias to your .bashrc/.zsh/config.fish:
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# And that your source repository ignores the folder where you'll clone it, so that you don't create weird recursion problems:
echo "dotfiles" >> .gitignore

# Now clone your dotfiles into a bare repository in a "dot" folder of your $HOME:
git clone --bare <git-repo-url> $HOME/dotfiles

# Define the alias in the current shell scope:
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Checkout the actual content from the bare repository to your $HOME:(might error at this point)
config checkout

# if error (make sure to check the script against the output previous(config checkout) command)
# since output may differ at a future time and **egrep command in the script might need a change**
fish ~/.scripts/backup-existing-dotfiles.fish 

# Set the flag showUntrackedFiles to no, on the specific (local) repo
config config --local status.showUntrackedFiles no
`
