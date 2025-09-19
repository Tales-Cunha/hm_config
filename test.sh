#!/bin/bash
# Test Home Manager Configuration

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[TEST]${NC} $1"; }
success() { echo -e "${GREEN}[PASS]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }

info "Testing Home Manager Configuration"
echo "================================="

# Test 1: Flake syntax
info "Checking flake syntax..."
if nix flake check; then
  success "Flake syntax is valid"
else
  fail "Flake has syntax errors"
  exit 1
fi

# Test 2: Build configuration
info "Building configuration..."
USER=$(whoami)
if nix build ".#homeConfigurations.$USER.activationPackage" --no-link; then
  success "Configuration builds successfully"
else
  fail "Configuration build failed"
  exit 1
fi

# Test 3: Architecture detection
ARCH=$(nix eval --impure --expr 'builtins.currentSystem' --raw)
info "Detected architecture: $ARCH"
if [[ "$ARCH" =~ ^(x86_64-linux|aarch64-linux)$ ]]; then
  success "Architecture is supported"
else
  fail "Unsupported architecture: $ARCH"
  exit 1
fi

success "All tests passed! Configuration is ready for deployment."
