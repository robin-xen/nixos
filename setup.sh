#!/bin/bash

# Arch Linux Setup Script - Converted from NixOS config
# Run as normal user (not root), script will use sudo when needed

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
    log_error "Please run as normal user, not root. Script will use sudo when needed."
    exit 1
fi

log_info "Starting Arch Linux setup..."

# Update system first
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install base-devel if not present (needed for yay)
log_info "Installing base-devel and git..."
sudo pacman -S --needed --noconfirm base-devel git

# Install yay (AUR helper)
if ! command -v yay &> /dev/null; then
    log_info "Installing yay AUR helper..."
    cd /tmp
    rm -rf yay
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    log_info "yay installed successfully"
else
    log_info "yay already installed"
fi

# Install official repo packages
sudo pacman -S git fish terraform gcc sof-firmware ffmpegthumbnailer tumbler clang cmake gdb neovim tmux docker kubectl zip unzip p7zip unrar file tree less ripgrep htop ncdu lsof strace yazi nmap  rsync openssh tldr aria2 curl wget brightnessctl wl-clipboard libvirt qemu-full virt-manager dnsmasq iptables-nft hyprland xdg-desktop-portal-hyprland waybar rofi alacritty hyprpaper grim slurp keyd pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber rtkit bluez bluez-utils blueman ttf-jetbrains-mono-nerd ttf-fira-code thunar firefox vlc obs-studio blender evince networkmanager network-manager-applet acpid flatpak tlp adwaita-icon-theme swaync cliphist
# Install AUR packages
log_info "Installing AUR packages..."
AUR_PACKAGES=(
    brave-bin
    google-chrome
    proton-vpn-gtk-app
    swayosd-git
    gammastep
    zen-browser-bin
)

for pkg in "${AUR_PACKAGES[@]}"; do
    log_info "Installing $pkg from AUR..."
    yay -S --needed --noconfirm "$pkg" || log_warn "Failed to install $pkg"
done

# Configure and enable systemd services
log_info "Enabling systemd services..."

# NetworkManager
sudo systemctl enable --now NetworkManager
log_info "NetworkManager enabled"

# Docker
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
log_info "Docker enabled and user added to docker group"

# Libvirt/KVM
sudo systemctl enable --now libvirtd
sudo systemctl enable --now virtlogd
sudo usermod -aG libvirt "$USER"
sudo usermod -aG kvm "$USER"
log_info "Libvirt enabled and user added to libvirt/kvm groups"

# Start default network for libvirt
sudo virsh net-autostart default 2>/dev/null || true
sudo virsh net-start default 2>/dev/null || true
log_info "Libvirt default network configured"

# Bluetooth
sudo systemctl enable --now bluetooth
log_info "Bluetooth enabled"

# TLP (power management)
sudo systemctl enable --now tlp
log_info "TLP enabled"

# PipeWire (usually starts automatically, but let's ensure)
systemctl --user enable --now pipewire pipewire-pulse wireplumber 2>/dev/null || true
log_info "PipeWire services enabled"

# Flatpak setup
log_info "Setting up Flatpak..."
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo



# Configure Hyprland portal
log_info "Configuring XDG portals for Hyprland..."
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/portals.conf << 'EOF'
[preferred]
default=hyprland;gtk
EOF

sudo tee /etc/keyd/default.conf > /dev/null << 'EOF'
[ids]
*
[main]
# Map right Alt (AltGr) directly to left Meta/Super
rightalt = leftmeta
EOF

sudo systemctl enable --now keyd 



log_info "=========================================="
log_info "Setup complete! 🎉"
log_info "=========================================="
log_info ""
log_warn "IMPORTANT: Please logout and login again for all changes to take effect"
log_warn "You need to logout for:"
log_warn "  - Group memberships (docker, libvirt, kvm)"
log_warn "  - Shell change to zsh"
log_warn ""
log_info "What was installed:"
log_info "  ✓ Development tools (gcc, clang, git, docker, etc.)"
log_info "  ✓ Hyprland and Wayland ecosystem"
log_info "  ✓ Virtualization (libvirt, virt-manager)"
log_info "  ✓ Audio (PipeWire)"
log_info "  ✓ Browsers (Firefox, Brave, Chrome)"
log_info "  ✓ All utilities and CLI tools"
log_info ""
log_info "What was enabled:"
log_info "  ✓ NetworkManager"
log_info "  ✓ Docker"
log_info "  ✓ Libvirt/KVM"
log_info "  ✓ Bluetooth"
log_info "  ✓ TLP (power management)"
log_info "  ✓ SSH"
log_info "  ✓ ACPID"
log_info ""
log_info "Next steps:"
log_info "  1. Logout and login again"
log_info "  2. Enjoy Arch without NixOS headaches! 🚀"
log_info ""

