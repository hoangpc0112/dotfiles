# Disclaimer

These dotfiles combine configurations from many sources, so they're not 100% my creation.

# Program

| Component          | Program                                                                                    |
| ------------------ | ------------------------------------------------------------------------------------------ |
| Windows Manager 🪟 | [hyprland](https://github.com/hyprwm/Hyprland)                                             |
| Terminal 🖥️        | [kitty](https://github.com/kovidgoyal/kitty)                                               |
| Shell 🐚           | [bash](https://github.com/bminor/bash)                                                     |
| File Manager 📁    | [yazi](https://github.com/sxyazi/yazi)                                            |
| Editor 📝          | [neovim](https://github.com/neovim/neovim) / [lazyvim](https://github.com/LazyVim/LazyVim) / [vscode](https://github.com/microsoft/vscode) |
| Browser 🌐         | [zen browser](https://github.com/zen-browser/desktop)                                      |
| Bar 📊             | [waybar](https://github.com/Alexays/Waybar)                                                |
| Launcher 🚀        | [rofi](https://github.com/davatorium/rofi)                                                 |
| Lockscreen 🔒      | [hyprlock](https://github.com/hyprwm/hyprlock)                                             |
| Login Menu 🚪      | [sddm](https://github.com/sddm/sddm)                                                       |

# Previews

<img width="1920" height="1080" alt="preview_1" src="https://github.com/user-attachments/assets/1e679dfd-86a1-49bf-8cc4-91f56211265d" />
<img width="1920" height="1080" alt="preview_2" src="https://github.com/user-attachments/assets/5dff1b95-426f-4e6f-a4ed-369b06329f51" />

# Installation

## Run the installation script (A fresh installation of Arch(-based) Linux is recommended)

```
git clone https://github.com/hoangpc0112/dotfiles.git $HOME/dotfiles
cd $HOME/dotfiles/
chmod +x install.sh
./install.sh
```

## Edit grub

```
sudo nvim /etc/default/grub
```

- Uncomment OS_PROBER line (detect Windows)
- Add acpi_backlight=native (fix my backlight)

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
