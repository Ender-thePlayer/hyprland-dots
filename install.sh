#!/usr/bin/env bash

clear; echo "[INFO] Installing dependencies"

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm git flatpak
sudo pacman -S --needed --noconfirm base-devel

git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin || exit 1
makepkg -si --noconfirm
cd ..
rm -rf ./paru-bin

sudo pacman -S --noconfirm kitty waybar fish hypridle hyprlock hyprpaper rofi-wayland gammastep brightnessctl pavucontrol pamixer blueberry gnome-tweaks papirus-icon-theme dunst network-manager-applet wl-clipboard fcitx5-config-qt kdeconnect polkit-gnome cliphist noto-fonts-cjk xdg-desktop-portal-gtk xdg-desktop-portal nautilus vfs-mtp neovim ttf-jetbrains-mono-nerd swaync
paru -S --noconfirm qt5ct-kde qt6ct-kde hyprpicker hyprshot wlogout fcitx5-mozc vesktop-bin librewolf-bin
sudo udevadm control --reload

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install --user -y flathub dev.vencord.Vesktop
flatpak install --user -y flathub com.spotify.Client
flatpak install --user -y flathub org.gtk.Gtk3theme.adw-gtk3 org.gtk.Gtk3theme.adw-gtk3-dark



clear; echo "[INFO] Copying the dotfiles"

mkdir ./tmp
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > ./tmp/install.sh
fish -c "./tmp/install.sh --path=~/.local/share/omf --config=~/.config/omf & wait -n fish && killall fish"
rm -r ./tmp

gsettings set org.gnome.desktop.interface color-scheme prefer-dark
wget "$( curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep browser_download_url | cut -d '"' -f 4 )"
mkdir -p ~/.local/share/themes/
tar -xf ./adw-gtk3* -C ~/.local/share/themes/
rm ./adw-gtk3*
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

shopt -s dotglob
cp -r ./dotfiles/* "$HOME"/
