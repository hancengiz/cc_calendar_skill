# macOS Calendar Integration Skill

A comprehensive Claude Code skill for reading and creating macOS Calendar events directly from the terminal using natural language.

**Base directory for this skill**: `/Users/cengiz_han/.claude/skills/calendar`

## Overview

This skill provides seamless integration with macOS Calendar via AppleScript, allowing you to:

- 📖 **Read events** for specific dates or date ranges
- ✍️ **Create events** using natural language date/time parsing
- 📚 **List all calendars** on your system
- 🗑️ **Delete events** by title and date
- 📅 **Query events** with flexible filtering

## Installation

1. **Copy the skill to Claude Code directory**:
   ```bash
   mkdir -p ~/.claude/skills/calendar
   cp /Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill/calendar_skill.py ~/.claude/skills/calendar/
   cp /Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill/calendar.md ~/.claude/skills/calendar/
   ```

2. **Make executable**:
   ```bash
   chmod +x ~/.claude/skills/calendar/calendar_skill.py
   ```

3. **Grant Calendar access** (if prompted by macOS):
   - When first running, macOS may request access to Calendar
   - Click "Allow" in the permission dialog

## Features

### 1. Read Events

Get all events for a specific date:

```bash
python3 calendar_skill.py read today
python3 calendar_skill.py read tomorrow
python3 calendar_skill.py read 2025-11-12
python3 calendar_skill.py read "next Monday"
```

Output:
```
📅 Events (2 total):
================================================================================

  📌 Team Standup
     🕐 09:00 AM - 10:00 AM
     📍 Conference Room A

  📌 1:1 with Manager
     🕐 02:00 PM - 03:00 PM
     📍 Zoom

================================================================================
```

### 2. Create Events

Create calendar events with natural language:

```bash
# Basic event
python3 calendar_skill.py create "Team Meeting" "tomorrow at 2pm"

# With location and notes
python3 calendar_skill.py create "Project Review" "next Friday at 10:00 AM" \
  --location "Conference Room B" \
  --notes "Q4 planning discussion"

# Custom duration
python3 calendar_skill.py create "Workshop" "tomorrow at 1pm" --duration 120

# To specific calendar
python3 calendar_skill.py create "Birthday" "next March 15" --calendar "Personal"

# Test mode (preview without creating)
python3 calendar_skill.py create "Test Event" "tomorrow at 3pm" --test
```

Output:
```
✅ Event created: Team Meeting
   📅 Tuesday, November 12 at 14:00
```

### 3. Query Date Ranges

Get all events within a date range:

```bash
python3 calendar_skill.py range today "next Friday"
python3 calendar_skill.py range "2025-11-10" "2025-11-20"
```

### 4. List Calendars

See all available calendars:

```bash
python3 calendar_skill.py calendars
```

Output:
```
📚 Available Calendars:
  • Calendar
  • Personal
  • Work
  • Birthdays
```

### 5. Delete Events

Remove events by title and date:

```bash
python3 calendar_skill.py delete "Team Meeting" "tomorrow"
python3 calendar_skill.py delete "Dentist Appointment" "2025-11-15" --calendar "Personal"
```

## Natural Language Date/Time Parsing

The skill supports flexible date/time input:

### Dates
- `today`, `tomorrow`, `yesterday`
- `next Monday`, `next Friday` (next occurrence)
- `this Monday`, `this Friday` (current week)
- ISO format: `2025-11-12`

### Times
- `2pm`, `2:00pm`, `14:00`, `2:30 PM`
- Combined: `"tomorrow at 2pm"`, `"next Monday at 10:00 AM"`

### Examples
```bash
# Various date formats
python3 calendar_skill.py read tomorrow
python3 calendar_skill.py read "next Friday"
python3 calendar_skill.py read 2025-11-15

# Various time formats
python3 calendar_skill.py create "Lunch" "today at 12:00 PM"
python3 calendar_skill.py create "Meeting" "tomorrow at 2pm"
python3 calendar_skill.py create "Call" "next Tuesday at 3:30pm"
```

## Python API Usage

Use the skill programmatically in Python:

```python
from calendar_skill import CalendarSkill

cal = CalendarSkill()

# Read events
events = cal.get_events_for_date("tomorrow")
cal.display_events(events)

# Create event
cal.create_event(
    title="Project Meeting",
    date_time="tomorrow at 2pm",
    duration_minutes=60,
    location="Conference Room A",
    notes="Quarterly planning discussion"
)

# Get date range
events = cal.get_events_date_range("today", "next Friday")
for event in events:
    print(f"{event['title']} - {event['start_time']}")

# List calendars
calendars = cal.list_calendars()
print(calendars)

# Delete event
cal.delete_event("Team Meeting", "tomorrow")
```

## Configuration

### Calendar Selection

By default, events are read from and created in the "Calendar" calendar. To use a different calendar:

```bash
# Create event in "Work" calendar
python3 calendar_skill.py create "Meeting" "tomorrow at 2pm" --calendar Work

# Delete from specific calendar
python3 calendar_skill.py delete "Event" "tomorrow" --calendar Personal
```

