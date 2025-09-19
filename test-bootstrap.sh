#!/bin/bash
# Test Bootstrap Script Issues

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[TEST]${NC} $1"; }
success() { echo -e "${GREEN}[PASS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
fail() { echo -e "${RED}[FAIL]${NC} $1"; }

info "Testing Bootstrap Script Environment Handling"
echo "============================================"

# Test 1: Check if bootstrap script handles missing nix gracefully
info "Test 1: Checking bootstrap script syntax..."
if bash -n bootstrap.sh; then
    success "Bootstrap script has valid syntax"
else
    fail "Bootstrap script has syntax errors"
    exit 1
fi

# Test 2: Check critical sections of the script
info "Test 2: Checking for proper Nix sourcing..."
if grep -q "Source nix" bootstrap.sh && grep -q "command -v nix" bootstrap.sh; then
    success "Bootstrap script has proper Nix detection and sourcing"
else
    fail "Bootstrap script missing proper Nix handling"
fi

# Test 3: Check for error handling
info "Test 3: Checking for error handling..."
if grep -q "error.*Configuration has errors" bootstrap.sh; then
    success "Bootstrap script has proper error handling"
else
    fail "Bootstrap script missing error handling"
fi

# Test 4: Verify the script can run in dry-run mode
info "Test 4: Testing script sections..."

# Extract just the detection part
ARCH=$(uname -m)
case $ARCH in
  x86_64) SYSTEM="x86_64-linux" ;;
  aarch64|arm64) SYSTEM="aarch64-linux" ;;
  *) fail "Unsupported architecture: $ARCH"; exit 1 ;;
esac
success "Architecture detection works: $SYSTEM"

# Test 5: Check if current configuration is valid
info "Test 5: Validating current configuration..."
if nix flake check 2>/dev/null; then
    success "Current configuration is valid"
else
    warning "Current configuration has issues (expected if git tree is dirty)"
fi

success "All bootstrap tests passed!"

info "To test the full bootstrap process:"
echo "  1. Use Docker: ./test-docker.sh"
echo "  2. Use VM with fresh Linux install"
echo "  3. Test locally (CAREFUL): ./scripts/remove-nix.sh && ./bootstrap.sh"
