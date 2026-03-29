#!/bin/bash
# install.sh — installs minimize-active and sets up Meta+Shift+D shortcut

set -e

echo "=== minimize-active installer ==="

# Check dependencies
MISSING=()
command -v kscreen-doctor &>/dev/null || MISSING+=("kscreen")
command -v qdbus6 &>/dev/null || MISSING+=("qt6-tools")

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "Installing missing dependencies: ${MISSING[*]}"
    sudo pacman -S --needed "${MISSING[@]}"
fi

# Install script
mkdir -p ~/.local/bin
cp minimize-active.sh ~/.local/bin/minimize-active.sh
chmod +x ~/.local/bin/minimize-active.sh
echo "✓ Script installed to ~/.local/bin/minimize-active.sh"

# Register KDE shortcut via kglobalaccel / kwriteconfig
KSHORTCUTS="$HOME/.config/kglobalshortcutsrc"

if ! grep -q 'minimize-active' "$KSHORTCUTS" 2>/dev/null; then
    kwriteconfig6 --file kglobalshortcutsrc \
        --group "minimize-active.sh" \
        --key "_k_friendly_name" "Minimize active screen"
    kwriteconfig6 --file kglobalshortcutsrc \
        --group "minimize-active.sh" \
        --key "minimize-active" \
        "Meta+Shift+D,none,Minimize active screen"
    echo "✓ Shortcut Meta+Shift+D registered"
    echo "  Note: You may need to set it manually in System Settings → Shortcuts"
    echo "  if it does not appear automatically."
else
    echo "✓ Shortcut already registered"
fi

echo ""
echo "Done! Test it with:"
echo "  ~/.local/bin/minimize-active.sh"
echo ""
echo "Or bind it manually in:"
echo "  System Settings → Shortcuts → Add New → Command or Script"
echo "  Command: /home/$USER/.local/bin/minimize-active.sh"
echo "  Shortcut: Meta+Shift+D"