### Test Mode

Preview what will be created without actually creating the event:

```bash
python3 calendar_skill.py create "Test Event" "tomorrow at 3pm" --test
```

Output:
```
📅 Event Preview (Test Mode):
   Title: Test Event
   Start: 2025-11-12 15:00
   End: 2025-11-12 16:00
   Calendar: Calendar
```

## Use Cases

### Daily Note Integration

Create a daily note in Obsidian with tomorrow's meetings:

```bash
#!/bin/bash
TOMORROW_EVENTS=$(python3 calendar_skill.py read tomorrow)

# Add to Obsidian daily note
obsidian-cli append "2025-11-12.md" "## Tomorrow's Schedule\n$TOMORROW_EVENTS"
```

### Meeting Reminder

Get today's meetings and display them:

```bash
python3 calendar_skill.py read today
```

### Batch Event Creation

Create multiple events:

```bash
python3 calendar_skill.py create "Sprint Planning" "next Monday at 10am" --duration 120
python3 calendar_skill.py create "Retrospective" "next Friday at 2pm" --duration 90
python3 calendar_skill.py create "Backlog Grooming" "next Wednesday at 1pm"
```

### Weekly Review

Check what's scheduled for next week:

```bash
python3 calendar_skill.py range "next Monday" "next Sunday"
```

## Troubleshooting

### "Calendar app not available" Error

**Issue**: Skill cannot access Calendar app
**Solution**:
1. Ensure macOS Calendar is installed (usually default)
2. Grant Terminal full disk access:
   - System Preferences → Security & Privacy → Privacy → Full Disk Access
   - Add Terminal or your terminal application

### "Permission denied" Error

**Issue**: AppleScript cannot create/modify events
**Solution**:
1. Grant Calendar access to Terminal:
   - System Preferences → Security & Privacy → Privacy → Calendar
   - Add Terminal or your terminal application

### Events not appearing after creation

**Issue**: Events created but not visible in Calendar
**Solution**:
1. Refresh Calendar app (close and reopen)
2. Verify correct calendar was specified with `--calendar` flag
3. Check event appears in correct date range

### Date parsing issues

**Issue**: Natural language dates not recognized
**Solution**:
1. Use explicit ISO format: `2025-11-12` instead of natural language
2. Use 24-hour format for times: `14:00` instead of `2:00 PM`
3. Check for typos in day names: `next Monday` (capitalized)

## Requirements

- **macOS** 10.15 or later
- **Python 3.6+**
- **Calendar app** (built-in to macOS)
- **AppleScript** access (usually granted by default)

## Limitations

1. **Single Calendar App**: Works with the built-in macOS Calendar app
2. **No iCloud sync within AppleScript**: Events are created locally
3. **Limited metadata**: Some advanced Calendar properties may not be accessible
4. **Single calendar at a time**: Read operations are per-calendar (default "Calendar")

## Future Enhancements

- [ ] Add reminder support (e.g., "remind me 15 minutes before")
- [ ] Recurring event creation
- [ ] Event search across all calendars
- [ ] Color coding support
- [ ] Integration with Google Calendar / Outlook
- [ ] Attachment support
- [ ] Event modification (editing existing events)
- [ ] CalDAV support for remote calendars

## License

Part of the Claude Code Skills ecosystem. See main license for details.

## Support

For issues or feature requests, visit:
- Repository: `/Users/cengiz_han/workspace/code/personal_github/cc_calendar_skill`
- Documentation: `calendar.md` (this file)

## Examples

### Complete Example: Daily Planning

```bash
#!/bin/bash
# Get today's events
echo "=== Today's Schedule ==="
python3 calendar_skill.py read today

# Get tomorrow's events
echo -e "\n=== Tomorrow's Schedule ==="
python3 calendar_skill.py read tomorrow

# Schedule a new meeting
python3 calendar_skill.py create \
  "Daily Standup" \
  "tomorrow at 9:00 AM" \
  --duration 30 \
  --location "Team Room" \
  --calendar "Work"

# Get week ahead
echo -e "\n=== Week Ahead ==="
python3 calendar_skill.py range today "next Friday"
```

### Complete Example: Python Integration

```python
from calendar_skill import CalendarSkill
from datetime import datetime

cal = CalendarSkill()

# Get tomorrow's meetings for Obsidian daily note
tomorrow_events = cal.get_events_for_date("tomorrow")

if tomorrow_events:
    print("## Tomorrow's Meetings\n")
    for event in tomorrow_events:
        print(f"- **{event['title']}** at {event['start_time']}")
        if event['location']:
            print(f"  📍 {event['location']}")

# Create recurring weekly meeting (manual for now)
for week in range(4):
    week_date = f"next Monday +{week*7}d"  # Pseudo-code for future enhancements
    cal.create_event(
        "Weekly Sync",
        f"next Monday at 10am",
        duration_minutes=60,
        location="Zoom",
        notes="Weekly team synchronization"
    )
```

---

**Created**: November 11, 2025
**Author**: Claude Code Calendar Skill
**Version**: 1.0.0
