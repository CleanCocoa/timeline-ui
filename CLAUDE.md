# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TimelineUI is a SwiftUI component library for displaying calendar timeline visualizations. It provides day view timelines with hour grids and event blocks, suitable for showing schedules and detecting conflicts.

## Build Commands

```bash
mise run build      # Build the Swift package
mise run tests      # Run package unit tests
mise run format     # Format Swift source files
mise run previews   # Generate preview PNG images to ./previews/
mise run clean      # Clean build artifacts
```

## Architecture

- **Package.swift** - Swift Package at root containing the library
- **Sources/TimelineUI/** - Core library with timeline components
  - `TimelineItem.swift` - View model for timeline events
  - `DayTimelineView.swift` - Full day timeline with hour grid
  - `CompactTimelineView.swift` - Compact 2-3 hour preview
  - `TimelineEventBlock.swift` - Individual event block component
- **Sources/RenderPreviews/** - macOS CLI to generate preview PNGs
- **Tests/TimelineUITests/** - Unit tests for the library

## Technical Constraints

- Target: iOS 26+, macOS 14+
- Swift 6.2 with modern concurrency
- SwiftUI only - no UIKit dependencies in library
- No external dependencies

## API Design

The library uses a simple `TimelineItem` struct as the view model:

```swift
TimelineItem(
    title: String,
    startDate: Date,
    endDate: Date,
    isAllDay: Bool = false,
    color: Color,
    location: String? = nil,
    isPrimary: Bool = false  // Distinguishes "new" from "existing" events
)
```

Views accept `[TimelineItem]` arrays and handle layout automatically.

## Coding Conventions

- Use Swift Testing framework with raw identifiers for test names:
  ```swift
  @Test func `renders items with correct positions`() throws { ... }
  ```
- Do not add comments unless asked
