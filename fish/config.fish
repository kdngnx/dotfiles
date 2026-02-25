set fish_greeting
if status is-interactive
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
    set -gx XDG_CACHE_HOME "$HOME/.cache"

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
    set -gx PATH "$HOME/.local/bin" $PATH

    abbr -a -- - 'cd -'
    abbr -a -- gs 'git status'
    abbr -a -- gco 'git checkout'
    abbr -a -- gd 'git diff'
    abbr -a -- gf 'git fetch'
    abbr -a -- gp 'git pull'
    abbr -a -- ga 'git add'
    abbr -a -- gaa 'git add --all'
    abbr -a -- gap 'git add --patch'
    abbr -a -- gc 'git commit -m'
    abbr -a -- gss 'git stash save'
    abbr -a -- gsp 'git stash pop'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end
