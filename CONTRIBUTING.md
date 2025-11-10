# Contributing to Claude Code macOS Calendar Skill

Thank you for your interest in contributing! Here's how you can help.

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/cc_calendar_skill.git
   cd cc_calendar_skill
   ```
3. **Create a new branch** for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## Development

### Setup

```bash
# No dependencies required!
# Just Python 3.6+ and macOS with Calendar app

# Test your changes
python3 calendar_skill.py --help
```

### Code Style

- Follow PEP 8 conventions
- Use type hints where possible
- Keep functions small and focused
- Add docstrings to all functions

### Testing

Test your changes thoroughly:

```bash
# Test help
python3 calendar_skill.py --help

# Test calendar listing
python3 calendar_skill.py calendars

# Test event creation (test mode first!)
python3 calendar_skill.py create "Test Event" "tomorrow at 2pm" --test

# Test event creation (actual)
python3 calendar_skill.py create "Test Event" "tomorrow at 2pm"

# Test deletion
python3 calendar_skill.py delete "Test Event" "tomorrow"
```

## Making Changes

### Commit Messages

Write clear, descriptive commit messages:

```bash
git commit -m "Add feature: support for recurring events"
git commit -m "Fix: AppleScript date parsing for edge cases"
git commit -m "Docs: update README with new examples"
```

### Documentation

Update relevant documentation:
- `README.md` - for user-facing features
- `calendar.md` - for API changes
- `INSTALLATION.md` - for setup changes
- `calendar_skill.py` - docstrings and comments

## Submitting Changes

1. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create a Pull Request** on GitHub
   - Clear title and description
   - Link any related issues
   - Describe testing you've done

## Areas for Contribution

### High Priority
- [ ] Improve event reading from calendar (AppleScript optimization)
- [ ] Add event editing/updating functionality
- [ ] Support for recurring events
- [ ] Better error messages and validation

### Medium Priority
- [ ] Add event search functionality
- [ ] Support for multiple calendars in read operations
- [ ] Calendar export options (iCal, JSON)
- [ ] Event reminders/notifications

### Lower Priority
- [ ] Google Calendar integration
- [ ] Outlook/Exchange support
- [ ] Web-based UI
- [ ] Performance optimizations

## Reporting Issues

Found a bug? Please create an issue with:

1. **Description** - What's the problem?
2. **Steps to reproduce** - How can we replicate it?
3. **Expected behavior** - What should happen?
4. **Actual behavior** - What's happening instead?
5. **Environment** - macOS version, Python version, etc.

## Code Review

- Be open to feedback
- Respond to review comments
- Make requested changes in new commits
- Thank you for improving the project!

## Questions?

- Check `README.md` for usage examples
- Check `calendar.md` for API documentation
- Create an issue for discussion

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing!** 🎉
