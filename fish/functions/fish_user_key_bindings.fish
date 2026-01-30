function fish_user_key_bindings
    fish_vi_key_bindings

    bind --erase --preset ctrl-d
    bind --erase --preset -M insert ctrl-d
    bind --erase --preset -M visual ctrl-d
end
