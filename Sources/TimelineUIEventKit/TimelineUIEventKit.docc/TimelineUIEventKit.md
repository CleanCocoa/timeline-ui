# ``TimelineUIEventKit``

Convert EventKit events to TimelineUI items.

@Metadata {
    @DisplayName("TimelineUIEventKit")
}

## Overview

TimelineUIEventKit provides seamless integration between Apple's EventKit framework
and TimelineUI. Import this module to create ``TimelineUI/TimelineItem`` instances
directly from `EKEvent` objects.

```swift
import TimelineUI
import TimelineUIEventKit

let item = TimelineItem(ekEvent)
```

The conversion preserves the event's title, times, calendar color, and location.

## Converting Multiple Events

Use the static factory or array extension to convert multiple events at once:

```swift
// Static factory (discoverable on TimelineItem)
let items = TimelineItem.items(from: ekEvents)

// Array extension
let items = ekEvents.asTimelineItems()
```

## Highlighting a Primary Event

Mark one event as primary to visually distinguish it (e.g., the event being edited):

```swift
let items = TimelineItem.items(
    from: ekEvents,
    primaryEventID: selectedEvent.eventIdentifier
)
```

The primary event renders with a lighter background.

## Topics

### Converting Events

- ``TimelineUI/TimelineItem/init(_:isPrimary:)``
- ``TimelineUI/TimelineItem/items(from:primaryEventID:)``
- ``Swift/Array/asTimelineItems(primaryEventID:)``
