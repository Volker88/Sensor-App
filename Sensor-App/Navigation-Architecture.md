# Navigation & View Hierarchy Architecture — Sensor-App (iOS)

This document describes how the iOS app is structured from the root entry point
down to individual sensor views, and how navigation state flows between them.

---

## Entry Point

`SensorAppApp` (file: `Layout/SensorAppApp.swift`) creates the three long-lived
managers and the navigation state object with `@State`, then injects them into
the environment before presenting `ContentView`.

```swift
@State private var motionManager   = MotionManager()
@State private var locationManager = LocationManager()
@State private var settingsManager = SettingsManager()
@State private var appState        = AppState()
```

The `withNotificationView()` modifier is applied at this level, making the
toast system available to the entire tree.

---

## Navigation State — `AppState`

**File:** `Layout/Navigation/AppState.swift`  
**Type:** `@MainActor @Observable final class`

`AppState` is the single source of truth for all navigation. It is injected
into the environment and accessed in views with `@Environment(AppState.self)`.
`NavigationStack` paths are bound with `@Bindable`.

| Property | Type | Role |
|---|---|---|
| `selectedTab` | `RootTab` | Active tab in the `TabView` |
| `appIntentTab` | `RootTab?` | Set by Siri; triggers deferred navigation |
| `positionStack` | `[PositionStack]` | Path for Location / Altitude navigator |
| `motionStack` | `[MotionStack]` | Path for all Motion navigators |
| `magnetometerStack` | `[MagnetometerStack]` | Path for Magnetometer navigator |

**Key behaviours:**

- `onSizeClassChange(_:)` — called by `ContentView.onChange(of: horizontalSizeClass)`.
  On iPad ↔ iPhone rotation it resets all stacks and returns to `.position`.
  Navigation restoration is stubbed out in the commented block (parked feature).
- `appIntentDrivenNavigation(_:)` — converts a `RootTab` app-intent value into
  concrete tab + stack-push navigation. On compact layout it uses
  `Task { try await Task.sleep(for: .seconds(0.5)) }` to defer the stack push
  until after the tab switch animation.
- `resetStack()` — called by `ContentView` on every tab change, stopping stale
  sensor sessions from persisting across tabs.

---

## Route Enums

Each route enum conforms to both `Hashable` (so it can serve as a
`NavigationStack` path element) and `View` (so `navigationDestination(for:)`
can simply render `$0` without a separate switch at each call site).

### `RootTab`
**File:** `Layout/Navigation/RootTab.swift`

Top-level tabs. Also carries `symbolImage` (SF Symbol name) and
`localizedString` used throughout the UI and in accessibility identifiers.

```
.position  .location  .altitude
.motion    .acceleration  .gravity  .gyroscope  .attitude
.magnetometer  .settings
```

### `PositionStack`
**File:** `Layout/Navigation/NavigationStacks/PositionStack.swift`

```
.location    → LocationScreen
.locationMap → MapScreen
.altitude    → AltitudeScreen
.altitudeLog → AltitudeList
```

### `MotionStack`
**File:** `Layout/Navigation/NavigationStacks/MotionStack.swift`

```
.acceleration    → AccelerationScreen    .accelerationLog → AccelerationList
.gravity         → GravityScreen         .gravityLog      → GravityList
.gyroscope       → GyroscopeScreen       .gyroscopeLog    → GyroscopeList
.attitude        → AttitudeScreen        .attitudeLog     → AttitudeList
```

### `MagnetometerStack`
**File:** `Layout/Navigation/NavigationStacks/MagnetometerStack.swift`

```
.magnetometerLog → MagnetometerList
```

### `RecordingsStack`
**File:** `Layout/Navigation/NavigationStacks/RecordingsStack.swift`

```
.detail(SensorSession)               → RecordingDetailScreen
.motionMeasurements(SensorSession)   → RecordingMotionMeasurementsView
.altitudeMeasurements(SensorSession) → RecordingAltitudeMeasurementsView
.locationMeasurements(SensorSession) → RecordingLocationMeasurementsView
```

---

## `ContentView` — Adaptive Tab Layout

**File:** `Layout/ContentView.swift`

`ContentView` renders a `TabView(.sidebarAdaptable)` whose structure adapts to
`horizontalSizeClass`. Tab customisation is persisted with
`@AppStorage("TabCustomizations")`.

