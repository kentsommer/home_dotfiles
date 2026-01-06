#!/usr/bin/env bash
brew bundle --file=- <<EOF
tap 'FelixKratz/formulae'
tap 'nikitabobko/tap'

brew 'ninja'
brew 'cmake'
brew 'gettext'
brew 'curl'
brew 'git'
cask 'ghostty'
brew 'fish'
brew 'FelixKratz/formulae/borders'
brew 'mpv'
cask 'font-fira-code-nerd-font'
cask 'font-noto-color-emoji'
brew 'stow'
brew 'less'
brew 'rustup'
brew 'btop'
brew 'lsd'
brew 'neovim', args: ["HEAD"]
brew 'jj'
brew 'yazi'
brew 'zellij'
brew 'fastfetch'
brew 'fzf'
cask '1password-cli'
cask 'nikitabobko/tap/aerospace'
cask 'alfred'
EOF

if [ $? -eq 0 ]; then
    echo "✅ Brew bundle completed successfully!"
else
    echo "❌ Brew bundle failed."
    exit 1
fi
