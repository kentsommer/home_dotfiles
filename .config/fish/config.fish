###################
# VI Key Bindings #
###################
if status is-interactive
    fish_vi_key_bindings
end

#########
# Paths #
#########
fish_add_path $HOME/.local/bin

#######
# ENV #
#######
set -gx XDG_CONFIG_HOME $HOME/.config

