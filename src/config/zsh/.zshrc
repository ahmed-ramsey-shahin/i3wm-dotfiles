# Custom functions
tmux_session_create() {
    tmux new-session -d -s $1 -n main $1
}

y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

add_github_repo() {
    git remote set-url origin "git@github.com:ahmed-ramsey-shahin/${1}.git"
}

startup() {
    # neofetch
    # figlet Hi
}

# Run tmux at startup
if command -v tmux &> /dev/null && [[ -o interactive ]] && [[ ! "$TERM" =~ screen || tmux ]] && [ -z "$TMUX" ]; then
    if tmux attach-session -t default 2>/dev/null; then
        exit
    else
        exec tmux new-session -s default
    fi
fi

# Run ufetch at startup
startup

# Configure p10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Initialize zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Install plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# auto start apps
autoload -U compinit && compinit
zinit cdreplay -q

# key bindings
bindkey '^n' history-search-forward
bindkey '^p' history-search-backward

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completions styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='lsd --icon always --color always'
alias cls='clear;startup'
alias clc='clear;startup'
alias c='clear;startup'
alias vi='nvim'
alias vim='nvim'
alias v='nvim'
alias cat='bat'
alias lg='lazygit'
alias modelsim='~/intelFPGA/20.1/modelsim_ase/bin/vsim'
alias cdwm="nvim ~/suckless/dwm/config.h"
alias mdwm="cd ~/suckless/dwm; sudo make clean install; cd -"

# Shell integration
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval $(thefuck --alias)

export QSYS_ROOTDIR="/home/graph_seeker/.cache/yay/quartus-free/pkg/quartus-free-quartus/opt/intelFPGA/24.1/quartus/sopc_builder/bin"
export PATH="/home/graph_seeker/.my_scripts":$PATH
export PATH="/home/graph_seeker/.apps/questasim/questasim/linux_x86_64":$PATH
export PATH="/home/graph_seeker/.apps/questasim/questasim/RUVM_2021.2":$PATH
export PATH="/home/graph_seeker/Xilinx/2025.1/Vivado/bin":$PATH
export PATH=$HOME/.local/bin:$PATH
export LM_LICENSE_FILE="/home/graph_seeker/.apps/questasim/questasim/license.dat":$LM_LICENSE_FILE

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
