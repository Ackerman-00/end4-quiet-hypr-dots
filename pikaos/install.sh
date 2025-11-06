#!/bin/bash
set -e

t="$HOME/.cache/depends/"
rm -rf "$t"
mkdir -p "$t"
cd "$t"

# Update System
sudo apt update
sudo apt upgrade -y

# Group installation with no recommends
sudo apt install --no-install-recommends build-essential -y

# Core development tools
sudo apt install --no-install-recommends cmake clang ninja-build meson pkg-config -y

# Python packages
sudo apt install --no-install-recommends python3 python3-dev python3-pip python3-full -y
sudo apt install --no-install-recommends unzip hypridle libsoup-3.0-dev -y

# Install pugixml development files (available under different name)
sudo apt install --no-install-recommends -y libpugixml-dev

# Build and install hyprpicker manually FIRST (since hyprshot, sunset etc depend on it)
echo "Building and installing hyprpicker from source..."
HYPRPICKER_DIR="$HOME/.local/src/hyprpicker"
if [ -d "$HYPRPICKER_DIR" ]; then
    cd "$HYPRPICKER_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/hyprwm/hyprpicker.git "$HYPRPICKER_DIR"
fi

cd "$HYPRPICKER_DIR"

# Install build dependencies for hyprpicker (FIXED: Combined onto a single line to prevent "command not found" error)
sudo apt install --no-install-recommends -y cmake git meson ninja-build wayland-protocols libcairo2-dev libxkbcommon-dev libwayland-dev libgl-dev libjpeg-dev libpango1.0-dev xserver-xorg-dev

# Build and install hyprpicker
cmake -B build -S . -G Ninja -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr
sudo cmake --build build --target install
echo "✅ hyprpicker installed"

# Hyprland and related packages (now without hyprpicker and pugixml)
sudo apt install --no-install-recommends hyprland -y
sudo apt install --no-install-recommends hyprlock wlogout -y
sudo apt install --no-install-recommends libhyprutils cliphist hyprwayland-scanner libhyprlang-dev -y

# Install Hyprshot manually with proper user home directory
echo "Installing Hyprshot..."
HYPRSHOT_DIR="$HOME/.local/src/hyprshot"
if [ -d "$HYPRSHOT_DIR" ]; then
    cd "$HYPRSHOT_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/Gustash/Hyprshot.git "$HYPRSHOT_DIR"
fi
mkdir -p "$HOME/.local/bin"
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
sudo apt install --no-install-recommends libgtk-4-dev libadwaita-1-dev -y
sudo apt install --no-install-recommends libgtk-layer-shell-dev libgtk4-layer-shell-dev libgtk-3-dev libgtksourceview-3.0-1 libgtksourceview-3.0-dev gobject-introspection upower -y
sudo apt install --no-install-recommends libgtksourceviewmm-3.0-dev -y
sudo apt install --no-install-recommends webp-pixbuf-loader -y
sudo apt install --no-install-recommends libgirepository-1.0-dev libgjs-dev libpulse-dev -y

# Desktop integrations and utilities
sudo apt install --no-install-recommends x11-xserver-utils xdg-desktop-portal xdg-desktop-portal-kde xdg-desktop-portal-hyprland -y
sudo apt install --no-install-recommends gnome-bluetooth bluez-cups bluez -y
sudo apt install --no-install-recommends mate-polkit qalc translate-shell -y

# Core utilities
sudo apt install --no-install-recommends coreutils wl-clipboard xdg-utils curl fuzzel rsync wget ripgrep gojq npm meson gjs axel eza -y
sudo apt install --no-install-recommends brightnessctl ddcutil -y

# Install TypeScript via node-typescript (correct package name)
sudo apt install --no-install-recommends node-typescript -y
echo "✅ TypeScript installed"

# Audio & media
sudo apt install --no-install-recommends pavucontrol wireplumber libdbusmenu-gtk3-dev libdbusmenu-gtk3-4 playerctl cava -y

# Other individual tools
sudo apt install --no-install-recommends yad -y
sudo apt install --no-install-recommends scdoc -y
sudo apt install --no-install-recommends ydotool -y
sudo apt install --no-install-recommends libtinyxml-dev libtinyxml2-dev -y
sudo apt install --no-install-recommends libmagic-dev libwebp-dev libdrm-dev libgbm-dev libpam0g-dev libsass-dev -y

# Theming and appearance
sudo apt install --no-install-recommends gnome-themes-extra adw-gtk3-theme qt5ct qt6ct qt6-wayland libqt5waylandclient5 fontconfig fonts-jetbrains-mono fonts-symbola fonts-lato -y
sudo apt install --no-install-recommends fish kitty starship -y
sudo apt install --no-install-recommends qt5-style-kvantum -y
# 🎯 FIXED: Replaced libkf6kcmutils-bin with a more stable, non-development dependency
sudo apt install --no-install-recommends libkf6kcmutils6 -y 
sudo apt install --no-install-recommends libxdp-dev libportal-dev -y