```
ContentView
└── TabView(.sidebarAdaptable)
    │
    ├── [compact — iPhone / narrow iPad]
    │     Tab: Position     → PositionScreen    (owns its NavigationStack)
    │     Tab: Motion       → MotionScreen      (owns its NavigationStack)
    │
    └── [regular — iPad sidebar]
          TabSection: "Position"
            Tab: Location  → NavigationStack(positionStack) { LocationScreen }
            Tab: Altitude  → NavigationStack(positionStack) { AltitudeScreen }
          TabSection: "Motion"
            Tab: Acceleration → NavigationStack(motionStack) { AccelerationScreen }
            Tab: Gravity      → NavigationStack(motionStack) { GravityScreen }
            Tab: Gyroscope    → NavigationStack(motionStack) { GyroscopeScreen }
            Tab: Attitude     → NavigationStack(motionStack) { AttitudeScreen }
          Tab: Magnetometer → NavigationStack(magnetometerStack) { MagnetometerScreen }
          Tab: Recordings   → NavigationStack { RecordingsScreen }
          Tab: Settings     → NavigationStack { SettingsScreen }
```

On **compact** layout, `PositionScreen` and `MotionScreen` each own their own
`NavigationStack` internally. On **regular** layout, the `NavigationStack` is
lifted to the `ContentView` level so the sidebar can share path state across
sub-tabs within a section.

`onChangeOfSelectedTab()` stops both managers and resets all stacks on every
tab switch, preventing background sensor activity.

---

## Picker Screens — `PositionScreen` / `MotionScreen`

**Files:** `Views/Position/PositionScreen.swift`, `Views/Motion/MotionScreen.swift`

Both are grid pickers: a `ScrollView` wrapping a `LazyVGrid` of `CardView`
cells. Each cell is a `NavigationLink` that pushes the corresponding stack
value. They are only shown in compact layout; on iPad the sidebar items serve
the same role.

---

## The Three-Layer Sensor Pattern

Every sensor surface follows the same `Screen / View / List` split.
Acceleration is shown below as the reference implementation.

```
AccelerationScreen       (Layout/Lifecycle)
├── AccelerationView     (Live readouts + inline graphs)
└── CustomControlsView   (Floating controls, overlaid)
    └── [NavigationLink → MotionStack.accelerationLog]
                               │
                        AccelerationList   (History + export)
                        └── CustomControlsView
```

### `*Screen`
- Receives `@Environment(MotionManager.self)` (or `LocationManager`).
- Calls `motionManager.startMotionUpdates()` in `onAppear`.
- Hosts `*View` as its body, then overlays `CustomControlsView` at the bottom
  using `.safeAreaInset(edge: .bottom)` + `.overlay(alignment: .bottom)`.
- Sets `.navigationTitle`.

### `*View`
- Renders a `List` with `Section`s of live-updating values.
- Each axis row is a `DisclosureGroup` whose content is a `LineGraphSubView`
  (see Shared Components below).
- Contains a `NavigationLink(value: MotionStack.*Log)` to push the history list.
- Includes `RefreshRateView` sections where applicable.

### `*List`
- Renders `motionManager.motionArray.reversed()` (or location/altitude
  equivalents) in a plain `List`.
- Toolbar contains a `ShareSheet` that calls `shareCSV()` to export the
  session as a comma-separated file via `ExportManager`.
- Also overlays `CustomControlsView` so the user can manage recording from
  the log screen.

---

## Shared Components

### `CustomControlsView`
**File:** `Views/CustomControlsView/CustomControlsView.swift`

A floating action button built with iOS 26 Liquid Glass (`GlassEffectContainer`,
`.glassEffect`, `.glassEffectID`). An ellipsis button expands with a spring
animation to reveal three action buttons:

| Button | Action |
|---|---|
| Start | `locationManager.startLocationUpdates()` + `motionManager.startMotionUpdates/startAltitudeUpdates()` |
| Pause | `stopLocationUpdates()` + `stopMotionUpdates()` |
| Delete | `resetLocationUpdates()` + `resetMotionUpdates()` |

Each button also calls `showNotification(...)` to display a toast.
`CustomControlsView` is overlaid at the bottom of every Screen and List view.

---

### `LineGraphSubView`
**File:** `Views/LineGraph/LineGraphSubView.swift`

A Swift Charts `LineMark` chart. Initialised with a `Graph` domain selector
and a `GraphDetail` axis selector.

```swift
LineGraphSubView(graph: .motion, showGraph: .accelerationXAxis)
```

- Reads the appropriate `*Chart` rolling window from the manager (e.g.
  `motionManager.motionChart`).
- Calls `model.graphValue(for: showGraph)` for the Y value.
- Scales the Y axis dynamically to `[min − 10%, max + 10%]` of the visible
  data, preventing a flat line when values cluster in a narrow band.
