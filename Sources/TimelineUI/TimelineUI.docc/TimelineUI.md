# ``TimelineUI``

A SwiftUI component library for displaying calendar timeline views.

@Metadata {
    @DisplayName("TimelineUI")
}

## Overview

TimelineUI provides SwiftUI views for displaying daily schedules with automatic conflict detection and layout. Events that overlap are automatically arranged side-by-side.

![Day timeline showing overlapping events](day-conflicts-light.png)

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

### Access Control

- ``AccessPromptView``
- ``AccessRestrictedModifier``
