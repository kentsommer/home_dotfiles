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
      --color=border:#29a4bd \
      --color=fg:#c0caf5 \
      --color=gutter:-1 \
      --color=header:#ff9e64 \
      --color=hl+:#2ac3de \
      --color=hl:#2ac3de \
      --color=info:#545c7e \
      --color=marker:#ff007c \
      --color=pointer:#ff007c \
      --color=prompt:#2ac3de \
      --color=query:#c0caf5:regular \
      --color=scrollbar:#29a4bd \
      --color=separator:#ff9e64 \
      --color=spinner:#ff007c"
else
    set -gx FZF_DEFAULT_OPTS "\
      --highlight-line \
      --info=inline-right \
      --ansi \
      --layout=reverse \
      --border=none \
      --color=bg+:-1 \
      --color=bg:-1 \
      --color=border:#29a4bd \
      --color=fg:#c0caf5 \
      --color=gutter:-1 \
      --color=header:#ff9e64 \
      --color=hl+:#2ac3de \
      --color=hl:#2ac3de \
      --color=info:#545c7e \
      --color=marker:#ff007c \
      --color=pointer:#ff007c \
      --color=prompt:#2ac3de \
      --color=query:#c0caf5:regular \
      --color=scrollbar:#29a4bd \
      --color=separator:#ff9e64 \
      --color=spinner:#ff007c"
end

