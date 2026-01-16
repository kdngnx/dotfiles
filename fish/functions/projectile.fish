function projectile --description "switch to a tmux session matching pattern, or create one"
    set -l pattern $argv[1]
    if test -z "$pattern"
        echo "usage: $(status basename) <pattern>"
        tree -L 3 -d "$HOME/repos" "$HOME/personal"
        return 1
    end # ensure pattern is specified

    set -l matched (tmux list-sessions 2>/dev/null | grep "$pattern")
    if test -z "$matched"
        set -l dir (find "$HOME/repos" "$HOME/personal" -maxdepth 3 -type d -iname "$pattern*" 2>/dev/null | head -n 1)
        if test -z "$dir"
            tmux display-message "no project found matching '$pattern'"
            return 0
        end

        set -l name (basename "$dir")
        tmux has-session -t "$name" 2>/dev/null
        if test $status -ne 0
            tmux new-session -s "$name" -d -c "$dir"
        end # previous command failed

        tmux switch-client -t "$name"
        return 0
    end

    # from right to left, from inner brackets to outer:
    # - split by newline, get the first part
    # - split by ':' at most 1 (-m 1)
    # - the first part is session name
    set -l session_name (string split -m 1 ":" (string split \n -- $matched)[1])[1]
    tmux switch-client -t "$session_name"
end
