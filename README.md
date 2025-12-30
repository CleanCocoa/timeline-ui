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

Compact 2-3 hour window, ideal for widgets or previews.

```swift
CompactTimelineView(items: [TimelineItem], visibleHours: 2)
```

## Screenshots

| | Light | Dark |
|---|:-----:|:----:|
| **Compact** - 2-3 hour window with conflict layout | ![Compact light](screenshots/compact-conflicts-light.png) | ![Compact dark](screenshots/compact-conflicts-dark.png) |
| **Day** - Full schedule with hour grid | ![Day light](screenshots/day-simple-light.png) | ![Day dark](screenshots/day-simple-dark.png) |
| **Conflicts** - Overlapping events side-by-side | ![Conflicts light](screenshots/day-conflicts-light.png) | ![Conflicts dark](screenshots/day-conflicts-dark.png) |

## API Reference

### TimelineItem

```swift
TimelineItem(
    id: UUID = UUID(),
    title: String,
    startDate: Date,
    endDate: Date,
    isAllDay: Bool = false,
    color: Color,
    location: String? = nil,
    isPrimary: Bool = false
)
```

| Property | Description |
|----------|-------------|
| `title` | Event title displayed in the block |
| `startDate` | Event start time |
| `endDate` | Event end time |
| `isAllDay` | Shows in all-day section instead of timed grid |
| `color` | Accent color for the event block |
| `location` | Optional location shown below title |
| `isPrimary` | Lighter background style for "new" events |

## Requirements

- iOS 26+
- macOS 14+
- Swift 6.2+

## License

MIT
