#!/bin/bash

update_system() {
  sudo pacman -S --noconfirm reflector
  sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo reflector --country Vietnam,Singapore,China --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
  sudo pacman -Syyu --noconfirm
}

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
  echo "Installing/updating packages with paru..."
  paru -S --noconfirm hyprland hyprlock hyprpaper hypridle waybar rofi fastfetch fzf starship kitty thunar feh mpv \
    unzip unrar neovim python python-pip nodejs npm jdk-openjdk gcc make bat tar bash-completion wget zoxide curl \
    zen-browser-bin
}

setup_dotfiles() {
  echo "Setting up dotfiles..."
  rm -rf "$HOME/dotfiles"

  git clone https://github.com/hoangpc0112/dotfiles.git "$HOME/dotfiles"

  create_symlink() {
    local source_path="$1"
    local target_path="$2"

    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
      echo "Removing existing target: $target_path"
      rm -rf "$target_path"
    fi
    ln -svf "$source_path" "$target_path"
  }

  create_symlink "$HOME/dotfiles/.config/fastfetch" "$HOME/.config/fastfetch"
  create_symlink "$HOME/dotfiles/.config/hypr" "$HOME/.config/hypr"
  create_symlink "$HOME/dotfiles/.config/kitty" "$HOME/.config/kitty"
  create_symlink "$HOME/dotfiles/.config/rofi" "$HOME/.config/rofi"
  create_symlink "$HOME/dotfiles/.config/waybar" "$HOME/.config/waybar"

  create_symlink "$HOME/dotfiles/.bashrc" "$HOME/.bashrc"
  create_symlink "$HOME/dotfiles/.gitconfig" "$HOME/.gitconfig"
}

main() {
  update_system
  install_paru
  install_packages
  setup_dotfiles
  echo "Installation complete! Please reboot or log out/log in for changes to take effect."
}

main "$@"
