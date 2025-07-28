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
  paru -S --noconfirm --needed hyprland hyprlock hypridle waybar rofi fastfetch fzf starship kitty thunar feh mpv \
    unzip unrar neovim python python-pip nodejs npm jdk-openjdk gcc make bat tar bash-completion wget zoxide curl \
    firefox inter-font ttf-jetbrains-mono-nerd fcitx5 fcitx5-configtool fcitx5-bamboo fcitx5-gtk fcitx5-qt papirus-icon-theme breeze-gtk sddm swww cliphist grim slurp wl-clipboard
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

  create_symlink "$HOME/dotfiles/.config/fastfetch/" "$HOME/.config/fastfetch"
  create_symlink "$HOME/dotfiles/.config/hypr/" "$HOME/.config/hypr"
  create_symlink "$HOME/dotfiles/.config/kitty/" "$HOME/.config/kitty"
  create_symlink "$HOME/dotfiles/.config/rofi/" "$HOME/.config/rofi"
  create_symlink "$HOME/dotfiles/.config/waybar/" "$HOME/.config/waybar"
  create_symlink "$HOME/dotfiles/images/" "$HOME/images"

  create_symlink "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
  create_symlink "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$HOME/dotfiles/.config/starship.toml" "$HOME/.config/starship.toml"
}

change_theme() {
  gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"
  gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
}

enable_sddm(){
  sudo systemctl disable display-manager.service
  sudo systemctl enable sddm.service
}

install_paru
install_packages
setup_dotfiles
change_theme
echo "Installation complete! Please reboot or log out/log in for changes to take effect."