#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\e[32m[\u@\h \W]\$ \e[m'

# commands
alias ls="ls -lha --color"
alias src-fish="source ~/.config/fish/config.fish"
alias conf-fish="cd ~/.config/fish/"
alias de="setxkbmap -layout de"
alias us="setxkbmap -layout us"
alias es="setxkbmap -layout es"
alias aliases="mrepos && cat configs/aliases.md && cd"

# navigation
alias mrepos="cd ~/docs/mrepos"
alias repos="cd ~/docs/repos"
alias downloads="cd ~/downloads"
alias docs="cd ~/docs"

# anki
alias resize="cd ~/docs/anki-images && convert image.jpg -resize 300x300"

# git
alias gac="git add . && git commit -m"
alias gstatus="git status"
alias gremotes="git remote -v"
alias gbranches="git branch"
alias gtree="git log --pretty=oneline --graph --decorate --all"
alias gpush="git push origin"
alias gpull="git pull origin"

alias connect="ssh -p 65002 u580315149@185.211.7.154"
alias anki="anki --no-sandbox &"

PATH=$PATH:~/docs/mrepos/mrepos/commands/:~/docs/mrepos/suckless-configs/barscripts/
