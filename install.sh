#!/bin/bash

install_paru() {
  sudo pacman -S --noconfirm --needed base-devel git

  if command -v paru &>/dev/null; then
    echo "paru is already installed. Skipping ..."
  else
    echo "Installing paru ..."
    rm -rf "$HOME/paru"

    git clone https://aur.archlinux.org/paru.git "$HOME/paru"
    (cd "$HOME/paru" && makepkg -si --noconfirm)
  fi
}

install_packages() {
  echo "Installing/updating packages ..."
  paru -S --noconfirm hyprland hyprlock hyprpaper hypridle waybar rofi fastfetch fzf starship kitty thunar feh mpv \
    unzip unrar neovim python python-pip nodejs npm jdk-openjdk gcc make bat tar bash-completion wget zoxide curl \
    zen-browser-bin inter-font ttf-jetbrains-mono-nerd stow
}

setup_dotfiles() {
  echo "Setting up dotfiles ..."
  cd ~/dotfiles
  stow -t $HOME .
}

install_paru
install_packages
setup_dotfiles
echo "Installation complete! Please reboot or log out/log in for changes to take effect."