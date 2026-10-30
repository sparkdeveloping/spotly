# Spotly Customer Design System

Spotly Customer is the visual reference implementation for the app family while retaining a discovery-first customer experience.

## Customer Palette

| Token | Light | Dark | Usage |
| --- | --- | --- | --- |
| `accent` | `#6657D9` | `#9B8CFF` | Tab selection, primary actions, links, focus, booking progress |
| `accentStrong` | `#4E3FBF` | `#B4A9FF` | Strong emphasis and gradient depth |
| `accentSoft` | `#F0EEFF` | `#282343` | Selected chips, secondary buttons, subtle callouts |
| `accentMuted` | `#F8F7FF` | `#1D1A31` | Customer identity highlights and quiet brand backgrounds |
| `textOnAccent` | `#FFFFFF` | `#FFFFFF` | Text on solid accent fills |

The customer palette is violet. Green is reserved for success, verified states, and open/confirmed status. Amber is reserved for ratings and warnings. Red is reserved for destructive, favourite, and error states.

## Customer Media

Discovery and category experiences should show actual venue, service, food, event, or activity imagery whenever available. Hero and media cards use the shared hero contract: radius 20, consistent dark overlay for text contrast, restrained shadow, and no arbitrary glass overlay.

## Customer-Specific Emphasis

Use violet for customer identity highlights, booking progress, selected discovery filters, focused search, links, and primary calls to action. Use accent-soft rather than solid violet for most selected filter chips so content cards and primary actions remain visually dominant.

## Customer Chrome

Root tabs use native iOS `TabView` with `.tint(SpotlyColors.accent)`. Navigation bars, toolbars, sheets, menus, alerts, and segmented controls should remain native unless a workflow requires a custom content control.
