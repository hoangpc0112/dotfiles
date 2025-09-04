#!/bin/bash

install_paru() {
  sudo pacman -S --noconfirm --needed base-devel git

  if command -v paru &>/dev/null; then
    echo "paru is already installed. Skipping ..."
  else
    rm -rf "$HOME/paru"
    git clone https://aur.archlinux.org/paru.git "$HOME/paru"
    cd "$HOME/paru"
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf "$HOME/paru"
  fi
}

install_packages() {
  paru -Syu --noconfirm
  paru -S --noconfirm --needed hyprland hyprlock hypridle waybar rofi fastfetch fzf starship kitty feh mpv \
    unzip unrar neovim python python-pip nodejs npm jdk-openjdk gcc make bat tar bash-completion wget zoxide curl \
    zen-browser-bin inter-font ttf-jetbrains-mono-nerd fcitx5 fcitx5-configtool fcitx5-bamboo fcitx5-gtk fcitx5-qt papirus-icon-theme \
    breeze-gtk sddm swww cliphist grimblast wl-clipboard obs-studio vesktop-bin xdg-desktop-portal-hyprland qt6-wayland btop blueman dunst \
    bibata-cursor-theme-bin ripgrep fd ufw lazygit openssh zip onlyoffice-bin postman-bin visual-studio-code-bin localsend-bin gammastep tree \
    brightnessctl yazi lsd tldr trash-cli zsh
  ya pkg add kalidyasin/yazi-flavors:tokyonight-night
}

create_symlink() {
  local source_path="$1"
  local target_path="$2"

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    rm -rf "$target_path"
  fi
  ln -sf "$source_path" "$target_path"
}

setup_dotfiles() {
  create_symlink "$HOME/dotfiles/config/fastfetch/" "$HOME/.config/fastfetch"
  create_symlink "$HOME/dotfiles/config/hypr/" "$HOME/.config/hypr"
  create_symlink "$HOME/dotfiles/config/kitty/" "$HOME/.config/kitty"
  create_symlink "$HOME/dotfiles/config/rofi/" "$HOME/.config/rofi"
  create_symlink "$HOME/dotfiles/config/waybar/" "$HOME/.config/waybar"
  create_symlink "$HOME/dotfiles/images/" "$HOME/images"
  create_symlink "$HOME/dotfiles/config/dunst/" "$HOME/.config/dunst"

  create_symlink "$HOME/dotfiles/gitconfig" "$HOME/.gitconfig"
  create_symlink "$HOME/dotfiles/config/starship.toml" "$HOME/.config/starship.toml"
  create_symlink "$HOME/dotfiles/images/wallpapers/midnight_symphony.png" "$HOME/.config/hypr/current_wallpaper"
  create_symlink "$HOME/dotfiles/config/nvim/colorscheme.lua" "$HOME/.config/nvim/lua/plugins/colorscheme.lua"
  create_symlink "$HOME/dotfiles/config/hypr/hyprland-performance.conf" "$HOME/.config/hypr/hyprland.conf"
  create_symlink "$HOME/dotfiles/config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
  create_symlink "$HOME/dotfiles/fzf-preview.sh" "$HOME/fzf-preview.sh"
  create_symlink "$HOME/dotfiles/config/yazi/theme.toml" "$HOME/.config/yazi/theme.toml"

  chmod +x "$HOME/.config/hypr/scripts/*"
  chmod +x "$HOME/fzf-preview.sh"
}

setup_zsh() {
  mkdir -p "$HOME/.config/zsh"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/zsh-syntax-highlighting"
  git clone https://github.com/Aloxaf/fzf-tab "$HOME/.config/zsh/fzf-tab"
  create_symlink "$HOME/dotfiles/zshrc" "$HOME/.zshrc"
  create_symlink "$HOME/dotfiles/config/zsh/zsh-syntax-highlight-tokyonight.zsh" "$HOME/.config/zsh/zsh-syntax-highlight-tokyonight.zsh"
}

change_gtk_theme() {
  gsettings set org.gnome.desktop.interface gtk-theme "Breeze-Dark"
  gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
  gsettings set org.gnome.desktop.interface font-name "Inter Regular 11"
  gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font 11"
  gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Ice"
}

change_sddm_theme() {
  git clone https://github.com/Davi-S/sddm-theme-minesddm.git "$HOME/sddm-theme-minesddm"
  sudo cp -r "$HOME/sddm-theme-minesddm/minesddm" "/usr/share/sddm/themes/"
  echo "[Theme]
  Current=minesddm" | sudo tee "/etc/sddm.conf"
  cd "$HOME"
  rm -rf "$HOME/sddm-theme-minesddm"
}

start_service() {
  sudo systemctl enable sddm.service
  sudo systemctl enable bluetooth.service
  sudo systemctl enable ufw.service
  sudo ufw enable
}

install_lazyvim() {
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
}

change_grub_theme() {
  git clone https://github.com/Lxtharia/minegrub-world-sel-theme.git "$HOME/minegrub-world-sel-theme"
  sudo cp -ru "$HOME/minegrub-world-sel-theme/minegrub-world-selection" "/boot/grub/themes/"
  echo 'GRUB_TERMINAL_OUTPUT=gfxterm' | sudo tee -a "/etc/default/grub"
  echo 'GRUB_THEME=/boot/grub/themes/minegrub-world-selection/theme.txt' | sudo tee -a "/etc/default/grub"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  rm -rf "$HOME/minegrub-world-sel-theme"
}

main_menu() {
  sudo echo "Starting installation..."
  install_paru
  install_packages
  start_service
  install_lazyvim
  setup_dotfiles
  setup_zsh
  change_gtk_theme
  change_sddm_theme
  change_grub_theme
  echo "All tasks complete!"
}

main_menu
