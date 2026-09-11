#!/bin/bash

# Reformed Chinese Input Method for macOS Installation Script
# This script installs the Reformed Chinese input method for Squirrel (鼠鬚管)

set -e  # Exit on error

echo "=========================================="
echo "Reformed Chinese Keyboard for macOS Installation"
echo "=========================================="
echo ""

# Define paths
RIME_DIR="$HOME/Library/Rime"
LUA_DIR="$RIME_DIR/lua"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SQUIRREL_CASK="squirrel-app"
SQUIRREL_IM_PATH="/Library/Input Methods/Squirrel.app"
SQUIRREL_IM_PATH_USER="$HOME/Library/Input Methods/Squirrel.app"
NEEDS_LOGOUT=false

# Check if Squirrel is installed
echo "Checking for Squirrel installation..."
SQUIRREL_INSTALLED=false

if [ -d "$SQUIRREL_IM_PATH" ] || [ -d "$SQUIRREL_IM_PATH_USER" ]; then
    SQUIRREL_INSTALLED=true
fi

if [ "$SQUIRREL_INSTALLED" = false ]; then
    echo "⚠️  Squirrel is not installed"
    echo ""
    echo "Attempting to install Squirrel automatically..."
    echo ""
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "⚠️  Homebrew is not installed"
        echo ""
        echo "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # A freshly installed Homebrew isn't on PATH in this shell yet (Apple Silicon
        # installs to /opt/homebrew, Intel to /usr/local) — pick it up before rechecking.
        if ! command -v brew &> /dev/null; then
            if [ -x /opt/homebrew/bin/brew ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            elif [ -x /usr/local/bin/brew ]; then
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi

        if ! command -v brew &> /dev/null; then
            echo "❌ Failed to install Homebrew"
            echo ""
            echo "Please install Squirrel manually:"
            echo "1. Visit: https://rime.im/"
            echo "2. Download and install Squirrel"
            echo "3. Run this installer again"
            echo ""
            exit 1
        fi
        echo "✅ Homebrew installed"
        echo ""
    fi
    
    # Install Squirrel using Homebrew with a fallback for cleanup issues
    echo "Installing Squirrel via Homebrew..."
    if ! brew install --cask "$SQUIRREL_CASK"; then
        echo "⚠️  Homebrew install failed, retrying with cleanup disabled..."
        if ! HOMEBREW_NO_INSTALL_CLEANUP=1 brew install --cask "$SQUIRREL_CASK"; then
            echo "❌ Failed to install Squirrel"
            echo ""
            echo "Please install Squirrel manually:"
            echo "1. Visit: https://rime.im/"
            echo "2. Download and install Squirrel"
            echo "3. Run this installer again"
            echo ""
            exit 1
        fi
    fi

    if [ -d "$SQUIRREL_IM_PATH" ] || [ -d "$SQUIRREL_IM_PATH_USER" ]; then
        echo "✅ Squirrel installation detected"
        [ -d "$SQUIRREL_IM_PATH" ] && echo "   - $SQUIRREL_IM_PATH"
        [ -d "$SQUIRREL_IM_PATH_USER" ] && echo "   - $SQUIRREL_IM_PATH_USER"
        NEEDS_LOGOUT=true
    else
        echo "❌ Squirrel installation did not complete"
        echo ""
        echo "Expected input method at:"
        echo "- $SQUIRREL_IM_PATH"
        echo "- $SQUIRREL_IM_PATH_USER"
        echo ""
        echo "Please install Squirrel manually:"
        echo "1. Visit: https://rime.im/"
        echo "2. Download and install Squirrel"
        echo "3. Run this installer again"
        echo ""
        exit 1
    fi
else
    echo "✅ Squirrel is already installed"
fi
echo ""

# Create Rime directory if it doesn't exist
echo "Setting up Rime directories..."
mkdir -p "$RIME_DIR"
mkdir -p "$LUA_DIR"
echo "✅ Directories ready"
echo ""

# Copy schema files
echo "Installing Reformed Chinese schema files..."
cp "$SCRIPT_DIR/reformed.schema.yaml" "$RIME_DIR/"
cp "$SCRIPT_DIR/reformed.dict.yaml" "$RIME_DIR/"
cp "$SCRIPT_DIR/squirrel.custom.yaml" "$RIME_DIR/"
echo "✅ Schema files installed"
echo ""

# Copy Lua filters (preserving UTF-8 encoding)
echo "Installing Lua filters..."
cp "$SCRIPT_DIR/lua/reformed_filter.lua" "$LUA_DIR/"
cp "$SCRIPT_DIR/lua/reformed_commit_filter.lua" "$LUA_DIR/"
cp "$SCRIPT_DIR/rime.lua" "$RIME_DIR/"
echo "✅ Lua filters installed"
echo ""

# Create or update default.custom.yaml
echo "Configuring default input method..."
DEFAULT_CUSTOM="$RIME_DIR/default.custom.yaml"

if [ -f "$DEFAULT_CUSTOM" ]; then
    echo "⚠️  default.custom.yaml already exists"
    echo "   Backing up to default.custom.yaml.backup"
    cp "$DEFAULT_CUSTOM" "$DEFAULT_CUSTOM.backup"
fi

cat > "$DEFAULT_CUSTOM" << 'EOF'
patch:
  schema_list:
    - schema: reformed
  menu:
    page_size: 9
EOF

echo "✅ Default configuration set"
echo ""

# Verify installation
echo "Verifying installation..."
REQUIRED_FILES=(
    "$RIME_DIR/reformed.schema.yaml"
    "$RIME_DIR/reformed.dict.yaml"
    "$RIME_DIR/rime.lua"
    "$LUA_DIR/reformed_filter.lua"
    "$LUA_DIR/reformed_commit_filter.lua"
    "$RIME_DIR/default.custom.yaml"
    "$RIME_DIR/squirrel.custom.yaml"
)

ALL_PRESENT=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "❌ Missing: $file"
        ALL_PRESENT=false
    fi
done

if [ "$ALL_PRESENT" = true ]; then
    echo "✅ All files installed successfully"
    echo "Installed files:"
    for file in "${REQUIRED_FILES[@]}"; do
        echo "  - $file"
    done
else
    echo "❌ Some files are missing"
    exit 1
fi
echo ""

# Ensure the reformed schema is present in default.custom.yaml
if ! grep -q "schema: reformed" "$DEFAULT_CUSTOM"; then
    echo "❌ default.custom.yaml does not reference the reformed schema"
    echo "Please re-run this installer or inspect: $DEFAULT_CUSTOM"
    exit 1
fi
echo "✅ default.custom.yaml includes reformed schema"
echo ""

# Deploy: (re)launching Squirrel recompiles the schemas into the build dir.
# Note: "open -a Squirrel" often fails since Launch Services doesn't reliably
# resolve apps installed under /Library/Input Methods by name, so open by path.
echo "Deploying configuration to Squirrel..."
rm -rf "$HOME/Library/Rime/build" 2>/dev/null
killall Squirrel 2>/dev/null || true
sleep 1
if [ -d "$SQUIRREL_IM_PATH_USER" ]; then
    open "$SQUIRREL_IM_PATH_USER" 2>/dev/null || true
elif [ -d "$SQUIRREL_IM_PATH" ]; then
    open "$SQUIRREL_IM_PATH" 2>/dev/null || true
fi
sleep 2
echo ""

# Confirm the reformed schema is loaded into the build output
echo "Verifying deployment..."
BUILD_DIR="$HOME/Library/Rime/build"
RETRIES=5
FOUND_REFORMED=false
for i in $(seq 1 "$RETRIES"); do
    if ls "$BUILD_DIR" 2>/dev/null | grep -qi "reformed"; then
        FOUND_REFORMED=true
        break
    fi
    sleep 1
done

if [ "$FOUND_REFORMED" = true ]; then
    echo "✅ Deployment verified"
else
    if [ "$NEEDS_LOGOUT" = true ]; then
        echo "⚠️  Deployment not yet confirmed (expected until Squirrel is added to Input Sources)"
        echo "   Files are installed correctly; follow the steps below to finish setup."
    else
        echo "❌ Deployment could not be confirmed"
        echo "Troubleshooting:"
        echo "- Ensure Squirrel is enabled in Input Sources"
        echo "- Log out and log back in, then run this script again"
        echo "- Check logs: ~/Library/Logs/Squirrel.log"
        exit 1
    fi
fi
echo ""
echo "=========================================="
echo "Installation Complete"
echo "=========================================="
echo ""
echo "✅ Reformed Chinese Keyboard is now installed!"
echo ""
echo "⚠️  IMPORTANT: Final steps below required"
echo ""
if [ "$NEEDS_LOGOUT" = true ]; then
    echo "Step 1: Add Squirrel to Input Sources"
    echo "   1. Open System Settings → Keyboard → Input Sources"
    echo "   2. Click the '+' button"
    echo "   3. Search for 'Squirrel' and add. Either 'Squirrel - Traditional' or 'Squirrel - Simplified' is fine"
    echo ""
    echo "Step 2: Log out and log back in to macOS"
    echo "   Squirrel will appear in the menu bar after logging back in."
    echo ""
    echo "Step 3: Start using Reformed Chinese"
else
    echo "Step 1: Enable Squirrel as an input source"
    echo "   1. Open System Settings → Keyboard → Input Sources"
    echo "   2. Click the '+' button"
    echo "   3. Find and add 'Squirrel - Simplified' or 'Squirrel - Traditional' (either is fine)"
    echo ""
    echo "Step 2: Start using Reformed Chinese"
fi
echo "   1. Select 'Squirrel' from your input menu (menu bar)"
echo "   2. Now you can type 拼音 pinyin to output Reformed Chinese characters 🥳"
echo ""