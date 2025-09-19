#!/bin/bash
# Script to completely remove Nix from the system
# WARNING: This will remove ALL Nix installations and data!

set -euo pipefail

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

warning "This script will COMPLETELY REMOVE Nix from your system!"
warning "All Nix packages, profiles, and data will be deleted."
echo ""
read -p "Are you sure you want to continue? Type 'YES' to confirm: " confirm

if [ "$confirm" != "YES" ]; then
    info "Operation cancelled."
    exit 0
fi

info "Starting Nix removal process..."

# Stop nix daemon if running
info "Stopping Nix daemon..."
sudo systemctl stop nix-daemon.service 2>/dev/null || true
sudo systemctl disable nix-daemon.service 2>/dev/null || true

# Remove systemd service files
info "Removing systemd services..."
sudo rm -f /etc/systemd/system/nix-daemon.service
sudo rm -f /etc/systemd/system/nix-daemon.socket
sudo systemctl daemon-reload

# Remove users and groups
info "Removing Nix users and groups..."
for i in {1..32}; do
    sudo userdel nixbld$i 2>/dev/null || true
done
sudo groupdel nixbld 2>/dev/null || true

# Remove Nix directories
info "Removing Nix directories..."
sudo rm -rf /nix
sudo rm -rf /etc/nix
sudo rm -rf /var/root/.nix-profile
sudo rm -rf /var/root/.nix-defexpr
sudo rm -rf /var/root/.nix-channels

# Remove user-specific Nix files
info "Removing user Nix files..."
rm -rf ~/.nix-profile
rm -rf ~/.nix-defexpr
rm -rf ~/.nix-channels
rm -rf ~/.config/nix
rm -rf ~/.cache/nix
rm -rf ~/.local/state/nix

# Remove Home Manager files
info "Removing Home Manager files..."
rm -rf ~/.config/home-manager/.git 2>/dev/null || true
rm -rf ~/.local/state/home-manager
rm -rf ~/.cache/home-manager

# Clean up shell profiles
info "Cleaning up shell profiles..."

# Backup and clean .bashrc
if [ -f ~/.bashrc ]; then
    cp ~/.bashrc ~/.bashrc.bak.$(date +%s)
    grep -v "/nix/" ~/.bashrc > ~/.bashrc.tmp && mv ~/.bashrc.tmp ~/.bashrc || true
    grep -v "home-manager" ~/.bashrc > ~/.bashrc.tmp && mv ~/.bashrc.tmp ~/.bashrc || true
fi

# Backup and clean .zshrc
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
    grep -v "/nix/" ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc || true
    grep -v "home-manager" ~/.zshrc > ~/.zshrc.tmp && mv ~/.zshrc.tmp ~/.zshrc || true
fi

# Clean up profile files
info "Cleaning up profile files..."
sudo rm -f /etc/profile.d/nix.sh
sudo rm -f /etc/bash.bashrc.backup-before-nix
sudo rm -f /etc/bashrc.backup-before-nix
sudo rm -f /etc/zshrc.backup-before-nix

# Remove from /etc/synthetic.conf (macOS)
if [ -f /etc/synthetic.conf ]; then
    sudo sed -i.bak '/nix/d' /etc/synthetic.conf
fi

# Clean PATH and environment variables from current session
info "Cleaning current session environment..."
export PATH=$(echo $PATH | tr ':' '\n' | grep -v '/nix/' | tr '\n' ':' | sed 's/:$//')
unset NIX_PATH
unset NIX_PROFILES
unset NIX_SSL_CERT_FILE
unset NIX_USER_PROFILE_DIR

# Remove any remaining Nix references from common locations
info "Removing remaining references..."
sudo find /usr /opt /var 2>/dev/null | xargs grep -l "nix" 2>/dev/null | while read file; do
    if [[ "$file" == *"nix"* ]]; then
        sudo rm -f "$file" 2>/dev/null || true
    fi
done 2>/dev/null || true

# Clean up any remaining processes
info "Cleaning up processes..."
pkill -f nix-daemon || true
pkill -f nix-store || true

success "Nix has been completely removed from your system!"
warning "Please restart your terminal or log out/in for changes to take effect."

info "Verification commands:"
echo "  - which nix        (should return nothing)"
echo "  - ls /nix          (should not exist)"
echo "  - echo \$PATH      (should not contain /nix/)"

info "Your shell config files have been backed up with timestamps."
info "You can now test the bootstrap script cleanly."
