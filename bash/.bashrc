#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# Zoxide aliases to replace cd
eval "$(zoxide init bash)"
alias cd='z'
alias cdi='zi'  # Interactive selection
alias cda='za'  # Add current directory to zoxide database
alias cdh='z ~' # Quick home directory navigation
alias cd..='z ..'
alias cd-='z -'  # Go to previous directory

# Oh-My-Posh Config
eval "$(oh-my-posh init bash --config $HOME/.config/hypr/ohmyposh/hyprxero.omp.json)"

# Carapace Config
eval "$(carapace _carapace bash)"


# opencode
export PATH=/home/anon/.opencode/bin:$PATH
