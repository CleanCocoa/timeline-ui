# ``TimelineUI``

A SwiftUI component library for displaying calendar timeline views.

@Metadata {
    @DisplayName("TimelineUI")
}

## Overview

TimelineUI provides SwiftUI views for displaying daily schedules. Events are positioned by time on an hour grid, and overlapping events are automatically arranged side-by-side.

![Compact timeline showing events](compact-conflicts-light.png)

Use ``DayTimelineView`` for full-day schedules that expand to fill available space, or ``CompactTimelineView`` for a focused 2-3 hour window ideal for widgets.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:AccessControl>

### Displaying Timelines

- ``DayTimelineView``
- ``CompactTimelineView``
- ``HeightMode``

### Event Data

- ``TimelineItem``
- ``TimelineEventBlock``

### Expandable Timeline

- ``ExpandableTimelineContainer``
- ``ExpandedTimelineContent``
- ``TimelineTransitionModifier``

### Access Control

- ``AccessPromptView``
- ``AccessRestrictedModifier``
