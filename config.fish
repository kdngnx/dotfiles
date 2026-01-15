if status is-interactive
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    set -gx XDG_DATA_HOME "$HOME/.local/share"
    set -gx XDG_CACHE_HOME "$HOME/.cache"
    set -gx RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"

    set -gx EDITOR nvim
    set -gx VISUAL nvim

    set -gx PATH "$HOME/.local/bin" $PATH
    # SDL_VIDEO_DRIVER=wayland SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY=1

    alias vi=nvim
    alias myip="echo (dig +short txt ch whoami. cloudflare @1.0.0.1)"
end
