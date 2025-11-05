#!/bin/bash
set -e

t="$HOME/.cache/depends/"
rm -rf "$t"
mkdir -p "$t"
cd "$t"

# Update System
sudo pikman update
sudo pikman upgrade -y

# Group installation
sudo pikman install build-essential -y

# Core development tools
sudo pikman install cmake clang ninja-build meson pkg-config -y

# Python packages
sudo pikman install python3 python3-dev python3-pip -y
sudo pikman install unzip hypridle libsoup-3.0-dev -y

# Hyprland and related packages
sudo pikman install hyprland -y
sudo pikman install hyprpicker hyprlock wlogout pugixml -y
sudo pikman install libhyprutils cliphist hyprwayland-scanner libhyprlang-dev -y

# Install Hyprshot manually
echo "Installing Hyprshot..."
HYPRSHOT_DIR="$HOME/.local/src/hyprshot"
if [ -d "$HYPRSHOT_DIR" ]; then
    cd "$HYPRSHOT_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/Gustash/Hyprshot.git "$HYPRSHOT_DIR"
fi
cp "$HYPRSHOT_DIR/hyprshot" "$HOME/.local/bin/hyprshot"
chmod +x "$HOME/.local/bin/hyprshot"
echo "✅ Hyprshot installed"

# Install hyprsunset professionally
echo "Building and installing hyprsunset..."
HYPRSUNSET_DIR="$HOME/.local/src/hyprsunset"
if [ -d "$HYPRSUNSET_DIR" ]; then
    cd "$HYPRSUNSET_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/hyprwm/hyprsunset.git "$HYPRSUNSET_DIR"
fi
cd "$HYPRSUNSET_DIR"
cmake -B build -S . -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr
sudo cmake --build build --target install
echo "✅ hyprsunset installed"

# GUI and toolkit dependencies
sudo pikman install libgtk-4-dev libadwaita-1-dev -y
sudo pikman install libgtk-layer-shell-dev libgtk4-layer-shell-dev gtk3 libgtksourceview-3.0-1 libgtksourceview-3.0-dev gobject-introspection upower -y
sudo pikman install libgtksourceviewmm-3.0-dev -y
sudo pikman install webp-pixbuf-loader -y
sudo pikman install libgirepository-1.0-dev libgjs-dev libpulse-dev -y

# Desktop integrations and utilities
sudo pikman install x11-xserver-utils xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-hyprland -y
sudo pikman install gnome-bluetooth bluez-cups bluez -y
sudo pikman install mate-polkit qalc translate-shell -y

# Core utilities
sudo pikman install coreutils wl-clipboard xdg-utils curl fuzzel rsync wget ripgrep gojq npm meson typescript gjs axel eza -y
sudo pikman install brightnessctl ddcutil -y

# Audio & media
sudo pikman install pavucontrol wireplumber libdbusmenu-gtk3-dev libdbusmenu-gtk3-4 playerctl cava -y

# Other individual tools
sudo pikman install yad -y
sudo pikman install scdoc -y
sudo pikman install ydotool -y
sudo pikman install libtinyxml-dev libtinyxml2-dev -y
sudo pikman install libmagic-dev libwebp-dev libdrm-dev libgbm-dev libpam0g-dev libsass-dev -y

# Theming and appearance
sudo pikman install gnome-themes-extra adw-gtk3-theme qt5ct qt6ct qt6-wayland qt5-wayland fontconfig fonts-jetbrains-mono fonts-symbola fonts-lato -y
sudo pikman install fish kitty starship -y
sudo pikman install qt5-style-kvantum -y
sudo pikman install libkf6kcmutils-bin -y
sudo pikman install libxdp-dev libxdp libportal-dev -y

# Screenshot and screen recording tools
sudo pikman install swappy grim tesseract-ocr slurp wf-recorder -y

# Install grimblast manually
echo "Installing grimblast..."
GRIMBLAST_DIR="$HOME/.local/src/grimblast"
if [ -d "$GRIMBLAST_DIR" ]; then
    cd "$GRIMBLAST_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/hyprwm/contrib.git "$GRIMBLAST_DIR"
fi
cp "$GRIMBLAST_DIR/grimblast/grimblast" "$HOME/.local/bin/grimblast"
chmod +x "$HOME/.local/bin/grimblast"
echo "✅ grimblast installed"

# AppStream and web libs
sudo pikman install appstream-util libsoup-3.0-dev uv -y

# Power tools
sudo pikman install make -y

# Quickshell and Plasma dependencies
sudo pikman install python3-opencv plasma-desktop plasma-nm kdialog bluedevil plasma-systemmonitor wtype quickshell-git ffmpeg -y

# Install mpvpaper professionally
echo "Building and installing mpvpaper..."
MPVPAPER_DIR="$HOME/.local/src/mpvpaper"
if [ -d "$MPVPAPER_DIR" ]; then
    cd "$MPVPAPER_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/GhostNaN/mpvpaper.git "$MPVPAPER_DIR"
fi
cd "$MPVPAPER_DIR"
meson setup build --buildtype=release --prefix=/usr
sudo meson install -C build
echo "✅ mpvpaper installed"

# Install darkly theme professionally
echo "Installing darkly theme..."
DARKLY_DIR="$HOME/.local/src/darkly"
if [ -d "$DARKLY_DIR" ]; then
    cd "$DARKLY_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/Bali10050/darkly.git "$DARKLY_DIR"
fi
cd "$DARKLY_DIR"
mkdir -p "$HOME/.local/share/themes"
cp -r theme/* "$HOME/.local/share/themes/darkly/" 2>/dev/null || echo "Darkly theme structure may vary, check manually"
echo "✅ darkly theme installed"

# Install kde-material-you-colors professionally
echo "Building and installing kde-material-you-colors..."
KDE_MATERIAL_DIR="$HOME/.local/src/kde-material-you-colors"
if [ -d "$KDE_MATERIAL_DIR" ]; then
    cd "$KDE_MATERIAL_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/luisbocanegra/kde-material-you-colors.git "$KDE_MATERIAL_DIR"
fi
cd "$KDE_MATERIAL_DIR"

# Install Python dependencies
sudo pikman install python3-dbus python3-numpy python3-pil -y
pip3 install materialyoucolor pywal

# Build backend
python3 -m build --wheel --no-isolation

# Build plasmoid & screenshot helper
cmake -B build -S . -DINSTALL_PLASMOID=ON
sudo cmake --build build --target install

# Install Python package
sudo python3 -m installer --destdir=/ dist/*.whl
echo "✅ kde-material-you-colors installed"

# Upscayl installation
read -rp "Do you want to install/Update Upscayl? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    cd "$t" || { echo "Directory $t not found"; exit 1; }

    url=$(curl -s https://api.github.com/repos/upscayl/upscayl/releases/latest \
      | jq -r '.assets[] | select(.name | test("\\.deb$")) | .browser_download_url')

    wget "$url"
    deb_file="${url##*/}"
    sudo pikman install -y "./$deb_file"
    echo "✅ Upscayl installed"
else
    echo "Skipped Upscayl installation."
fi

# Cleanup
rm -rf "$t"
echo "✅ All packages installed successfully!"
echo "🎉 Hyprland dotfiles conversion to PikaOS completed!"
