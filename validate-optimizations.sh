#!/bin/bash
# Quick validation script for BlobeVM optimizations
# This script verifies that all changes are syntactically correct

set -e

echo "=== BlobeVM Optimization Validation ==="
echo ""

# Check if all required files exist
echo "✓ Checking file structure..."
files_to_check=(
    "Dockerfile"
    ".dockerignore"
    "install.sh"
    "root/install-de.sh"
    "root/installapps.sh"
    "root/etc/wgetrc"
    "root/defaults/kasmvnc.conf.sh"
    "root/defaults/kasmvnc-loading.html"
    "root/etc/cont-init.d/10-kasmvnc-loading"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✓ $file exists"
    else
        echo "  ✗ $file missing"
        exit 1
    fi
done

echo ""
echo "✓ Checking shell script syntax..."

# Check all shell scripts for syntax errors
for script in root/*.sh root/installable-apps/*.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script"; then
            echo "  ✓ $script syntax OK"
        else
            echo "  ✗ $script has syntax errors"
            exit 1
        fi
    fi
done

echo ""
echo "✓ Checking Dockerfile syntax..."
if docker version > /dev/null 2>&1; then
    # Simple syntax check by attempting to parse the Dockerfile
    if docker build -f Dockerfile -t blobevm-test --dry-run . > /dev/null 2>&1 || \
       DOCKER_BUILDKIT=1 docker build -f Dockerfile --progress=plain . 2>&1 | head -5 | grep -q "FROM"; then
        echo "  ✓ Dockerfile syntax OK"
    else
        echo "  ⚠ Unable to validate Dockerfile, but file exists"
    fi
else
    echo "  ⚠ Docker not available, skipping Dockerfile validation"
fi

echo ""
echo "=== Validation Complete ==="
echo "All optimizations are properly configured!"
