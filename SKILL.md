---
name: calendar
description: Create, read, and delete macOS Calendar events using natural language. Manage your calendar without leaving Claude Code.
---

# Calendar Skill

Seamlessly manage your macOS Calendar from Claude Code. Create events with natural language, list calendars, read events, and delete entries—all without leaving your terminal.

## Quick Start

```bash
# Create an event
calendar-skill create "Team Meeting" "tomorrow at 2pm"

# List your calendars
calendar-skill calendars

# Read today's events
calendar-skill read today

# Delete an event
calendar-skill delete "Team Meeting" "tomorrow"

# Preview before creating
calendar-skill create "Event" "Friday at 10am" --test
```

## Features

- 📅 **Create events** with natural language dates/times
- 📋 **List all calendars** on your system
- 🔍 **Read events** for specific dates or ranges
- 🗑️ **Delete events** by title and date
- 🧪 **Test mode** to preview before creating
- 📍 Add **locations** and **notes** to events
- ⏱️ Set custom **durations** (default 60 min)

## Installation

```bash
bash install.sh
```

Installs to: `~/.claude/skills/calendar/`

## Usage

### Create Events

```bash
# Simple event
calendar-skill create "Meeting" "tomorrow at 2pm"

# With location and notes
calendar-skill create "Review" "Friday at 10am" \
  --location "Conference Room B" \
  --notes "Q4 planning"

# Custom duration (in minutes)
calendar-skill create "Workshop" "tomorrow at 9am" --duration 120

# To specific calendar
calendar-skill create "Birthday" "next March 15" --calendar Personal

# Preview only (no changes made)
calendar-skill create "Test" "tomorrow at 3pm" --test
```

### Read Events

```bash
# Today's events
calendar-skill read today

# Specific date
calendar-skill read "next Monday"
calendar-skill read 2025-11-15

# Date range
calendar-skill range today "next Friday"
calendar-skill range "2025-11-10" "2025-11-20"
```

### List Calendars

```bash
calendar-skill calendars
```

### Delete Events

```bash
calendar-skill delete "Team Meeting" "tomorrow"
calendar-skill delete "Event" "2025-11-15" --calendar Personal
```

## Natural Language Support

**Dates**: `today`, `tomorrow`, `yesterday`, `next Monday`, `this Friday`, `2025-11-12`

**Times**: `2pm`, `14:00`, `2:30 PM`, `9:00 AM`

**Combined**: `"tomorrow at 2pm"`, `"Friday at 10:00 AM"`, `"next Tuesday at 3:30pm"`

## Implementation

The skill uses AppleScript to interface with macOS Calendar app. Python 3.6+ required.

