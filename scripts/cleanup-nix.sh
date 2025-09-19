#!/bin/bash
# Quick Nix cleanup for testing bootstrap script

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

warning "This will clean up Nix installation for bootstrap testing"
read -p "Continue? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    info "Cancelled."
    exit 0
fi

# Method 1: Use nix-installer uninstall if available
if [ -f "/nix/nix-installer" ] && command -v /nix/nix-installer &> /dev/null; then
    info "Using nix-installer uninstall..."
    /nix/nix-installer uninstall || warning "Uninstaller failed, trying manual cleanup"
fi

# Method 2: Remove receipt and let bootstrap handle it
if [ -f "/nix/receipt.json" ]; then
    info "Removing Nix installation receipt..."
    sudo rm -f /nix/receipt.json || warning "Could not remove receipt.json"
fi

# Clear current session environment
info "Clearing current session Nix environment..."
export PATH=$(echo $PATH | tr ':' '\n' | grep -v '/nix/' | tr '\n' ':' | sed 's/:$//')
unset NIX_PATH 2>/dev/null || true
unset NIX_PROFILES 2>/dev/null || true

success "Nix cleanup completed!"
info "You can now run: ./bootstrap.sh"
info "Or with force reinstall: ./bootstrap.sh --force"
