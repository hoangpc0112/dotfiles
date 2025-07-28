#!/bin/bash

install_paru() {
  sudo pacman -S --noconfirm --needed base-devel git

  if command -v paru &>/dev/null; then
    echo "paru is already installed. Skipping ..."
  else
    echo "Installing paru ..."
    rm -rf "$HOME/paru"

    git clone https://aur.archlinux.org/paru.git "$HOME/paru"
    cd "$HOME/paru"
    makepkg -si --noconfirm
  fi
}

install_packages() {
  echo "Installing/updating packages ..."
  paru -S --noconfirm --needed hyprland hyprlock hyprpaper hypridle waybar rofi fastfetch fzf starship kitty thunar feh mpv \
    unzip unrar neovim python python-pip nodejs npm jdk-openjdk gcc make bat tar bash-completion wget zoxide curl \
    zen-browser-bin inter-font ttf-jetbrains-mono-nerd
}

setup_dotfiles() {
  echo "Setting up dotfiles ..."

  create_symlink() {
    local source_path="$1"
    local target_path="$2"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      rm -rf "$target_path"
    fi
    ln -sf "$source_path" "$target_path"
  }

  create_symlink "$HOME/dotfiles/.config/fastfetch/" "$HOME/.config/fastfetch/"
  create_symlink "$HOME/dotfiles/.config/hypr/" "$HOME/.config/hypr/"
  create_symlink "$HOME/dotfiles/.config/kitty/" "$HOME/.config/kitty/"
  create_symlink "$HOME/dotfiles/.config/rofi/" "$HOME/.config/rofi/"
  create_symlink "$HOME/dotfiles/.config/waybar/" "$HOME/.config/waybar/"
  create_symlink "$HOME/dotfiles/wallpapers/" "$HOME/wallpapers/"

  create_symlink "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
  create_symlink "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"
}

install_paru
install_packages
setup_dotfiles
echo "Installation complete! Please reboot or log out/log in for changes to take effect."