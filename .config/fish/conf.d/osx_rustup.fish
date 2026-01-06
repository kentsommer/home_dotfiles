if type -q brew
    # We use a local variable to keep the namespace clean
    set -l rustup_bin (brew --prefix rustup)/bin

    if test -d "$rustup_bin"
        fish_add_path "$rustup_bin"
    end
end
