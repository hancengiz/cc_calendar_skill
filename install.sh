#!/bin/bash

# Calendar Skill - Installation Script
# Installs the Calendar skill to ~/.claude/skills/

set -e # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILL_NAME="calendar"
INSTALL_DIR="$HOME/.claude/skills/$SKILL_NAME"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 📅 Calendar Skill Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if ~/.claude/skills directory exists
if [ ! -d "$HOME/.claude/skills" ]; then
 echo -e "${YELLOW}⚠️ Creating ~/.claude/skills directory...${NC}"
 mkdir -p "$HOME/.claude/skills"
 echo -e "${GREEN}✓${NC} Directory created"
 echo ""
fi

# Check if skill is already installed
if [ -d "$INSTALL_DIR" ] || [ -L "$INSTALL_DIR" ]; then
 echo -e "${YELLOW}⚠️ Calendar skill is already installed at:${NC}"
 echo " $INSTALL_DIR"
 echo ""
 read -p " Overwrite? (y/n) " -n 1 -r
 echo ""
 if [[ ! $REPLY =~ ^[Yy]$ ]]; then
 echo -e "${RED}✗${NC} Installation cancelled"
 exit 1
 fi
 echo -e "${YELLOW}→${NC} Removing existing installation..."
 rm -rf "$INSTALL_DIR"
 echo ""
fi

# Create the installation directory
echo -e "${YELLOW}→${NC} Creating skill directory..."
mkdir -p "$INSTALL_DIR"

# Copy skill files
echo -e "${YELLOW}→${NC} Installing Calendar skill files..."
cp "$SCRIPT_DIR/calendar_skill.py" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/" 2>/dev/null || true
cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/" 2>/dev/null || true
cp "$SCRIPT_DIR/calendar.md" "$INSTALL_DIR/" 2>/dev/null || true
cp "$SCRIPT_DIR/INSTALLATION.md" "$INSTALL_DIR/" 2>/dev/null || true

# Make the main script executable
chmod +x "$INSTALL_DIR/calendar_skill.py"

echo ""
echo -e "${GREEN}✓${NC} Installation successful!"
echo ""
echo "Installed at: $INSTALL_DIR"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. The skill is now available in Claude Code"
echo "2. Use it to manage your macOS Calendar events"
echo "3. Examples:"
echo "   - Create: calendar-skill create \"Meeting\" \"tomorrow at 2pm\""
echo "   - List: calendar-skill calendars"
echo "   - Read: calendar-skill read today"
echo ""
echo "4. For full documentation, see README.md"
echo ""
