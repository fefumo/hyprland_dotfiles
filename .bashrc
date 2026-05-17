#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Source - https://stackoverflow.com/a/70679581
# Posted by SylvainB
# Retrieved 2026-05-17, License - CC BY-SA 4.0
havei() {
  package=$1
  if $(pacman -Qi $package &>/dev/null); then
    echo -e "\e[92m[ 🗸 ] $package is installed \e[39m"
  else
    echo -e "\e[91m[ ❌ ] $package is not installed \e[39m"
  fi
}

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Move to the parent folder.
alias ..='cd ..;pwd'

# Move up two parent folders.
alias ...='cd ../..;pwd'

# Move up three parent folders.
alias ....='cd ../../..;pwd'

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
