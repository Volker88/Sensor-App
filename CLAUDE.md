# CLAUDE.md — Sensor-App

Project memory for Claude Code. Read this before making changes.

## Overview

Sensor-App exposes every hardware sensor on iPhone, iPad, and Apple Watch:
acceleration, gravity, gyroscope, attitude, magnetometer, location/GPS, and
altitude/barometric pressure. Live values are shown as readouts and Swift
Charts line graphs, can be logged into a reversed history list, and exported
as CSV via the share sheet. Shipping on the App Store; source is public.

- **Marketing version:** 7.0.0 · **Build:** date-based (`YYYYMMDD.N`)
- **Deployment target:** iOS / watchOS / tvOS / macOS / visionOS **27.0**
- **Language:** Swift 6.2, strict concurrency, `@MainActor` default isolation, approachable concurrency
- **License:** see `LICENSE.md`

## Targets & layout

Three first-party modules plus tests:

| Path | What it is |
|---|---|
| `Sensor-App/` | iOS/iPadOS app — TabView UI, navigation, views, App Intents |
| `Sensor-App-WatchApp/` | watchOS app — simpler `List`/`NavigationStack`, one `*View` per sensor |
| `Sensor-App-Framework/` | Shared logic: sensor managers, models, extensions, localization enum |
| `Tests/` | `iOSUnitTests` (Swift Testing), `iOSUITests` & `watchOSUITests` (XCTest), `0_Test Plans/`, screenshot tests |
| `Configuration/` | `.xcconfig` build settings (`General`, `Debug`, `Release`, `Secret`) |
| `fastlane/`, `screenshots/` | Screenshot automation |

> **Important:** the Xcode project uses **file-system-synchronized groups**
> (`PBXFileSystemSynchronizedRootGroup`). The folder on disk *is* the source of
> truth — files are not individually listed in `project.pbxproj`. Adding a file
> to a synced folder includes it in the build automatically; **stray or broken
> files (duplicate `.xcassets`/`.icon`, " 2"/" 3" copies) will be picked up by
> the build and can crash `actool`.** Keep `Sensor-App/Resources` clean.

## Architecture

### State & data flow

- Shared state lives in `@MainActor @Observable` classes in the framework:
  `MotionManager`, `LocationManager`, `SettingsManager`, `CalculationManager`,
  `AppUpdates`. `ExportManager` is a plain class (stateless helper).
- Managers are created once in the app entry point with `@State` and passed
  down via `.environment(...)`; views read them with `@Environment` and bind
  with `@Bindable`. **No `ObservableObject` / `@Published` / `@StateObject`.**
- Navigation state is `AppState` (`@MainActor @Observable`): `selectedTab`,
  per-tab navigation-path arrays (`positionStack`, `motionStack`,
  `magnetometerStack`), and `appIntentTab` for Siri-driven navigation.

### Navigation

- `ContentView` uses a `TabView(.sidebarAdaptable)`. Compact (iPhone) nests
  sensor screens inside per-tab `NavigationStack`s; regular (iPad) flattens
  them into `TabSection`s in the sidebar.
- Routes are **enum-based** and type-safe: `RootTab`, `MotionStack`,
  `PositionStack`, `MagnetometerStack` each conform to `View` (or supply a
  destination view) and back `navigationDestination(for:)`.

### View naming convention (iOS)

Per sensor, three layers:
- `*Screen` — container; starts/stops the sensor in `onAppear`, hosts the
  floating controls via `safeAreaInset`.
- `*View` — live readouts + inline `LineGraphSubView` + statistics section + links.
- `*List` — statistics section at top, then full reversed history with CSV export.

watchOS uses a single `*View` per sensor (no Screen/List split).

### Sensors

- **MotionManager** wraps `CMMotionManager` + `CMAltimeter` using
  **closure callbacks** delivered to `.main`.
- **LocationManager** wraps `CLLocationManager` using **modern async/await**
  (`for try await update in CLLocationUpdate.liveUpdates()`).
- Both cap chart arrays at `UserSettings.graphMaxPoints`.
- In `DEBUG && targetEnvironment(simulator)` (motion) or with the
  `enable-testing` launch argument (location), managers populate **mock data**
  so the simulator/UI tests have something to show.

