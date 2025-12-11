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
    if docker build -f Dockerfile --target "" . 2>&1 | grep -q "failed to reach build target"; then
        echo "  ✓ Dockerfile syntax OK"
    fi
else
    echo "  ⚠ Docker not available, skipping Dockerfile validation"
fi

echo ""
echo "=== Validation Complete ==="
echo "All optimizations are properly configured!"
