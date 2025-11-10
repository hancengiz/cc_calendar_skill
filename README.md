# Claude Code macOS Calendar Skill

A powerful, easy-to-use Claude Code skill that brings your macOS Calendar to the terminal. Create, read, and manage calendar events entirely from the command line using natural language.

## 🎯 Quick Start

```bash
# Read today's events
python3 calendar_skill.py read today

# Read tomorrow's events
python3 calendar_skill.py read tomorrow

# Create a meeting
python3 calendar_skill.py create "Team Sync" "tomorrow at 2pm"

# Preview an event before creating (test mode)
python3 calendar_skill.py create "Meeting" "Friday at 10am" --test

# Delete an event
python3 calendar_skill.py delete "Team Sync" "tomorrow"

# See all your calendars
python3 calendar_skill.py calendars

# Get week ahead
python3 calendar_skill.py range today "next Friday"
```

## ✨ Features

| Feature | Command | Example |
|---------|---------|---------|
| **Read Events** | `read` | `python3 calendar_skill.py read tomorrow` |
| **Create Events** | `create` | `python3 calendar_skill.py create "Meeting" "tomorrow at 2pm"` |
| **Delete Events** | `delete` | `python3 calendar_skill.py delete "Meeting" "tomorrow"` |
| **Date Range** | `range` | `python3 calendar_skill.py range today "next Friday"` |
| **List Calendars** | `calendars` | `python3 calendar_skill.py calendars` |
| **Test Mode** | `--test` | `python3 calendar_skill.py create "Event" "tomorrow" --test` |

## 📦 Installation

### Option 1: Install to Claude Code Skills Directory

```bash
# Create skills directory
mkdir -p ~/.claude/skills/calendar

# Copy files
cp calendar_skill.py ~/.claude/skills/calendar/
cp calendar.md ~/.claude/skills/calendar/

# Make executable
chmod +x ~/.claude/skills/calendar/calendar_skill.py
```

### Option 2: Keep in Development Directory

```bash
# Just use the local directory
cd /Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill
python3 calendar_skill.py read today
```

### Option 3: Add to PATH

```bash
# Create symlink to bin directory
ln -s /Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill/calendar_skill.py \
      /usr/local/bin/calendar-skill

# Now use from anywhere
calendar-skill read today
```

## 🔐 Permissions Setup

When you first run the skill, macOS may ask for permissions. Grant access to:

1. **Calendar Access**
   - System Preferences → Security & Privacy → Privacy → Calendar
   - Add Terminal (or your terminal app)

2. **Full Disk Access** (if Calendar access is insufficient)
   - System Preferences → Security & Privacy → Privacy → Full Disk Access
   - Add Terminal (or your terminal app)

## 📚 Usage Guide

### Reading Events

**Get today's events:**
```bash
python3 calendar_skill.py read today
```

**Get tomorrow's events:**
```bash
python3 calendar_skill.py read tomorrow
```

**Get events for a specific date:**
```bash
python3 calendar_skill.py read 2025-11-15
python3 calendar_skill.py read "next Monday"
python3 calendar_skill.py read "next Friday"
```

**Get events in a date range:**
```bash
python3 calendar_skill.py range today "next week"
python3 calendar_skill.py range "2025-11-10" "2025-11-20"
python3 calendar_skill.py range "last Monday" "this Friday"
```

### Creating Events

**Basic event:**
```bash
python3 calendar_skill.py create "Team Meeting" "tomorrow at 2pm"
```

**With location:**
```bash
python3 calendar_skill.py create "Project Review" "Friday at 10am" \
  --location "Conference Room A"
```

**With notes:**
```bash
python3 calendar_skill.py create "Strategy Session" "next Monday at 1pm" \
  --notes "Discuss Q4 roadmap and priorities"
```

**With custom duration:**
```bash
# 2-hour meeting
python3 calendar_skill.py create "Workshop" "tomorrow at 9am" --duration 120

# 30-minute standup
python3 calendar_skill.py create "Standup" "tomorrow at 10am" --duration 30
```

