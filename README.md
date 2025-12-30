# TimelineUI

A SwiftUI component library for displaying calendar timeline views in iOS apps. Show daily schedules with automatic conflict detection and layout.

## Installation

Add TimelineUI to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/TimelineUI.git", from: "1.0.0")
]
```

## Quick Start

```swift
import TimelineUI

struct ScheduleView: View {
    let events: [TimelineItem] = [
        TimelineItem(
            title: "Team Meeting",
            startDate: Date(),
            endDate: Date().addingTimeInterval(3600),
            color: .blue,
            location: "Conference Room A"
        ),
        TimelineItem(
            title: "Lunch",
            startDate: Date().addingTimeInterval(7200),
            endDate: Date().addingTimeInterval(10800),
            color: .green
        )
    ]

    var body: some View {
        DayTimelineView(items: events)
    }
}
```

## Components

### DayTimelineView

Full day timeline that automatically expands to fill available space. Shows hour grid lines with events positioned by time.

```swift
DayTimelineView(items: [TimelineItem])
```

### CompactTimelineView

Compact timeline window, ideal for widgets or previews.

```swift
CompactTimelineView(items: [TimelineItem])                      // Fills available height
CompactTimelineView(items: [TimelineItem], heightMode: .flexible)      // Same as above
CompactTimelineView(items: [TimelineItem], heightMode: .fixed(hours: 2)) // Fixed 2-hour window
```

### Access Restricted View

Show a blurred timeline with a permission prompt when calendar access hasn't been granted:

```swift
CompactTimelineView(items: [])
    .accessRestricted(!hasCalendarAccess) {
        AccessPromptView.calendar(style: .compact) {
            await requestCalendarAccess()
        }
    }
```

Customize the prompt text:

```swift
AccessPromptView.calendar(
    title: "Check for conflicts",
    message: "See if this time works with your schedule",
    buttonLabel: "Enable Calendar"
) { await requestAccess() }
```

Or use ViewBuilders for full control over icon and button:

```swift
AccessPromptView(
    title: "Connect Calendar",
    message: "Show your events on the timeline",
    icon: { Image(systemName: "calendar.badge.plus") },
    buttonLabel: { Label("Allow Access", systemImage: "checkmark.circle") }
) { await requestAccess() }
```

## Screenshots

| | Light | Dark |
|---|:-----:|:----:|
| **Compact** - 2-3 hour window with conflict layout | ![Compact light](screenshots/compact-conflicts-light.png) | ![Compact dark](screenshots/compact-conflicts-dark.png) |
| **Day** - Full schedule with hour grid | ![Day light](screenshots/day-simple-light.png) | ![Day dark](screenshots/day-simple-dark.png) |
| **Conflicts** - Overlapping events side-by-side | ![Conflicts light](screenshots/day-conflicts-light.png) | ![Conflicts dark](screenshots/day-conflicts-dark.png) |
| **Many events** - Handles arbitrary input gracefully | ![Many light](screenshots/compact-many-light.png) | ![Many dark](screenshots/compact-many-dark.png) |
| **Access restricted** - Blurred timeline with permission prompt | ![Restricted light](screenshots/access-restricted-light.png) | ![Restricted dark](screenshots/access-restricted-dark.png) |

## Requirements

- iOS 26+
- macOS 14+
- Swift 6.2+

## License

MIT
