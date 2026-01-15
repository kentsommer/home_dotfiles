# Check if FZF_DEFAULT_OPTS is already set to avoid leading whitespace
if set -q FZF_DEFAULT_OPTS
    set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS \
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:-1 \
      --color=bg:-1 \
      --color=gutter:-1 \
      --color=spinner:#F5E0DC \
      --color=hl:#F38BA8 \
      --color=fg:#CDD6F4 \
      --color=header:#CDD6F4 \
      --color=info:#CDD6F4 \
      --color=pointer:#F5E0DC \
      --color=marker:#B4BEFE \
      --color=fg+:#CDD6F4 \
      --color=prompt:#CBA6F7 \
      --color=hl+:#F38BA8 \
      --color=selected-bg:#45475A \
      --color=border:#6C7086 \
      --color=label:#CDD6F4"
else
    set -gx FZF_DEFAULT_OPTS "\
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:-1 \
      --color=bg:-1 \
      --color=gutter:-1 \
      --color=spinner:#F5E0DC \
      --color=hl:#F38BA8 \
      --color=fg:#CDD6F4 \
      --color=header:#CDD6F4 \
      --color=info:#CDD6F4 \
      --color=pointer:#F5E0DC \
      --color=marker:#B4BEFE \
      --color=fg+:#CDD6F4 \
      --color=prompt:#CBA6F7 \
      --color=hl+:#F38BA8 \
      --color=selected-bg:#45475A \
      --color=border:#6C7086 \
      --color=label:#CDD6F4"
end

