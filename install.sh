#!/bin/bash
#
# Calendar Skill Installation Script
# Installs the Claude Code macOS Calendar Skill to user and system levels
#
# Usage: bash install.sh [--system]
#
# --system: Install to /usr/local/bin (requires sudo)
# (default): Install to ~/.local/bin (no sudo required)
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILL_NAME="calendar-skill"
SKILL_FILE="calendar_skill.py"

# Determine installation level
INSTALL_SYSTEM=false
if [[ "$1" == "--system" ]]; then
    INSTALL_SYSTEM=true
fi

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Claude Code macOS Calendar Skill Installer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# Check if skill file exists
if [ ! -f "$SCRIPT_DIR/$SKILL_FILE" ]; then
    echo -e "${RED}✗ Error: $SKILL_FILE not found in $SCRIPT_DIR${NC}"
    exit 1
fi

if [ "$INSTALL_SYSTEM" = true ]; then
    # System-level installation
    INSTALL_DIR="/usr/local/bin"
    INSTALL_LEVEL="System Level"

    echo -e "${YELLOW}System Level Installation${NC}"
    echo "Installing to: $INSTALL_DIR"
    echo "This requires sudo access."
    echo

    if ! command -v sudo &> /dev/null; then
        echo -e "${RED}✗ Error: sudo not found${NC}"
        exit 1
    fi

    echo -e "${YELLOW}→${NC} Copying $SKILL_FILE to $INSTALL_DIR/$SKILL_NAME..."
    sudo cp "$SCRIPT_DIR/$SKILL_FILE" "$INSTALL_DIR/$SKILL_NAME"

    echo -e "${YELLOW}→${NC} Making executable..."
    sudo chmod +x "$INSTALL_DIR/$SKILL_NAME"

    # Verify installation
    if [ -x "$INSTALL_DIR/$SKILL_NAME" ]; then
        echo -e "${GREEN}✓ System-level installation successful!${NC}"
        echo
        echo "You can now use the skill from anywhere:"
        echo -e "  ${BLUE}calendar-skill read today${NC}"
        echo -e "  ${BLUE}calendar-skill create \"Event\" \"tomorrow at 2pm\"${NC}"
        echo
    else
        echo -e "${RED}✗ Installation failed${NC}"
        exit 1
    fi
else
    # User-level installation
    INSTALL_DIR="$HOME/.local/bin"
    INSTALL_LEVEL="User Level"

    echo -e "${YELLOW}User Level Installation${NC}"
    echo "Installing to: $INSTALL_DIR"
    echo "No sudo required - only for your user account."
    echo

    # Create directory if it doesn't exist
    if [ ! -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}→${NC} Creating directory $INSTALL_DIR..."
        mkdir -p "$INSTALL_DIR"
    fi

    echo -e "${YELLOW}→${NC} Copying $SKILL_FILE to $INSTALL_DIR/$SKILL_NAME..."
    cp "$SCRIPT_DIR/$SKILL_FILE" "$INSTALL_DIR/$SKILL_NAME"

    echo -e "${YELLOW}→${NC} Making executable..."
    chmod +x "$INSTALL_DIR/$SKILL_NAME"

    # Verify installation
    if [ -x "$INSTALL_DIR/$SKILL_NAME" ]; then
        echo -e "${GREEN}✓ User-level installation successful!${NC}"
        echo

        # Check if .local/bin is in PATH
        if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
            echo "✓ $INSTALL_DIR is already in your PATH"
            echo
            echo "You can now use the skill from anywhere:"
            echo -e "  ${BLUE}calendar-skill read today${NC}"
            echo -e "  ${BLUE}calendar-skill create \"Event\" \"tomorrow at 2pm\"${NC}"
        else
            echo -e "${YELLOW}⚠ Warning: $INSTALL_DIR is not in your PATH${NC}"
            echo
            echo "To use the skill from anywhere, add to your shell configuration:"
            echo
            echo "For Bash (~/.bashrc):"
            echo -e "  ${BLUE}export PATH=\$HOME/.local/bin:\$PATH${NC}"
            echo
            echo "For Zsh (~/.zshrc):"
            echo -e "  ${BLUE}export PATH=\$HOME/.local/bin:\$PATH${NC}"
            echo
            echo "Then reload your shell:"
            echo -e "  ${BLUE}source ~/.zshrc${NC}  (or source ~/.bashrc)"
            echo
            echo "Or use the full path for now:"
            echo -e "  ${BLUE}~/.local/bin/calendar-skill read today${NC}"
        fi
    else
        echo -e "${RED}✗ Installation failed${NC}"
        exit 1
    fi
fi

echo
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Installation Complete!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo
echo "Next steps:"
echo "1. Verify installation: calendar-skill calendars"
echo "2. Create a test event: calendar-skill create \"Test\" \"tomorrow at 2pm\" --test"
echo "3. Check the docs: README.md for full usage guide"
echo
