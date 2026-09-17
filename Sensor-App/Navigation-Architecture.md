# Navigation & View Hierarchy Architecture — Sensor-App (iOS)

This document describes how the iOS app is structured from the root entry point
down to individual sensor views, and how navigation state flows between them.

---

## Entry Point

`SensorAppApp` (file: `Layout/SensorAppApp.swift`) creates the three long-lived
managers and the navigation state object with `@State`, then injects them into
the environment before presenting `ContentView`.

```swift
@State private var motionManager    = MotionManager()
@State private var locationManager  = LocationManager()
@State private var settingsManager  = SettingsManager()
@State private var appState         = AppState()
@State private var metricKitManager = MetricKitManager()
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
| `positionStack` | `[NavigationRoute]` | Path for Location / Altitude navigator |
| `motionStack` | `[NavigationRoute]` | Path for all Motion navigators |
| `magnetometerStack` | `[NavigationRoute]` | Path for Magnetometer navigator |
| `recordingsStack` | `[NavigationRoute]` | Path for Recordings navigator |
| `selectedChart` | `ChartSelection?` | Chart presented full screen, if any |

All four stacks share the single ``NavigationRoute`` element type rather than each having
its own distinct path type — see `NavigationRoute` below for why.

**Key behaviours:**

- `onSizeClassChange(_:)` — called by `ContentView.onChange(of: horizontalSizeClass)`.
  Compact layout nests a granular screen under an umbrella tab (`.position`/
  `.motion`), pushing it as the first `positionStack`/`motionStack` entry;
  regular layout gives the granular screen its own tab instead, so that first
  entry is implicit in `selectedTab` and everything after it carries over
  unchanged. The method translates between the two representations using
  `PositionStack.rootTab`/`MotionStack.rootTab` (which owning tab a stack entry
  belongs to, regardless of nesting depth) and `RootTab.compactParent`/
  `positionStackRoot`/`motionStackRoot` (the reverse mapping) — `first`/
  `dropFirst()` on the way to regular, prepending the root on the way to
  compact. This works at any stack depth, not just today's two levels. It sets
  a one-shot `suppressNextSelectedTabChange` flag before reassigning
  `selectedTab` so the resulting `ContentView.onChange(of: selectedTab)` skips
  its stop-sensors/reset-stack side effects for this layout-driven change (a
  genuine tab switch still triggers them normally). Tabs identical in both
  layouts (`.magnetometer`/`.settings`/`.recordings`) are left untouched.
- `appIntentDrivenNavigation(_:)` — converts a `RootTab` app-intent value into
  concrete tab + stack-push navigation. On compact layout it uses
  `Task { try await Task.sleep(for: .seconds(0.5)) }` to defer the stack push
  until after the tab switch animation. Orthogonal to `onSizeClassChange`; it
  never sets the suppression flag, since a Siri-driven jump is a genuine
  navigation event.
- `resetStack()` — called by `ContentView` on every genuine tab change,
  stopping stale sensor sessions from persisting across tabs.
- `selectedChart` — backs the full-screen chart cover presented by
  `ContentView`; see `ExpandableChartView` / `FullScreenChartView` /
  `ChartSelection` below for why it lives here instead of local `@State`.

---

## Route Enums

Each route enum conforms to both `Hashable` and `View` (so
`navigationDestination(for:)` can simply render `$0` without a separate
switch at each call site). Only `NavigationRoute` itself is ever used as a
`NavigationStack` path element or `NavigationLink(value:)` payload — the
four per-tab enums below are wrapped inside it.

### `NavigationRoute`
**File:** `Layout/Navigation/NavigationStacks/NavigationRoute.swift`

```
.position(PositionStack)
.motion(MotionStack)
.magnetometer(MagnetometerStack)
.recordings(RecordingsStack)
```

Unifies every tab's path element type into one `Hashable`. This matters
because `.tabViewStyle(.sidebarAdaptable)` renders the `TabView` as a
`NavigationSplitView` with one shared detail column on iPad — binding two
tabs to differently-typed paths makes SwiftUI's `NavigationColumnState`
compare one stack's element against another's when switching tabs, which
crashes with `AnyNavigationPath.Error.comparisonTypeMismatch`. Sharing one
element type lets that comparison resolve to "not equal" instead of
trapping.

Also carries `rootTab: RootTab?` — the regular-layout tab a route promotes to
when it's the first entry in a stack (delegates to `PositionStack.rootTab` /
`MotionStack.rootTab`; `nil` for `.magnetometer` / `.recordings`, which have
no compact/regular translation). Used by `AppState.onSizeClassChange(_:)`.

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

Also carries `rootTab: RootTab`, mapping every case (however deeply nested) to
the regular-layout tab it lives under — surfaced through `NavigationRoute.rootTab`
and used by `AppState.onSizeClassChange(_:)` to translate the compact/regular
navigation representations.

### `MotionStack`
**File:** `Layout/Navigation/NavigationStacks/MotionStack.swift`

```
.acceleration    → AccelerationScreen    .accelerationLog → AccelerationList
.gravity         → GravityScreen         .gravityLog      → GravityList
.gyroscope       → GyroscopeScreen       .gyroscopeLog    → GyroscopeList
.attitude        → AttitudeScreen        .attitudeLog     → AttitudeList
```

Carries the same `rootTab: RootTab` computed property as `PositionStack`.

These per-tab enums (`PositionStack`, `MotionStack`, `MagnetometerStack`,
`RecordingsStack`) are unchanged from before the `NavigationRoute` refactor —
they still define the concrete cases and their `View` bodies. They're just no
longer used directly as a `NavigationStack` path or `NavigationLink(value:)`
payload; call sites wrap them as `.position(...)` / `.motion(...)` /
`.magnetometer(...)` / `.recordings(...)`.

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
          Tab: Recordings   → NavigationStack(recordingsStack) { RecordingsScreen }
          Tab: Settings     → NavigationStack { SettingsScreen }
```

