# Disclaimer

These dotfiles combine configurations from many sources, so they're not 100% my creation.

# Previews

| Grub screen                                                                                                                                           | Login screen                                                                                                                                              |
| :---------------------------------------------------------------------------------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------- |
| <img width="1920" height="1080" alt="image" src="https://raw.githubusercontent.com/Lxtharia/minegrub-world-sel-theme/dev/assets/theme-preview.png" /> | <img width="1920" height="1080" alt="image" src="https://raw.githubusercontent.com/Davi-S/sddm-theme-minesddm/main/screenshots/minesddm_preview_3.png" /> |
| Main screen                                                                                                                                           | Lock screen                                                                                                                                               |
| <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/420b8a16-1ff2-4b19-a4c1-50727c09913a" />                  | <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b4308989-b38a-475b-aa0b-cadcab736877" />                      |

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
