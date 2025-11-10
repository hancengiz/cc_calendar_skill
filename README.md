# Calendar Skill for Claude Code

A simple Claude Code skill to read and write macOS Calendar events using natural language.

## What It Does

- **Read your calendar**: "Show me today's events" or "What's on Friday?"
- **Create events**: "Add team meeting tomorrow at 2pm in Conference Room A"
- **Delete events**: "Remove the standup from tomorrow"
- **List calendars**: "What calendars do I have?"

## Installation

Copy `SKILL.md` to your Claude Code skills directory:

```bash
cp SKILL.md ~/.claude/skills/calendar/SKILL.md
```

Or clone this repo and it will be automatically discovered by Claude Code if placed in your skills directory.

## How It Works

Claude Code reads the skill definition in `SKILL.md`, which contains:
- Skill metadata (name, description)
- Python code examples for interacting with macOS Calendar via AppleScript
- When you ask Claude Code to do something with your calendar, it generates the appropriate Python code, runs it temporarily, and returns the results

## Usage

Just ask Claude Code naturally:
- "What meetings do I have today?"
- "Create a meeting called 'Project Review' for Friday at 10am"
- "Show me what calendars I have"
- "Delete the dentist appointment from next Tuesday"

Claude Code will understand your request and interact with your macOS Calendar automatically.

## Requirements

- macOS with Calendar.app
- Claude Code
- Python 3

## Repository

https://github.com/hancengiz/cc_calendar_skill

## License

MIT
