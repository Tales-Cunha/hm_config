#!/bin/bash
# Personalize Home Manager Configuration

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

info "Personalizing Home Manager Configuration"
echo "======================================="

# Get user details
read -p "Enter your full name for Git: " FULLNAME
read -p "Enter your email for Git: " EMAIL

# Update git configuration
info "Updating Git configuration..."
sed -i "s/userName = \".*\"/userName = \"$FULLNAME\"/" programs/git.nix
sed -i "s/userEmail = \".*\"/userEmail = \"$EMAIL\"/" programs/git.nix

# Apply changes
info "Applying updated configuration..."
home-manager switch --flake ".#$(whoami)"

success "Configuration updated successfully!"
