#!/usr/bin/env bash
paru_installed=false

while true; do
    read -rp "Do you want to install paru AUR manager? [y/N]:" response
    case "${response,,}" in 
        y|yes)
            paru_installed=true
            echo "[INFO] Installing paru."
            sudo pacman -S --noconfirm git flatpak
            sudo pacman -S --needed --noconfirm base-devel
            git clone https://aur.archlinux.org/paru.git
            cd paru || exit 1
            makepkg -s --noconfirm
            sudo pacman -U --noconfirm paru-*.tar.zst
            cd ..
            rm -rf ./paru
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
#Compositor
"hypridle"
"hyprlock"
"hyprshot"
"hyprpicker"
"awww"
"rofi"
"rofi-emoji"
"wl-clipboard"
"cliphist"
"brightnessctl"
"gammastep"

#Theming
"breeze5"
"breeze-gtk"
"breeze"
"papirus-icon-theme"
"gtk4"
"noto-fonts-cjk"
"ttf-jetbrains-mono-nerd"
"otf-latinmodern-math"

#Dev
"fish"
"starship"
"vim"
"uv"

#Sysutils
"lm_sensors"
"fastfetch"
"jq"
"bluez"
"bluez-utils"
"fcitx5-mozc"
"fcitx5-config-qt"
"playerctl"
"wtype"
"nwg-look"
"nwg-displays"

#Apps
"flatpak"
"wf-recorder"
)

paru=(
#Compositor
"wayle-bin"

#Theming
"qt5ct-kde"
"qt6ct-kde"

#Apps
"vscodium-bin"
"vesktop-bin"

#Sysutils
"pfetch-rs"
"mpris-scrobbler"
"nautilus-open-any-terminal"
)

for pkg in "${pacman[@]}"; do
    sudo pacman -S --noconfirm "$pkg"
done

if $paru_installed; then
    for pkg in "${paru[@]}"; do
        paru -S --noconfirm "$pkg"
    done
fi

flatpak=(
"org.gtk.Gtk3theme.adw-gtk3"
"org.gtk.Gtk3theme.adw-gtk3-dark"
"io.gitlab.librewolf-community"
)

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
for pkg in "${flatpak[@]}"; do
    flatpak install --user -y flathub "$pkg"
done

sleep 3 && clear



echo "[INFO] Copying the dotfiles"
wget "$(curl -s https://api.github.com/repos/lassekongo83/adw-gtk3/releases/latest | jq -r '.assets[] | select(.name | endswith(".tar.xz")) | .browser_download_url')"
mkdir ~/.local/share/themes/
tar -xf ./adw-gtk3* -C ~/.local/share/themes/
rm ./adw-gtk3*
gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark' && gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface font-name "Inter 10"
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 

git clone https://github.com/supermariofps/hatsune-miku-windows-linux-cursors
mkdir -p ~/.local/share/icons/
mv ./hatsune-miku-windows-linux-cursors/miku-cursor-linux ~/.local/share/icons/MikuCursor
rm ~/.local/share/icons/MikuCursor/cursor.theme
rm -rf hatsune-miku-windows-linux-cursors

gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal kitty

dconf load /org/gnome/nautilus/ < ./nautilus.conf
dconf load /org/gtk/gtk4/settings/file-chooser/ < ./file-chooser.conf
dconf load /org/gnome/TextEditor/ < ./texteditor.conf

shopt -s dotglob
cp -r ./dotfiles/* "$HOME"/

nwg-look -x

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