**To a specific calendar:**
```bash
# Default is "Calendar", but you can specify others
python3 calendar_skill.py create "Birthday" "next March 15" --calendar Personal

# Check available calendars first
python3 calendar_skill.py calendars
```

**Test mode (preview without creating):**
```bash
python3 calendar_skill.py create "Test Event" "tomorrow at 3pm" --test
```

### Managing Events

**Delete an event:**
```bash
python3 calendar_skill.py delete "Team Meeting" "tomorrow"

# From specific calendar
python3 calendar_skill.py delete "Birthday" "2025-03-15" --calendar Personal
```

**List all calendars:**
```bash
python3 calendar_skill.py calendars
```

## 🗓️ Natural Language Date Support

The skill understands:

### Relative Dates
- `today` - current day
- `tomorrow` - next day
- `yesterday` - previous day
- `next Monday` - next occurrence of Monday
- `this Friday` - Friday of current week

### ISO Format
- `2025-11-12` - explicit date

### Times
- `2pm`, `2:00pm`, `14:00` - 2:00 PM
- `9:30am`, `9:30 AM`, `09:30` - 9:30 AM
- Combined: `tomorrow at 2pm`, `Friday at 10:30 AM`

### Examples
```bash
# Tomorrow at 2 PM
python3 calendar_skill.py create "Meeting" "tomorrow at 2pm"

# Next Monday at 10 AM
python3 calendar_skill.py create "Standup" "next Monday at 10am"

# Specific date and time
python3 calendar_skill.py create "Deadline" "2025-11-20 at 5:00pm"

# Without explicit time (defaults to midnight)
python3 calendar_skill.py read 2025-11-15
```

## 🐍 Python API

Use the skill in your Python code:

```python
from calendar_skill import CalendarSkill

cal = CalendarSkill()

# Read events
events = cal.get_events_for_date("tomorrow")
print(f"Found {len(events)} events")

# Display with formatting
cal.display_events(events)

# Create event
success = cal.create_event(
    title="Project Sync",
    date_time="tomorrow at 2pm",
    duration_minutes=60,
    location="Zoom",
    notes="Discuss project timeline"
)

# Get date range
events = cal.get_events_date_range("today", "next Friday")
for event in events:
    print(f"{event['date']}: {event['title']} at {event['start_time']}")

# List calendars
calendars = cal.list_calendars()
for cal_name in calendars:
    print(f"📅 {cal_name}")

# Delete event
cal.delete_event("Team Meeting", "tomorrow")
```

## 📋 Output Examples

### Reading Events
```
📅 Events (3 total):
================================================================================

  📌 Daily Standup
     🕐 09:00 AM - 09:30 AM
     📍 Team Room

  📌 Project Review
     🕐 02:00 PM - 03:00 PM
     📍 Conference Room B
     📝 Discuss Q4 progress

  📌 1:1 with Manager
     🕐 03:30 PM - 04:00 PM

================================================================================
```

### Creating Events
```
✅ Event created: Team Meeting
   📅 Tuesday, November 12 at 14:00
```

### Test Mode
```
📅 Event Preview (Test Mode):
   Title: Team Meeting
   Start: 2025-11-12 14:00
   End: 2025-11-12 15:00
   Calendar: Calendar
```

### Listing Calendars
```
📚 Available Calendars:
  • Calendar
  • Personal
  • Work
  • Birthdays
```

## 🔗 Integration Examples

### With Obsidian Vault Skill

Combine with the Obsidian vault skill to create daily notes with meetings:

```bash
#!/bin/bash

# Get tomorrow's events
EVENTS=$(python3 calendar_skill.py read tomorrow)

# Append to Obsidian daily note (using obsidian-vault skill)
echo "## Tomorrow's Meetings" >> /tmp/daily_note.md
echo "$EVENTS" >> /tmp/daily_note.md

# Add to Obsidian
# (implementation depends on your Obsidian setup)
```

### Automated Daily Report

Create a script to generate daily summaries:

