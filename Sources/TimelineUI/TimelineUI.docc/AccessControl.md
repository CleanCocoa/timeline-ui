# Handling Calendar Access

Show a permission prompt when calendar access hasn't been granted.

## Overview

When your app needs calendar access to display events, use ``AccessPromptView`` with the `accessRestricted` modifier to show a blurred placeholder with a permission prompt.

![Access restricted timeline](access-restricted-light.png)

## Show an Access Prompt

Wrap your timeline in the `accessRestricted` modifier:

```swift
CompactTimelineView(items: [])
    .accessRestricted(!hasCalendarAccess) {
        AccessPromptView.calendar(style: .compact) {
            await requestCalendarAccess()
        }
    }
```

The timeline appears blurred with the prompt overlaid until access is granted.

## Customize the Prompt

Override the default text with your own messaging:

```swift
AccessPromptView.calendar(
    title: "Check for conflicts",
    message: "See if this time works with your schedule",
    buttonLabel: "Enable Calendar"
) {
    await requestAccess()
}
```

## Full Customization

Use ViewBuilders for complete control over the icon and button:

```swift
AccessPromptView(
    title: "Connect Calendar",
    message: "Show your events on the timeline",
    icon: { Image(systemName: "calendar.badge.plus") },
    buttonLabel: { Label("Allow Access", systemImage: "checkmark.circle") }
) {
    await requestAccess()
}
```
