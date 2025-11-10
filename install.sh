#!/bin/bash

# Calendar Skill - Installation Script
# Installs the Calendar skill to ~/.claude/skills/

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILL_NAME="calendar"
INSTALL_DIR="$HOME/.claude/skills/$SKILL_NAME"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " 📅 Calendar Skill Installer"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ ! -d "$HOME/.claude/skills" ]; then
 echo -e "${YELLOW}⚠️ Creating ~/.claude/skills directory...${NC}"
 mkdir -p "$HOME/.claude/skills"
 echo -e "${GREEN}✓${NC} Directory created"
 echo ""
fi

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

echo -e "${YELLOW}→${NC} Creating skill directory..."
mkdir -p "$INSTALL_DIR"

echo -e "${YELLOW}→${NC} Installing Calendar skill..."
cp "$SCRIPT_DIR/SKILL.md" "$INSTALL_DIR/"

echo ""
echo -e "${GREEN}✓${NC} Installation successful!"
echo ""
echo "Installed at: $INSTALL_DIR"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo " Next Steps"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The Calendar skill is now available in Claude Code"
echo ""
echo "Quick examples:"
echo "  calendar-skill create \"Meeting\" \"tomorrow at 2pm\""
echo "  calendar-skill calendars"
echo "  calendar-skill read today"
echo ""