### Other notable pieces

- **Settings** persist as JSON in `UserDefaults` via `SettingsManager`
  (`UserSettings: Codable`). Alternate app icons via `setAlternateIconName`.
- **App Intents / Siri:** `NavigateIntent` (`NavigationIntent.swift`) +
  `NavigationOption` (AppEnum with 8 destinations) + `SensorAppShortcuts`
  (AppShortcutsProvider); the intent sets `appState.appIntentTab` and
  `ContentView` reacts. **Known issue:** default App Shortcuts do not appear
  automatically in the Shortcuts app — root cause under investigation (see
  Journal.md).
- **Notifications (toasts):** custom environment key (`showNotification`) +
  `NotificationModifier` applied globally with `.withNotificationView()`.
- **iOS 27 Liquid Glass:** `.glassEffect`, `GlassEffectContainer`,
  `.buttonStyle(.glassProminent)` in controls, cards, and release notes.
- **Sensor Statistics:** `AxisStatistics` (Framework model) + `Collection<Double>.statistics`
  extension compute min/max/average from the full history arrays. `MotionManager` and
  `LocationManager` each expose a `statistics(for: GraphDetail) -> AxisStatistics?`
  method (reuses `graphValue(for:)`, so attitude values are already in degrees). The
  reusable `SensorStatisticsSection` view renders a centered `Grid` with Min/Max/Avg
  columns; it appears in every `*View`, every `*List` (pinned at top), and as a compact
  bar in `FullScreenChartView`. Stats reset automatically when the history arrays are
  cleared — no separate reset path needed.
- **Localization:** String Catalogs (`.xcstrings`) in `Sensor-App/Resources`.
  Languages: en, zh-Hans, cs, fr, de, it, ja, ko, pt, es (see
  `SupportedLanguage`). Access via `LocalizedStringResource`. Offer to
  translate new keys into all supported languages.

## Build, run, test

- Build with the `BuildProject` MCP tool (preferred over the command line).
- Verify quickly with `XcodeRefreshCodeIssuesInFile` before a full build.
- Test plans live in `Tests/0_Test Plans/` (separate iOS/watchOS Unit, UI,
  Full, and Screenshot plans).
- UI tests launch with `enable-testing` (inject mock data + test defaults) and
  `disable-animations`.

## Conventions

- Follow the global Xcode instructions in `~/.../ClaudeAgentConfig/CLAUDE.md`
  (modern Foundation `FormatStyle`, `foregroundStyle`, `clipShape(.rect(...))`,
  `Tab` API, no GCD, no force unwraps, one type per file, etc.).
- New shared logic → `Sensor-App-Framework`. Keep view logic testable.
- Unit tests use **Swift Testing** (`@Test`, `#expect`); UI tests use XCTest.
- **Concurrency flags** in `Configuration/General.xcconfig`:
  `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` — all unannotated code is
  implicitly `@MainActor`; and `SWIFT_APPROACHABLE_CONCURRENCY = YES` —
  bundles `NonisolatedNonsendingByDefault`, `InferIsolatedConformances`, and
  three related features. Explicitly annotate code that genuinely runs off the
  main actor with `nonisolated` or `@concurrent`; never use `nonisolated(unsafe)`
  as a workaround.

## Known tech debt (see Journal.md “The Journey”)

- `LocationModel` / `AltitudeModel` computed properties instantiate fresh
  `CalculationManager()` / `SettingsManager()` on every access (should be
  injected).
- `ExportManager.getFile` force-unwraps the temp-file URL.
- `AppState.onSizeClassChange` keeps a large commented-out block on purpose —
  it's the parked iPad navigation-restoration feature, not dead code.

## Known issues

- **App Shortcuts not visible in Shortcuts.app:** The `SensorAppShortcuts`
  provider compiles and Siri phrases work, but the default shortcuts do not
  appear automatically under the app's entry in the Shortcuts app. Root cause
  is not yet determined — candidates include a missing `updateAppShortcutParameters()`
  call in the app lifecycle, an iOS 27 beta registration timing issue, or a
  requirement that the app be run on a physical device at least once post-install.
  See Journal.md for the full investigation log.
