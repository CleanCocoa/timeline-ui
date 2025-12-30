# Getting Started with TimelineUI

Display calendar events in your iOS app with automatic conflict layout.

## Overview

TimelineUI makes it easy to show daily schedules. Create ``TimelineItem`` instances for your events, then display them with ``DayTimelineView`` or ``CompactTimelineView``.

## Create Timeline Items

Each event needs a title, start/end dates, and a color:

```swift
let events = [
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
```

## Display a Day Timeline

Use ``DayTimelineView`` for a full-day view that expands to fill available space:

```swift
struct ScheduleView: View {
    var body: some View {
        DayTimelineView(items: events)
    }
}
```

![Day timeline with events](day-conflicts-light.png)

## Display a Compact Timeline

Use ``CompactTimelineView`` for widgets or previews:

```swift
CompactTimelineView(items: events, heightMode: .fixed(hours: 2))
```

![Compact timeline](compact-conflicts-light.png)

## Handle Many Events

The timeline automatically arranges overlapping events in columns:

![Many overlapping events](compact-many-light.png)
