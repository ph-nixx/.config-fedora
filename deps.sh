#!/usr/bin/env bash
# Install the packages this config uses (Fedora, dnf).
# starship and the Symbols Nerd Font aren't in the Fedora repos, so they're
# installed from upstream if missing.
set -euo pipefail

packages=(
    # i3 session
    i3 i3lock xss-lock dex-autostart polybar rofi
    network-manager-applet brightnessctl wireplumber pulseaudio-utils pavucontrol
    xdg-desktop-portal-gtk gnome-keyring xdg-user-dirs
    # wallpaper and lock screen (i3/lock.sh)
    azote feh ImageMagick xrandr
    # screenshots (i3/config)
    maim xclip
    # key repeat rate (i3/config)
    xset
    # scripts: killall, pgrep, ps, top, setsid
    psmisc procps-ng util-linux
    # rofi/update.sh
    akmods flatpak
    # apps
    kitty firefox
    # shell
    zsh git curl tmux bc fzf zoxide eza neovim
    # fonts
    jetbrains-mono-fonts
)

sudo dnf install -y "${packages[@]}"

if ! command -v starship >/dev/null; then
    echo "==> Installing starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if ! fc-list | grep -q 'Symbols Nerd Font Mono'; then
    echo "==> Installing Symbols Nerd Font"
    dir=~/.local/share/fonts/NerdFontsSymbolsOnly
    mkdir -p "$dir"
    curl -sSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/NerdFontsSymbolsOnly.tar.xz \
        | tar -xJ -C "$dir"
    fc-cache -f "$dir"
fi
