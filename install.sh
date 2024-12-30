#!/usr/bin/env bash

while true; do
    read -rp "Do you want to install paru AUR manager? [y/N]:" response
    case "${response,,}" in 
        y|yes)
            echo "[INFO] Installing paru."
            sudo pacman -S --noconfirm git flatpak
            sudo pacman -S --needed --noconfirm base-devel
            git clone https://aur.archlinux.org/paru-bin.git
            cd paru-bin || exit 1
            makepkg -si --noconfirm
            cd ..
            rm -rf ./paru-bin
            sleep 3 && clear
            break
            ;;
        n|no)
            echo "[INFO] Skipping..."
            sleep 3 && clear
            break
            ;;
        *)
            echo "[ERR] Invalid response."
            ;;
    esac
done

while true; do
    read -rp "Do you want to install flatpak and configure flathub? [y/N]:" response
    case "${response,,}" in 
        y|yes)
            echo "[INFO] Installing flatpak."
            sudo pacman -S --noconfirm flatpak
            flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            sleep 3 && clear
            break
            ;;
        n|no)
            echo "[INFO] Skipping..."
            sleep 3 && clear
            break
            ;;
        *)
            echo "[ERR] Invalid response."
            ;;
    esac
done



echo "[INFO] Installing necessary apps."

pacman=(
"xdg-user-dirs"
"waybar"
"hypridle"
"hyprlock"
"swww"
"rofi-wayland"
"wl-clipboard"
"gammastep"
"brightnessctl"
"pavucontrol"
"pamixer"
"blueberry"
"dunst"
"network-manager-applet"
"noto-fonts-cjk"
"ttf-jetbrains-mono-nerd"
"papirus-icon-theme"
"xdg-desktop-portal-gtk"
"xdg-desktop-portal"
"plasma-framework5"
"breeze5"
"breeze-gtk"
"fish"
"starship"
"cliphist"
"mpv"
"batsignal"
"hyprpicker"
"otf-latinmodern-math"
)

paru=(
"qt5ct-kde"
"qt6ct-kde"
"hyprshot"
"wlogout"
"wttrbar"
"nautilus-open-any-terminal"
"pfetch-rs"
"wl-screenrec"
)

for pkg in "${pacman[@]}"; do
    sudo pacman -S --noconfirm "$pkg"
done

for pkg in "${paru[@]}"; do
    paru -S --noconfirm "$pkg"
done

flatpak=(
"dev.vencord.Vesktop"
"org.gtk.Gtk3theme.adw-gtk3"
"org.gtk.Gtk3theme.adw-gtk3-dark"
)

for pkg in "${flatpak[@]}"; do
    flatpak install --user -y flathub "$pkg"
done

sleep 3 && clear



echo "[INFO] Copying the dotfiles"
wget "$( curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | grep browser_download_url | cut -d '"' -f 4 )"
mkdir ~/.local/share/themes/
tar -xf ./adw-gtk3* -C ~/.local/share/themes/
rm ./adw-gtk3*
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name "Inter 10"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 

sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf > /dev/null

git clone https://github.com/supermariofps/hatsune-miku-windows-linux-cursors
mkdir -p ~/.local/share/icons/
mv ./hatsune-miku-windows-linux-cursors/miku-cursor-linux ~/.local/share/icons
rm -rf hatsune-miku-windows-linux-cursors

glib-compile-schemas ~/.local/share/glib-2.0/schemas/
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

shopt -s dotglob
cp -r ./dotfiles/* "$HOME"/



while true; do
    read -rp "Do you want to change the default shell to fish? [y/N]:" response
    case "${response,,}" in 
        y|yes)
            chsh -s "$(which fish)"
            sleep 3 && clear
            break
            ;;
        n|no)
            echo "[INFO] Skipping..."
            sleep 3 && clear
            break
            ;;
        *)
            echo "[ERR] Invalid response."
            ;;
    esac
done

echo "[DONE] Done installing the dotfiles!"