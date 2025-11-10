---
name: calendar
description: Manage macOS Calendar events. Create, read, delete, and list calendar entries using natural language.
---

# Calendar Skill

Manage your macOS Calendar directly from Claude Code using natural language commands.

## Capabilities

- **Create events**: "Create a team meeting tomorrow at 2pm with location and notes"
- **Read events**: "Show me today's calendar" or "What's on my schedule for next Friday?"
- **List calendars**: "What calendars do I have?"
- **Delete events**: "Remove the team meeting from tomorrow"

## How to Use

When you ask this skill to do something with your calendar, it will:
1. Generate a Python script based on your request
2. Run it in a temporary environment
3. Return the results

## Python Implementation Reference

Here's the core logic Claude Code uses to interact with macOS Calendar via AppleScript:

```python
import subprocess
from datetime import datetime, timedelta
import re

class CalendarManager:
    def create_event(self, title, date_time, duration_minutes=60, location=None, notes=None):
        """Create calendar event using natural language date/time"""
        event_date = self._parse_datetime(date_time)
        end_date = event_date + timedelta(minutes=duration_minutes)

        seconds_offset_start = int((event_date - datetime.now()).total_seconds())
        seconds_offset_end = int((end_date - datetime.now()).total_seconds())

        script = f"""
tell application "Calendar"
    tell calendar "Calendar"
        set startOffset to {seconds_offset_start}
        set endOffset to {seconds_offset_end}
        set startDate to (current date) + startOffset
        set endDate to (current date) + endOffset
        set newEvent to make new event at end of events with properties {{summary:"{title}", start date:startDate, end date:endDate}}
"""
        if location:
            script += f'        set location of newEvent to "{location}"\n'
        if notes:
            script += f'        set description of newEvent to "{notes}"\n'

        script += """    end tell
end tell
"""
        result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
        return result.returncode == 0

    def read_events(self, date_str="today"):
        """Read events for a specific date"""
        target_date = self._parse_date(date_str)
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
                set end of events_list to (title of event) & " at " & (time string of (start date of event))
            end if
        end repeat
    end repeat
    return events_list
end tell
"""
        result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
        return result.stdout.strip()

    def list_calendars(self):
        """List all available calendars"""
        script = """
tell application "Calendar"
    set calendar_list to {}
    repeat with cal in (every calendar)
        set end of calendar_list to name of cal
    end repeat
    return calendar_list
end tell
"""
        result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
        return result.stdout.strip().split(", ")

    def delete_event(self, title, date_str="today"):
        """Delete an event by title and date"""
        target_date = self._parse_date(date_str)
        script = f"""
tell application "Calendar"
    tell calendar "Calendar"
        delete (every event whose summary is "{title}" and \\
                (start date >= date "{target_date.strftime('%A, %B %d, %Y 00:00:00')}" and \\
                 start date < date "{(target_date + timedelta(days=1)).strftime('%A, %B %d, %Y 00:00:00')}"))
    end tell
end tell
"""
        result = subprocess.run(["osascript", "-e", script], capture_output=True, text=True)
        return result.returncode == 0

    def _parse_date(self, date_str):
        """Parse natural language dates"""
        date_str = date_str.lower().strip()
        now = datetime.now()

        if date_str == "today":
            return now.replace(hour=0, minute=0, second=0, microsecond=0)
        elif date_str == "tomorrow":
            return (now + timedelta(days=1)).replace(hour=0, minute=0, second=0, microsecond=0)
        elif date_str == "yesterday":
            return (now - timedelta(days=1)).replace(hour=0, minute=0, second=0, microsecond=0)

        days = {"monday": 0, "tuesday": 1, "wednesday": 2, "thursday": 3, "friday": 4, "saturday": 5, "sunday": 6}
        for day_name, day_num in days.items():
            if date_str.startswith("next " + day_name):
                current_weekday = now.weekday()
                days_ahead = (day_num - current_weekday) % 7
                if days_ahead <= 0:
                    days_ahead += 7
                return (now + timedelta(days=days_ahead)).replace(hour=0, minute=0, second=0, microsecond=0)

        try:
            return datetime.strptime(date_str, "%Y-%m-%d")
        except:
            return now.replace(hour=0, minute=0, second=0, microsecond=0)

    def _parse_datetime(self, datetime_str):
        """Parse natural language dates with times"""
        datetime_str = datetime_str.lower().strip()
        now = datetime.now()

        match = re.match(r"(tomorrow|today|next \w+|this \w+|yesterday)(.*)at\s+(\d{1,2}):?(\d{0,2})\s*(am|pm)?", datetime_str)
        if match:
            date_part = match.group(1)
            hour = int(match.group(3))
            minute = int(match.group(4)) if match.group(4) else 0
            meridiem = match.group(5)

            if meridiem == "pm" and hour != 12:
                hour += 12
            elif meridiem == "am" and hour == 12:
                hour = 0

            base_date = self._parse_date(date_part)
            return base_date.replace(hour=hour, minute=minute, second=0, microsecond=0)

        try:
            return datetime.strptime(datetime_str, "%Y-%m-%d %H:%M")
        except:
            return datetime.now()
```

## Examples

When you ask:
- "Create a meeting called 'Project Review' for Friday at 10am in Conference Room B" → Creates the event
- "What's on my calendar today?" → Shows today's events
- "Delete the team standup from tomorrow" → Removes that event
- "List all my calendars" → Shows Calendar, Personal, Work, etc.

Claude Code will generate the appropriate Python script, run it, and return the results.