```python
#!/usr/bin/env python3
from calendar_skill import CalendarSkill
from datetime import datetime

cal = CalendarSkill()

print(f"📅 Daily Report for {datetime.now().strftime('%A, %B %d')}\n")

# Today's events
today_events = cal.get_events_for_date("today")
if today_events:
    print("## Today")
    for event in today_events:
        print(f"  • {event['title']} at {event['start_time']}")
else:
    print("## Today - No events scheduled\n")

# Tomorrow's events
tomorrow_events = cal.get_events_for_date("tomorrow")
if tomorrow_events:
    print("\n## Tomorrow")
    for event in tomorrow_events:
        print(f"  • {event['title']} at {event['start_time']}")
else:
    print("\n## Tomorrow - No events scheduled\n")
```

### Meeting Creation Tool

Batch create multiple events:

```bash
#!/bin/bash

# Create weekly recurring (manual - run weekly)
python3 calendar_skill.py create "Weekly Team Sync" "next Monday at 10am" --duration 60
python3 calendar_skill.py create "Planning Session" "next Friday at 2pm" --duration 90

echo "✅ Weekly meetings created"
```

## 🐛 Troubleshooting

### Issue: "Calendar app not available"

**Cause**: AppleScript cannot access Calendar app
**Solution**:
```bash
# Test AppleScript access
osascript -e 'tell application "Calendar" to get name'

# Grant Full Disk Access to Terminal:
# System Preferences → Security & Privacy → Full Disk Access → Add Terminal
```

### Issue: "Permission denied"

**Cause**: Terminal doesn't have Calendar access
**Solution**:
```bash
# Grant Calendar access:
# System Preferences → Security & Privacy → Calendar → Add Terminal
```

### Issue: Events not showing up

**Cause**: Events created but not visible
**Solution**:
1. Refresh Calendar app (close and reopen)
2. Verify correct calendar: `python3 calendar_skill.py calendars`
3. Use `--test` flag to verify event details before creating

### Issue: Date parsing errors

**Cause**: Natural language date not recognized
**Solution**:
```bash
# Use explicit format instead
python3 calendar_skill.py read 2025-11-12  # Instead of "next Friday"
python3 calendar_skill.py create "Event" "2025-11-12 at 14:00"  # ISO format
```

## 📖 File Structure

```
cc_calendar_skill/
├── README.md              # This file
├── calendar.md            # Detailed documentation
├── calendar_skill.py      # Main skill implementation
├── requirements.txt       # Python dependencies (none for now)
└── examples/
    ├── daily_report.py    # Example: daily report script
    ├── weekly_sync.sh     # Example: batch event creation
    └── obsidian_integration.py  # Example: Obsidian integration
```

## 🎓 Learning Resources

- **macOS Calendar scripting**: Uses AppleScript via subprocess
- **Natural language date parsing**: Custom regex patterns
- **Python CLI**: Uses argparse for command-line interface

## 🚀 Future Enhancements

- [x] Read events from calendar
- [x] Create events with natural language
- [x] Delete events
- [x] List calendars
- [ ] Event reminders/notifications
- [ ] Recurring events
- [ ] Event search/filtering
- [ ] iCloud sync support
- [ ] Google Calendar integration
- [ ] Webhook support for external triggers
- [ ] Calendar sharing info
- [ ] Bulk event creation
- [ ] Event modification (not just create/delete)
- [ ] Attachment support

## 📝 License

This skill is part of the Claude Code ecosystem. Use freely within your Claude Code environment.

## 🤝 Contributing

Found a bug? Have an idea? Open an issue or PR in the development repository:

```
/Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill
```

## 📞 Support

For help, check:
1. This README (troubleshooting section)
2. `calendar.md` (detailed documentation)
3. Try `python3 calendar_skill.py --help` for CLI help

---

**Version**: 1.0.0
**Created**: November 11, 2025
**Platform**: macOS 10.15+
**Python**: 3.6+

Made with ❤️ for terminal-loving developers