```python
#!/usr/bin/env python3
"""
Claude Code Calendar Skill
A skill for reading and creating macOS Calendar events via terminal
"""

import subprocess
import json
import os
from datetime import datetime, timedelta
from typing import Optional, List, Dict, Any
import re


class CalendarSkill:
    """
    Manages macOS Calendar operations through AppleScript

    Features:
    - Read calendar events for specific dates or date ranges
    - Create events using natural language
    - List all calendars
    - Delete events
    - Retrieve events with filtering
    """

    def __init__(self):
        """Initialize the calendar skill"""
        self.calendar_app = "Calendar"
        self.verify_macos()

    def verify_macos(self) -> bool:
        """Verify we're on macOS with Calendar app"""
        try:
            result = subprocess.run(
                ["osascript", "-e", "tell application \"Calendar\" to get name"],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                return True
        except Exception as e:
            print(f"Error: Not on macOS or Calendar app not available: {e}")
            return False

    def get_events_for_date(self, date_str: str = None) -> List[Dict[str, Any]]:
        """
        Get all events for a specific date

        Args:
            date_str: Date in format 'YYYY-MM-DD' or natural language (e.g., 'tomorrow', 'today')
                     Defaults to today

        Returns:
            List of event dictionaries with title, start time, end time, location, notes
        """

        # Parse date
        if date_str is None:
            date_str = "today"

        target_date = self._parse_date(date_str)

        # AppleScript to fetch events for a specific date
        script = f"""
tell application "Calendar"
    set events_list to {{}}
    set target_date to (date "{target_date.strftime('%A, %B %d, %Y')}")

    repeat with cal in (every calendar)
        repeat with event in (every event of cal)
            set event_date to start date of event
            if (year of event_date as integer) = (year of target_date as integer) and \\
               (month of event_date as integer) = (month of target_date as integer) and \\
               (day of event_date as integer) = (day of target_date as integer) then

                set event_info to {{}}
                set end of event_info to title of event
                set end of event_info to (time string of (start date of event))
                set end of event_info to (time string of (end date of event))
                set end of event_info to (location of event)
                set end of event_info to (description of event)

                set end of events_list to event_info
            end if
        end repeat
    end repeat

    return events_list
end tell
"""

        try:
            result = subprocess.run(
                ["osascript", "-e", script],
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode != 0:
                return []

            events = self._parse_applescript_events(result.stdout, target_date)
            return events

        except Exception as e:
            return []

    def get_events_date_range(self, start_date: str, end_date: str) -> List[Dict[str, Any]]:
        """
        Get all events within a date range

        Args:
            start_date: Start date (YYYY-MM-DD or natural language)
            end_date: End date (YYYY-MM-DD or natural language)

        Returns:
            List of events sorted by date
        """
        start = self._parse_date(start_date)
        end = self._parse_date(end_date)

        all_events = []
        current = start

        while current <= end:
            date_str = current.strftime('%Y-%m-%d')
            events = self.get_events_for_date(date_str)
            all_events.extend(events)
            current += timedelta(days=1)

        all_events.sort(key=lambda e: e.get('start_time', ''))
        return all_events

    def create_event(
        self,
        title: str,
        date_time: str,
        duration_minutes: int = 60,
        calendar_name: str = "Calendar",
        location: str = None,
        notes: str = None,
        test_mode: bool = False
    ) -> bool:
        """
        Create a calendar event using AppleScript

        Args:
            title: Event title
            date_time: Date/time string (natural language supported)
            duration_minutes: Event duration in minutes (default 60)
            calendar_name: Name of calendar to add event to
            location: Event location (optional)
            notes: Event notes/description (optional)
            test_mode: If True, show preview without creating

        Returns:
            True if event created successfully, False otherwise
        """

        try:
            event_date = self._parse_datetime(date_time)
            if event_date is None:
                print(f"Error: Could not parse date/time: {date_time}")
                return False

            end_date = event_date + timedelta(minutes=duration_minutes)

            if test_mode:
                print(f"\n📅 Event Preview (Test Mode):")
                print(f"   Title: {title}")
                print(f"   Start: {event_date.strftime('%Y-%m-%d %H:%M')}")
                print(f"   End: {end_date.strftime('%Y-%m-%d %H:%M')}")
                print(f"   Calendar: {calendar_name}")
                if location:
                    print(f"   Location: {location}")
                if notes:
                    print(f"   Notes: {notes}")
                return True

            seconds_offset_start = int((event_date - datetime.now()).total_seconds())
            seconds_offset_end = int((end_date - datetime.now()).total_seconds())

            script = f"""
tell application "Calendar"
    tell calendar "{calendar_name}"
        set startOffset to {seconds_offset_start}
        set endOffset to {seconds_offset_end}
        set startDate to (current date) + startOffset
        set endDate to (current date) + endOffset

        set newEvent to make new event at end of events with properties {{summary:"{self._escape_applescript(title)}", start date:startDate, end date:endDate}}
"""

            if location:
                script += f'        set location of newEvent to "{self._escape_applescript(location)}"\n'

            if notes:
                script += f'        set description of newEvent to "{self._escape_applescript(notes)}"\n'

            script += """    end tell
end tell
return "Event created successfully"
"""

            result = subprocess.run(
                ["osascript", "-e", script],
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                print(f"✅ Event created: {title}")
                print(f"   📅 {event_date.strftime('%A, %B %d at %H:%M')}")
                return True
            else:
                print(f"❌ Error creating event: {result.stderr}")
                return False

        except Exception as e:
            print(f"Error: {e}")
            return False

    def list_calendars(self) -> List[str]:
        """Get list of all available calendars"""

        script = """
tell application "Calendar"
    set calendar_list to {}
    repeat with cal in (every calendar)
        set end of calendar_list to name of cal
    end repeat
    return calendar_list
end tell
"""

        try:
            result = subprocess.run(
                ["osascript", "-e", script],
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                calendars = [cal.strip() for cal in result.stdout.strip().split(", ")]
                return calendars
            return []

        except Exception as e:
            print(f"Error listing calendars: {e}")
            return []

    def delete_event(self, title: str, date_str: str, calendar_name: str = "Calendar") -> bool:
        """
        Delete an event by title and date

        Args:
            title: Event title
            date_str: Event date (YYYY-MM-DD or natural language)
            calendar_name: Calendar containing event

        Returns:
            True if deleted, False otherwise
        """

        try:
            target_date = self._parse_date(date_str)

            script = f"""
tell application "Calendar"
    tell calendar "{calendar_name}"
        delete (every event whose summary is "{self._escape_applescript(title)}" and \\
                (start date >= date "{target_date.strftime('%A, %B %d, %Y 00:00:00')}" and \\
                 start date < date "{(target_date + timedelta(days=1)).strftime('%A, %B %d, %Y 00:00:00')}"))
    end tell
end tell
return "Event deleted"
"""

            result = subprocess.run(
                ["osascript", "-e", script],
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                print(f"✅ Event deleted: {title}")
                return True
            else:
                print(f"❌ Error deleting event: {result.stderr}")
                return False

        except Exception as e:
            print(f"Error: {e}")
            return False

    def _parse_date(self, date_str: str) -> datetime:
        """Parse date string to datetime object"""
        date_str = date_str.lower().strip()
        now = datetime.now()

        if date_str == "today":
            return now.replace(hour=0, minute=0, second=0, microsecond=0)
        elif date_str == "tomorrow":
            return (now + timedelta(days=1)).replace(hour=0, minute=0, second=0, microsecond=0)
        elif date_str == "yesterday":
            return (now - timedelta(days=1)).replace(hour=0, minute=0, second=0, microsecond=0)

        days = {
            "monday": 0, "tuesday": 1, "wednesday": 2, "thursday": 3,
            "friday": 4, "saturday": 5, "sunday": 6
        }

        for day_name, day_num in days.items():
            if date_str.startswith("next " + day_name):
                current_weekday = now.weekday()
                days_ahead = (day_num - current_weekday) % 7
                if days_ahead <= 0:
                    days_ahead += 7
                return (now + timedelta(days=days_ahead)).replace(hour=0, minute=0, second=0, microsecond=0)
            elif date_str.startswith("this " + day_name):
                current_weekday = now.weekday()
                days_ahead = (day_num - current_weekday) % 7
                return (now + timedelta(days=days_ahead)).replace(hour=0, minute=0, second=0, microsecond=0)

        try:
            return datetime.strptime(date_str, "%Y-%m-%d")
        except ValueError:
            pass

        return now.replace(hour=0, minute=0, second=0, microsecond=0)

    def _parse_datetime(self, datetime_str: str) -> Optional[datetime]:
        """Parse date/time string with natural language support"""
        datetime_str = datetime_str.lower().strip()
        now = datetime.now()

        match = re.match(r"(tomorrow|today|next \w+|this \w+|yesterday)(.*)at\s+(\d{1,2}):?(\d{0,2})\s*(am|pm)?", datetime_str)
        if match:
            date_part = match.group(1)
            time_str = match.group(3) + ":" + (match.group(4) if match.group(4) else "00")
            meridiem = match.group(5)

            try:
                hour = int(match.group(3))
                minute = int(match.group(4)) if match.group(4) else 0

                if meridiem == "pm" and hour != 12:
                    hour += 12
                elif meridiem == "am" and hour == 12:
                    hour = 0
            except ValueError:
                return None

            base_date = self._parse_date(date_part)
            return base_date.replace(hour=hour, minute=minute, second=0, microsecond=0)

        try:
            return datetime.strptime(datetime_str, "%Y-%m-%d %H:%M")
        except ValueError:
            pass

        try:
            return datetime.strptime(datetime_str, "%Y-%m-%d %H:%M:%S")
        except ValueError:
            pass

        return None

    def _parse_applescript_events(self, output: str, target_date: datetime) -> List[Dict[str, Any]]:
        """Parse AppleScript event output into structured format"""
        events = []

        lines = output.strip().split('\n')

        for line in lines:
            if line.strip():
                parts = [p.strip() for p in line.split('\t')]
                if len(parts) >= 3:
                    event = {
                        'title': parts[0],
                        'start_time': parts[1] if len(parts) > 1 else '',
                        'end_time': parts[2] if len(parts) > 2 else '',
                        'location': parts[3] if len(parts) > 3 else '',
                        'notes': parts[4] if len(parts) > 4 else '',
                        'date': target_date.strftime('%Y-%m-%d')
                    }
                    events.append(event)

        return events

    def _escape_applescript(self, text: str) -> str:
        """Escape special characters for AppleScript"""
        return text.replace('"', '\\"').replace('\\', '\\\\')

    def display_events(self, events: List[Dict[str, Any]], show_details: bool = True):
        """Pretty print events"""
        if not events:
            print("📭 No events found")
            return

        print(f"\n📅 Events ({len(events)} total):")
        print("=" * 80)

        for event in events:
            print(f"\n  📌 {event['title']}")
            if event.get('start_time'):
                print(f"     🕐 {event['start_time']} - {event.get('end_time', '')}")
            if event.get('location'):
                print(f"     📍 {event['location']}")
            if show_details and event.get('notes'):
                print(f"     📝 {event['notes']}")

        print("\n" + "=" * 80)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description="Claude Code Calendar Skill - Manage macOS Calendar events"
    )

    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    read_parser = subparsers.add_parser("read", help="Read events for a date")
    read_parser.add_argument(
        "date",
        nargs="?",
        default="today",
        help="Date to read (e.g., 'today', 'tomorrow', '2025-11-12')"
    )

    create_parser = subparsers.add_parser("create", help="Create a calendar event")
    create_parser.add_argument("title", help="Event title")
    create_parser.add_argument("datetime", help="Date/time (e.g., 'tomorrow at 2pm')")
    create_parser.add_argument("-d", "--duration", type=int, default=60, help="Duration in minutes")
    create_parser.add_argument("-c", "--calendar", default="Calendar", help="Calendar name")
    create_parser.add_argument("-l", "--location", help="Event location")
    create_parser.add_argument("-n", "--notes", help="Event notes")
    create_parser.add_argument("-t", "--test", action="store_true", help="Test mode (preview only)")

    range_parser = subparsers.add_parser("range", help="Read events in date range")
    range_parser.add_argument("start_date", help="Start date")
    range_parser.add_argument("end_date", help="End date")

    subparsers.add_parser("calendars", help="List all calendars")

    delete_parser = subparsers.add_parser("delete", help="Delete an event")
    delete_parser.add_argument("title", help="Event title")
    delete_parser.add_argument("date", help="Event date")
    delete_parser.add_argument("-c", "--calendar", default="Calendar", help="Calendar name")

    args = parser.parse_args()

    skill = CalendarSkill()

    if args.command == "read":
        events = skill.get_events_for_date(args.date)
        skill.display_events(events)

    elif args.command == "create":
        skill.create_event(
            args.title,
            args.datetime,
            duration_minutes=args.duration,
            calendar_name=args.calendar,
            location=args.location,
            notes=args.notes,
            test_mode=args.test
        )

    elif args.command == "range":
        events = skill.get_events_date_range(args.start_date, args.end_date)
        skill.display_events(events)

    elif args.command == "calendars":
        calendars = skill.list_calendars()
        print("📚 Available Calendars:")
        for cal in calendars:
            print(f"  • {cal}")

    elif args.command == "delete":
        skill.delete_event(args.title, args.date, args.calendar)

    else:
        parser.print_help()
```

## Requirements

- macOS 10.15 or later
- Python 3.6+
- Calendar.app (built-in to macOS)

## Support

For issues, examples, and full documentation, see the GitHub repository:
https://github.com/hancengiz/cc_calendar_skill
