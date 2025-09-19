#!/bin/bash
# Docker Test Script for Home Manager Configuration

set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

info "Starting Docker test of Home Manager configuration..."

# Get the current directory (where the config is)
CONFIG_DIR="$(pwd)"

# Test with Ubuntu
info "Testing with Ubuntu 22.04..."

# Create a test script to run inside the container
cat > /tmp/docker-test.sh << 'EOF'
#!/bin/bash
set -euo pipefail

echo "=== Inside Ubuntu Container ==="

# Install basic tools
apt update -qq
apt install -y curl git sudo

# Create test user
adduser testuser --disabled-password --gecos ""
echo "testuser:testuser" | chpasswd
usermod -aG sudo testuser

# Switch to test user and test installation
su testuser -c '
cd /home/testuser
echo "Cloning configuration..."
cp -r /mnt/config ./hm_config
cd hm_config
echo "Running bootstrap script..."
./bootstrap.sh
echo "Testing key tools..."
source ~/.nix-profile/etc/profile.d/nix.sh || source ~/.bashrc
which nix
which bat
which eza
echo "SUCCESS: Ubuntu test completed!"
'
EOF

chmod +x /tmp/docker-test.sh

# Run the test in Docker
docker run --rm -it \
  -v "$CONFIG_DIR:/mnt/config:ro" \
  -v "/tmp/docker-test.sh:/test.sh:ro" \
  ubuntu:22.04 \
  /test.sh

success "Docker test completed successfully!"

info "You can also run manual tests with:"
echo "  docker run --rm -it -v '$CONFIG_DIR:/mnt/config:ro' ubuntu:22.04 bash"
echo "  # Then inside container: cp -r /mnt/config ./hm_config && cd hm_config && ./bootstrap.sh"

rm -f /tmp/docker-test.sh
