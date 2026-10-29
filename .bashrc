# ~/.bashrc — minimal viable config

# Only run for interactive shells
[[ $- != *i* ]] && return

# BOOTSTRAP

export PATH="$HOME/.local/bin:$PATH"

# Install any missing packages with the system package manager
_mvc_install() {
    local pkgs=("$@")
    ((${#pkgs[@]})) || return 0
    echo "mvc.bash: installing ${pkgs[*]}..."
    if command -v pacman >/dev/null; then
        sudo pacman -S --needed --noconfirm "${pkgs[@]}"
    elif command -v apt-get >/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y "${pkgs[@]}"
    elif command -v dnf >/dev/null; then
        sudo dnf install -y "${pkgs[@]}"
    elif command -v zypper >/dev/null; then
        sudo zypper install -y "${pkgs[@]}"
    elif command -v brew >/dev/null; then
        pkgs=("${pkgs[@]/#bash-completion/bash-completion@2}")
        brew install "${pkgs[@]}"
    else
        echo "mvc.bash: no supported package manager, install manually: ${pkgs[*]}"
    fi
}

_mvc_missing=()
command -v lsd >/dev/null || _mvc_missing+=(lsd)
command -v tmux >/dev/null || _mvc_missing+=(tmux)
command -v rg  >/dev/null || _mvc_missing+=(ripgrep)
command -v fzf >/dev/null || _mvc_missing+=(fzf)
[[ -r /usr/share/bash-completion/bash_completion ||
   -r /etc/bash_completion ||
   -r /opt/homebrew/etc/profile.d/bash_completion.sh ||
   -r /usr/local/etc/profile.d/bash_completion.sh ]] || _mvc_missing+=(bash-completion)
_mvc_install "${_mvc_missing[@]}"
unset _mvc_missing

# Starship installs to ~/.local/bin (no sudo needed)
if ! command -v starship >/dev/null; then
    echo "mvc.bash: installing starship..."
    mkdir -p "$HOME/.local/bin"
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi

# OPTIONS

# History
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

# Shell behavior
shopt -s checkwinsize   # update LINES/COLUMNS after each command
shopt -s globstar       # ** matches recursively
shopt -s autocd         # type a dir name to cd into it
shopt -s cdspell        # fix minor typos in cd

export EDITOR=vim
export VISUAL=vim

# COMPLETION

for f in /usr/share/bash-completion/bash_completion \
         /etc/bash_completion \
         /opt/homebrew/etc/profile.d/bash_completion.sh \
         /usr/local/etc/profile.d/bash_completion.sh; do
    [[ -r $f ]] && { source "$f"; break; }
done
unset f

# Case-insensitive tab completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# FZF

if command -v fzf >/dev/null; then
    # Ctrl-T files, Ctrl-R history, Alt-C cd
    if fzf --bash >/dev/null 2>&1; then
        eval "$(fzf --bash)"
    else
        for f in /usr/share/fzf/key-bindings.bash /usr/share/fzf/completion.bash \
                 /usr/share/doc/fzf/examples/key-bindings.bash \
                 /usr/share/bash-completion/completions/fzf; do
            [[ -r $f ]] && source "$f"
        done
        unset f
    fi
    if command -v rg >/dev/null; then
        export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    fi
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
fi

# ALIASES

# ls -> lsd
if command -v lsd >/dev/null; then
    alias ls='lsd'
    alias ll='lsd -l'
    alias la='lsd -la'
    alias lt='lsd --tree --depth 2'
else
    alias ls='ls --color=auto'
    alias ll='ls -lh'
    alias la='ls -lah'
fi

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias mkdir='mkdir -p'

# Search
alias grep='grep --color=auto'
alias rgi='rg -i'

# Git
alias g='git'
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate -20'
alias gp='git push'

# Misc
alias v='vim'
alias reload='source ~/.bashrc'
alias path='echo -e "${PATH//:/\\n}"'

# Fuzzy-open a file in vim / cd into a dir
fv() { local f; f=$(fzf --preview 'head -100 {}') && vim "$f"; }
fcd() { local d; d=$(find . -type d -not -path '*/.git*' 2>/dev/null | fzf) && cd "$d"; }

# PROMPT

command -v starship >/dev/null && eval "$(starship init bash)"

# Machine-specific overrides
[[ -r ~/.bashrc.local ]] && source ~/.bashrc.local