# Screenshot and screen recording tools
sudo apt install --no-install-recommends swappy grim tesseract-ocr slurp wf-recorder -y

# Install grimblast professionally (converted from AUR PKGBUILD) 
echo "Building and installing grimblast..."
GRIMBLAST_DIR="$HOME/.local/src/grimblast"
if [ -d "$GRIMBLAST_DIR" ]; then
    cd "$GRIMBLAST_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/hyprwm/contrib.git "$GRIMBLAST_DIR"
fi

cd "$GRIMBLAST_DIR/grimblast"

# Build man page
if command -v scdoc >/dev/null 2>&1; then
    scdoc < grimblast.1.scd > grimblast.1
    sudo mkdir -p /usr/share/man/man1
    sudo install -Dm 644 grimblast.1 /usr/share/man/man1/grimblast.1
fi

# Install grimblast binary
sudo install -Dm 755 grimblast /usr/bin/grimblast
echo "✅ grimblast installed"

# AppStream and web libs
sudo apt install --no-install-recommends appstream-util libsoup-3.0-dev -y

# Install UV via pipx
echo "Installing UV..."
sudo apt install --no-install-recommends pipx python3-pip -y
pipx install uv
echo "✅ UV installed"

# Power tools
sudo apt install --no-install-recommends make -y

# Quickshell and Plasma dependencies with Qt6 development packages 
sudo apt install --no-install-recommends python3-opencv plasma-desktop plasma-nm kdialog bluedevil plasma-systemmonitor wtype matugen quickshell-git ffmpeg -y
sudo apt install --no-install-recommends qt6-base-dev qt6-declarative-dev qt6-shadertools-dev -y

# Install mpvpaper professionally
echo "Building and installing mpvpaper..."
MPVPAPER_DIR="$HOME/.local/src/mpvpaper"
if [ -d "$MPVPAPER_DIR" ]; then
    cd "$MPVPAPER_DIR" && git pull || true
else
    git clone --depth=1 https://github.com/GhostNaN/mpvpaper.git "$MPVPAPER_DIR"
fi

# Install mpv development dependencies
sudo apt install --no-install-recommends libmpv-dev -y

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

# 🎯 CRITICAL FIX: Replaced 'libkf6plasma-dev' with the correct Debian/PikaOS package name 'libplasma-dev'.
sudo apt install --no-install-recommends extra-cmake-modules cmake-extras gettext libkf6config-dev libkf6coreaddons-dev libkf6i18n-dev libkf6package-dev libkf6kcmutils-dev libplasma-dev -y

# Install Python dependencies
sudo apt install --no-install-recommends python3-dbus python3-numpy python3-pil -y
pip3 install --break-system-packages materialyoucolor pywal

# Build backend
python3 -m build --wheel --no-isolation

# Build plasmoid & screenshot helper
# We now rely on the newly installed libplasma-dev package to correctly configure CMake paths
cmake -B build -S . -DINSTALL_PLASMOID=ON
# The subsequent cmake build/install step should now succeed with KF6 packages
sudo cmake --build build --target install

# Install Python package with --break-system-packages
sudo python3 -m pip install --break-system-packages dist/*.whl
echo "✅ kde-material-you-colors installed"

# Initialize and update git submodules for quickshell
echo "Initializing quickshell submodules..."
QUICKSHELL_CONFIG_DIR="$HOME/.config/quickshell"
if [ -d "$QUICKSHELL_CONFIG_DIR" ]; then
    cd "$QUICKSHELL_CONFIG_DIR"
    if [ -f ".gitmodules" ]; then
        git submodule update --init --recursive
        echo "✅ Quickshell submodules updated"
    fi
fi

# Upscayl installation
read -rp "Do you want to install/Update Upscayl? (y/n): " choice

if [[ "$choice" =~ ^[Yy]$ ]]; then
    cd "$t" || { echo "Directory $t not found"; exit 1; }

    url=$(curl -s https://api.github.com/repos/upscayl/upscayl/releases/latest \
      | jq -r '.assets[] | select(.name | test("\\.deb$")) | .browser_download_url')

    wget "$url"
    deb_file="${url##*/}"
    # NOTE: The --no-install-recommends flag is correctly applied here.
    sudo apt install --no-install-recommends -y "./$deb_file"
    echo "✅ Upscayl installed"
else
    echo "Skipped Upscayl installation."
fi

# Cleanup
rm -rf "$t"
echo "✅ All packages installed successfully!"