On **compact** layout, `PositionScreen` and `MotionScreen` each own their own
`NavigationStack` internally. On **regular** layout, the `NavigationStack` is
lifted to the `ContentView` level so the sidebar can share path state across
sub-tabs within a section. Every one of these `NavigationStack`s is bound to
a `[NavigationRoute]` and declares a single
`.navigationDestination(for: NavigationRoute.self)` — see `NavigationRoute`
above.

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
    └── [NavigationLink → NavigationRoute.motion(.accelerationLog)]
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
- Contains a `NavigationLink(value: NavigationRoute.motion(.*Log))` to push the history list.
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

`ExpandableChartView` wraps `LineGraphSubView` with an expand-button overlay. Tapping the button reads `@Environment(AppState.self)` and sets `appState.selectedChart`. `ContentView` presents `FullScreenChartView` from that same property via `.fullScreenCover(item:)`, applied on the `TabView` itself rather than inside any individual `*View`.

This used to be a `@Binding<ChartSelection?>` backed by local `@State` on each `*View`, with `.fullScreenCover` attached there too — but a size-class change swaps the `if isCompact { … } else { … }` branch in `ContentView`, tearing down and recreating whichever `*View` was presenting, which dismissed the cover mid-use. Hoisting the state onto `AppState` and the modifier onto `ContentView` (neither of which are torn down by that branch swap) keeps the full-screen chart open across the transition.

`ChartSelection` is a simple value type holding `graph: Graph`, `detail: GraphDetail`, and `title: LocalizedStringResource` — enough to reconstruct the full-screen chart from any call site.

`FullScreenChartView` presents a `NavigationStack` containing a full-frame `LineGraphSubView`. A `.safeAreaInset(edge: .bottom)` bar shows Min/Max/Avg statistics for the displayed axis (pulled from the appropriate manager via `resolvedStats`).

---

### `SensorStatisticsSection`
**File:** `Views/Statistics/SensorStatisticsSection.swift`

A reusable SwiftUI `Section` containing a centred `Grid` with four columns: axis label, Min, Max, Avg. Accepts `[AxisEntry]` constructed inline from `manager.statistics(for:)` calls. Shows a "No data recorded yet" placeholder when the array is empty. Appears in every `*View` (between readouts and Refresh Rate), pinned at the top of every `*List`, and as the compact stats bar inside `FullScreenChartView`.

---

### `AdBannerView`
**File:** `Views/AdBannerView.swift`

A thin wrapper around `ExchangeBannerAdView` (KickstartSDK). Not a manager —
purely a `View` parameterized by an `apiKey` computed property (`"preview"`
in DEBUG, else read from Info.plist). Inserted via
`.safeAreaInset(edge: .bottom)` in `PositionScreen` and `LocationScreen`
(compact-width only on the latter).

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

### `DiagnosticsScreen`
**File:** `Views/Settings/DiagnosticsScreen.swift`

Linked from `SettingsScreen`. Reads `@Environment(MetricKitManager.self)` and
renders two sections: a Performance summary (from `latestReport`) and a
Diagnostics list (from `diagnostics`), each falling back to a
`ContentUnavailableView` when no data has arrived yet.

---

## Environment Objects Summary

| Object | Injected by | Consumed by |
|---|---|---|
| `MotionManager` | `SensorAppApp` | All motion/altitude screens, `CustomControlsView`, `LineGraphSubView`, `FullScreenChartView` |
| `LocationManager` | `SensorAppApp` | Location screens, `CustomControlsView`, `LineGraphSubView`, `FullScreenChartView` |
| `SettingsManager` | `SensorAppApp` | `SettingsScreen`, `LineGraphSubView` |
| `RecordingManager` | `SensorAppApp` | `RecordingsScreen`, `CustomControlsView` |
| `AppState` | `SensorAppApp` | `ContentView`, picker screens, `RootTab`, route enums |
| `MetricKitManager` | `SensorAppApp` | `DiagnosticsScreen` |
| `\.showNotification` | `NotificationModifier` (via `SensorAppApp`) | `CustomControlsView` |
