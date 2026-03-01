set -gx fish_greeting "It's $(date '+%A, %B %d, %Y at %H:%M') - bugs don't fix themselves. Or do they?"
if status is-interactive
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
    set -gx XDG_CACHE_HOME "$HOME/.cache"

    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
    set -gx PATH "$HOME/.local/bin" $PATH

    set __fish_git_prompt_showdirtystate 'yes'
    set __fish_git_prompt_showstashstate 'yes'
    set __fish_git_prompt_showupstream 'yes'

    alias vi=nvim
    alias myip='echo (dig +short txt ch whoami.cloudflare @1.0.0.1)'
end