- Hides the X axis labels; the chart is decorative and is marked
  `.accessibilityHidden(true)`.

---

### Notification (Toast) System
**Files:** `Views/Notification/`

A custom environment key `showNotification` carries a `(String) -> Void`
closure. `NotificationModifier` (applied globally in `SensorAppApp`) intercepts
calls and presents `NotificationView` as an overlay. Views call it with:

```swift
@Environment(\.showNotification) private var showNotification
showNotification("Started")
```

---

### `ExpandableChartView` / `FullScreenChartView` / `ChartSelection`
**Files:** `Views/LineGraph/ExpandableChartView.swift`, `Views/LineGraph/FullScreenChartView.swift`, `Views/LineGraph/ChartSelection.swift`

`ExpandableChartView` wraps `LineGraphSubView` with an expand-button overlay. Tapping the button sets a `@Binding<ChartSelection?>` which the parent presents as a `FullScreenChartView` sheet.

`ChartSelection` is a simple value type holding `graph: Graph`, `detail: GraphDetail`, and `title: LocalizedStringResource` — enough to reconstruct the full-screen chart from any call site.

`FullScreenChartView` presents a `NavigationStack` containing a full-frame `LineGraphSubView`. A `.safeAreaInset(edge: .bottom)` bar shows Min/Max/Avg statistics for the displayed axis (pulled from the appropriate manager via `resolvedStats`).

---

### `SensorStatisticsSection`
**File:** `Views/Statistics/SensorStatisticsSection.swift`

A reusable SwiftUI `Section` containing a centred `Grid` with four columns: axis label, Min, Max, Avg. Accepts `[AxisEntry]` constructed inline from `manager.statistics(for:)` calls. Shows a "No data recorded yet" placeholder when the array is empty. Appears in every `*View` (between readouts and Refresh Rate), pinned at the top of every `*List`, and as the compact stats bar inside `FullScreenChartView`.

---

### `CardView`
**File:** `Views/CardView.swift`

Reusable card used in picker grids. Accepts generic `Content: View` for its
label. Styled with Liquid Glass and the `.customTruncation()` modifier.

---

### `ShareSheet`
**File:** `Views/ShareSheet.swift`

Wraps `UIActivityViewController` as a `UIViewControllerRepresentable` button.
Receives a `URL` (produced by `ExportManager`) and presents the share sheet.

---

## App Intents Integration

**Files:** `AppIntents/`

`NavigateIntent: AppIntent` accepts a `NavigationOption` parameter and sets
`appState.appIntentTab` to the corresponding `RootTab`. `ContentView` reacts
via `onChange(of: appState.appIntentTab)` and calls
`appState.appIntentDrivenNavigation(horizontalSizeClass)`.

`SensorAppShortcuts: AppShortcutsProvider` registers the Siri phrase set.
`AppState.updateShortcutParameter()` is called on app launch to keep the
shortcut parameter list in sync.

---

## Settings & Release Notes

### `SettingsScreen`
**File:** `Views/Settings/SettingsScreen.swift`

A `Form` that surfaces all `UserSettings` fields for editing. Uses
`@Bindable(settingsManager)` to write directly into the manager, which
persists changes to `UserDefaults`. Also exposes alternate app icon selection
via `UIApplication.setAlternateIconName`.

### `ReleaseNotesScreen` / `ReleaseNotesView`
**Files:** `Views/ReleaseNotes/`

Displayed as a sheet on first launch after an update (controlled by
`UserSettings.showReleaseNotes`). Styled with Liquid Glass card backgrounds.
Content is sourced from `ReleaseNotes.xcstrings`, localised into all ten
supported languages.

---

## Environment Objects Summary

| Object | Injected by | Consumed by |
|---|---|---|
| `MotionManager` | `SensorAppApp` | All motion/altitude screens, `CustomControlsView`, `LineGraphSubView`, `FullScreenChartView` |
| `LocationManager` | `SensorAppApp` | Location screens, `CustomControlsView`, `LineGraphSubView`, `FullScreenChartView` |
| `SettingsManager` | `SensorAppApp` | `SettingsScreen`, `LineGraphSubView` |
| `RecordingManager` | `SensorAppApp` | `RecordingsScreen`, `CustomControlsView` |
| `AppState` | `SensorAppApp` | `ContentView`, picker screens, `RootTab`, route enums |
| `\.showNotification` | `NotificationModifier` (via `SensorAppApp`) | `CustomControlsView` |
