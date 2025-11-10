# Installation & Setup Guide

## Quick Install

The calendar skill has been created in both locations:
- **Development**: `/Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill/`
- **Claude Code**: `~/.claude/skills/calendar/`

### Verify Installation

```bash
# Check Claude Code installation
ls ~/.claude/skills/calendar/

# Should show:
# calendar.md
# calendar_skill.py
# README.md
# INSTALLATION.md
```

## Usage from Claude Code

Once installed, use the skill directly:

```bash
# From anywhere, access the skill
python3 ~/.claude/skills/calendar/calendar_skill.py read tomorrow
python3 ~/.claude/skills/calendar/calendar_skill.py create "Meeting" "tomorrow at 2pm"
```

### Create an Alias (Optional)

For easier access, create a shell alias in your `.bashrc` or `.zshrc`:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias calendar='python3 ~/.claude/skills/calendar/calendar_skill.py'

# Now use as:
calendar read tomorrow
calendar create "Event" "tomorrow at 3pm"
calendar calendars
```

## Permissions

The first time you run the skill, macOS may ask for permissions:

1. **Calendar Access**: Grant permission when prompted
2. **Full Disk Access** (if needed): System Preferences → Security & Privacy → Full Disk Access → Add Terminal

## Files

| File | Purpose |
|------|---------|
| `calendar_skill.py` | Main skill implementation (executable) |
| `calendar.md` | Detailed API documentation |
| `README.md` | User-friendly guide and examples |
| `INSTALLATION.md` | This file (setup instructions) |

## Development

To modify or extend the skill:

```bash
# Edit the main skill
vim ~/.claude/skills/calendar/calendar_skill.py

# Test changes
python3 ~/.claude/skills/calendar/calendar_skill.py --help

# Or from development directory
cd /Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill
python3 calendar_skill.py read today
```

## Troubleshooting

### "No events found" when they exist

The read events feature has limited AppleScript compatibility. This is being improved. In the meantime:
- Event **creation** works perfectly ✅
- Event **deletion** works with the skill
- Event **listing by calendar** works ✅
- Test mode previews work great ✅

### Script not found

Make sure you're using the correct path:
```bash
# Correct
python3 ~/.claude/skills/calendar/calendar_skill.py read today

# Not correct
python3 calendar_skill.py read today  # (unless you're in the directory)
```

### Permission denied

Make both files executable:
```bash
chmod +x ~/.claude/skills/calendar/calendar_skill.py
chmod +x ~/.claude/skills/calendar/calendar.md
```

## Next Steps

1. **Try it out**: `python3 ~/.claude/skills/calendar/calendar_skill.py create "Test Event" "tomorrow at 2pm"`
2. **Check your calendar**: Open Calendar.app to verify the event was created
3. **Explore features**: See `README.md` for all available commands
4. **Integrate**: Combine with other Claude Code skills (like obsidian-vault)

## Version Info

- **Version**: 1.0.0
- **Created**: November 11, 2025
- **Platform**: macOS 10.15+
- **Python**: 3.6+
- **Status**: Production ready (event creation/deletion fully functional)

## Support

For help:
1. Check `README.md` for usage examples
2. Check `calendar.md` for detailed API documentation
3. Try `python3 ~/.claude/skills/calendar/calendar_skill.py --help`

---

**Ready to use! Your calendar is now accessible from the terminal.** 🎉
