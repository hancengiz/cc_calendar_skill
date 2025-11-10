---
name: calendar-skill
description: Create, read, and delete macOS Calendar events directly from Claude Code using natural language. Manage your calendar without leaving the terminal.
---

# Calendar Skill for Claude Code

A powerful Claude Code skill for seamless integration with your macOS Calendar. Create, read, and manage calendar events using natural language.

## What This Skill Does

- **Create events** with natural language: `"Team meeting tomorrow at 2pm"`
- **List all calendars** on your system
- **Delete events** by title and date
- **Query events** for specific dates or date ranges
- **Preview events** before creating with test mode

## How to Use

### Installation

```bash
# Install to your user bin (recommended)
bash install.sh

# Or install to system bin (requires sudo)
bash install.sh --system
```

Once installed, use from anywhere:

```bash
calendar-skill calendars
calendar-skill create "Team Meeting" "tomorrow at 2pm"
calendar-skill read today
calendar-skill delete "Team Meeting" "tomorrow"
```

### Common Commands

**Create an event:**
```bash
calendar-skill create "Project Review" "Friday at 10am" \
  --location "Conference Room B" \
  --notes "Q4 planning discussion"
```

**Preview before creating:**
```bash
calendar-skill create "Event" "tomorrow at 3pm" --test
```

**List all your calendars:**
```bash
calendar-skill calendars
```

**Read events:**
```bash
calendar-skill read today
calendar-skill read "next Monday"
calendar-skill range today "next Friday"
```

**Delete an event:**
```bash
calendar-skill delete "Team Meeting" "tomorrow"
```

## Features

✅ **Natural Language Dates**
- `today`, `tomorrow`, `next Monday`, `this Friday`
- `2025-11-12`, `2025-11-12 at 2pm`

✅ **Event Management**
- Create with duration, location, and notes
- Delete by title and date
- List all calendars

✅ **Test Mode**
- Preview events before creating
- No changes made with `--test` flag

✅ **Python API**
- Use programmatically in Python scripts
- Full API documentation in `calendar.md`

## Requirements

- macOS 10.15 or later
- Python 3.6+
- Calendar app installed (default on macOS)

## Documentation

- **README.md** - User guide with examples
- **calendar.md** - Full API reference
- **INSTALLATION.md** - Setup and troubleshooting
- **install.sh** - Automated installation script

## Quick Example

```bash
# List your calendars
$ calendar-skill calendars
📚 Available Calendars:
  • Calendar
  • Personal
  • Work

# Create an event
$ calendar-skill create "Team Standup" "tomorrow at 9am"
✅ Event created: Team Standup
   📅 Wednesday, November 12 at 09:00

# Verify it was created
$ calendar-skill read tomorrow
📅 Events (1 total):
================================================================================

  📌 Team Standup
     🕐 09:00 AM - 10:00 AM

================================================================================
```

## Integration with Other Skills

Combine with your **obsidian-vault** skill to create daily notes with tomorrow's meetings:

```bash
#!/bin/bash
TOMORROW_MEETINGS=$(calendar-skill read tomorrow)
# Then append to your Obsidian daily note...
```

## Support

- See **README.md** for detailed usage guide
- See **calendar.md** for API documentation
- Run `calendar-skill --help` for command help
- Check **INSTALLATION.md** for troubleshooting

---

**Version**: 1.0.0
**License**: MIT
**Author**: Claude Code
**Repository**: https://github.com/hancengiz/cc_calendar_skill
