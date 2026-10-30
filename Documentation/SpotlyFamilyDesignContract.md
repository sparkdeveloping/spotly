# Spotly Family Design Contract

This contract defines the shared UI foundation for Spotly Customer, Business, Driver, and Admin.

## Shared Neutrals

| Token | Light | Purpose |
| --- | --- | --- |
| `background` | `#FFFFFF` | Root canvas |
| `groupedBackground` | `#F7F8FA` | Grouped screens and settings |
| `secondaryBackground` | `#F3F4F6` | Secondary controls and subtle fills |
| `surface` | `#FFFFFF` | Cards, rows, forms, sections |
| `textPrimary` | `#111827` | Primary content |
| `textSecondary` | `#6B7280` | Supporting content |
| `textTertiary` | `#9CA3AF` | Hints, captions, inactive icons |
| `border` | `#E5E7EB` | One-point surface outlines |
| `divider` | `#E7E9E8` | Internal row dividers |
| `disabled` | `#C7CBD1` | Disabled controls |

Dark mode uses semantic equivalents, not tinted light-mode colors.

## Typography

Root titles use 34 bold. Section content titles use 22 semibold. Grouped labels use 13 semibold uppercase. Card titles use 17 semibold. Body text is 16 regular. Supporting text is 15 regular. Captions are 13 regular. Metrics use 30 to 36 bold. Buttons use 16 to 17 semibold.

## Geometry

Root horizontal padding is 20. Card padding is 16. Section gap is 28 to 32. Card gap is 12 to 16. Rows are at least 60 high. Primary buttons are 52 high. Compact controls are at least 44 high. Search is 52 high. Input and card radius is 16. Hero and media radius is 20.

## Surface Hierarchy

Section surfaces are semantic white surfaces, radius 16, one-point border, no shadow, internal dividers, and full-width rows.

Standard cards use radius 16, one-point border, and a restrained 5 percent black shadow at radius 8, y 2.

Elevated cards use radius 16, one-point border, and a 6 percent black shadow at radius 12, y 4.

Hero and media cards use radius 20, consistent image overlays, restrained shadow, and accessible contrast.

## Rows

Grouped rows use a 40-point rounded-square icon container, title, optional subtitle or status, one disclosure indicator, and a full-row tap target. Individual rows do not cast shadows.

## Search And Chips

Search fields are solid controls with 52 height, radius 16, one-point border, clear button, native keyboard behavior, and an accent focus ring.

Filter chips use accent-soft background, accent text, and accent border when selected. Unselected chips use surface background, secondary text, and standard border.

## Buttons

Primary buttons use accent fill, white text, 52 height, and radius 16. Secondary buttons use accent-soft fill, accent text, and optional accent border. Tertiary controls are text or icon controls with at least a 44-point target. Destructive controls use error-soft surfaces and error text.

## Statuses

Success remains green. Information remains blue. Warning remains amber. Error remains red. Rating remains amber. Favourite remains red. Verified remains green. Brand accent must not replace semantic status colors.

## Native Navigation

Root navigation uses SwiftUI native `TabView`. The system tab bar owns layout, safe area, selection, accessibility, icon variants, and compact adaptation. Pushed workflows hide the root tab bar with `.toolbar(.hidden, for: .tabBar)` where appropriate.

## Safe Areas

Root tabs rely on native tab safe-area handling. Do not add custom root bottom insets for the tab bar. Use `safeAreaInset(edge: .bottom)` only for real feature action bars on pushed screens or sheets.

## Accessibility And Dark Mode

All interactive rows have full-row tap targets. Controls preserve Dynamic Type by avoiding fixed text containers that clip. VoiceOver labels should describe the visible action. Dark mode uses semantic tokens and preserves contrast without glass-heavy content surfaces.
