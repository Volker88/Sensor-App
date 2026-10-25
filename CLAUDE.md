# CLAUDE.md — Sensor-App

Project memory for Claude Code. Read this before making changes.

## Overview

Sensor-App exposes every hardware sensor on iPhone, iPad, and Apple Watch:
acceleration, gravity, gyroscope, attitude, magnetometer, location/GPS, and
altitude/barometric pressure. Live values are shown as readouts and Swift
Charts line graphs, can be logged into a reversed history list, and exported
as CSV via the share sheet. Shipping on the App Store; source is public.

- **Marketing version:** 7.2.0 · **Build:** date-based (`YYYYMMDD.N`)
- **Deployment target:** iOS / watchOS / tvOS / macOS / visionOS **27.0**
- **Language:** Swift 6.2, strict concurrency, `@MainActor` default isolation, approachable concurrency
- **License:** see `LICENSE.md`

## Targets & layout

Three first-party modules plus tests:

| Path | What it is |
|---|---|
| `Sensor-App/` | iOS/iPadOS app — TabView UI, navigation, views, App Intents |
| `Sensor-App-WatchApp/` | watchOS app — simpler `List`/`NavigationStack`, one `*View` per sensor |
| `Sensor-App-Framework/` | Shared logic: sensor managers, models, SwiftData schema, RecordingManager, extensions, localization enum |
| `Tests/` | `iOSUnitTests` (Swift Testing), `iOSUITests` & `watchOSUITests` (XCTest), `0_Test Plans/`, screenshot tests. **New test files must be added by hand** to the exclusion lists (app, watch, framework) and the right test target's inclusion list in `project.xcproj`, or they compile into the app targets |
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
  `magnetometerStack`), `appIntentTab` for Siri-driven navigation, and
  `selectedChart` (which chart, if any, is presented full screen).

### Navigation

- `ContentView` uses a `TabView(.sidebarAdaptable)`. Compact nests sensor
  screens inside per-tab `NavigationStack`s; regular flattens them into
  `TabSection`s in the sidebar. The choice is `NavigationLayout.usesCompactLayout`:
  the flat layout needs regular width *and* height and is **iPad-only**. Phones
  always stay compact, because a Plus/Max in landscape or an unfolded iPhone
  Duo reports regular size classes and the ~9 flat tabs would overflow into a
  More menu. The result is exposed as the `usesCompactLayout` environment value
  (don't re-derive it from size classes in views).
- Routes are **enum-based** and type-safe: `RootTab`, `MotionStack`,
  `PositionStack`, `MagnetometerStack` each conform to `View` (or supply a
  destination view) and back `navigationDestination(for:)`.
- `AppState.onSizeClassChange(_:)` (fed a size class derived from the layout
  decision, not the raw environment one) preserves the current tab/screen across
  iPad compact↔regular layout changes (Split View, Stage Manager) instead of
  resetting to the Position tab. It translates between the compact
  (umbrella-tab + pushed stack) and regular (dedicated tab per screen)
  representations via `PositionStack`/`MotionStack.rootTab` and
  `RootTab.compactParent`/`positionStackRoot`/`motionStackRoot` — see
  `Navigation-Architecture.md` for the full algorithm. Because that same
  `if isCompact { … } else { … }` branch swap also tears down local `@State`
  in whichever `*View` was presenting, `selectedChart` (full-screen chart
  cover) is hoisted onto `AppState` rather than kept per-screen, so it isn't
  dismissed by the transition.

### View naming convention (iOS)

Per sensor, three layers:
- `*Screen` — container; starts/stops the sensor in `onAppear`, hosts the
  floating controls via `safeAreaInset`.
- `*View` — live readouts + inline `LineGraphSubView` + statistics section + links.
- `*List` — statistics section at top, then full reversed history with CSV export.

watchOS uses a single `*View` per sensor (no Screen/List split). Each watch
sensor view applies `.sensorScreen(.motion | .altitude | .location)`
(`SensorScreenModifier`, `Sensor-App-WatchApp/View/Controls/`), which claims the
sensor on appear with a per-instance UUID client ID, releases it on disappear,
and adds `SensorControls`: a bottom-bar `ToolbarContent` with a Start/Pause
toggle and Delete that act on that one sensor only, plus a Record/Stop toggle
so a session can be started or ended from any sensor view. Start/Pause and
Delete are disabled while a recording is active (same rule as iOS
`CustomControlsView`). Both the Record button and `WatchRecordingView` go
through `WatchRecordingController` (`View/Controls/`): `start()` clears the
buffers and claims *all* sensors under a stable `"WatchRecording"` client ID,
then starts the recording; `stop()` saves with source `"Apple Watch"`, clears
the buffers and drops that claim. The recording's claim is what keeps sensors
alive while you navigate mid-recording, so screens just release their own
claims normally and `WatchRecordingView` has no sensor lifecycle of its own. The button cases,
SF Symbols and localized strings come from the framework's
`SensorControlAction` enum, shared by both apps; each target adds its own
`accessibilityIdentifier` (and iOS the radial `offset`) in
`Extension+SensorControlAction.swift`.

### Sensors

- **MotionManager** wraps `CMMotionManager` + `CMAltimeter`. Both only expose
  closure callbacks (no native async sequence like `CLLocationUpdate`), so each
  is bridged into an `AsyncStream<MotionModel>` / `AsyncStream<AltitudeModel>`:
  the CoreMotion closure (delivered to `.main`) builds the model and
  `continuation.yield`s it; a `Task { for await model in stream { ... } }`
  applies it to `motion`/`motionArray`/`motionChart` (same shape as
  `LocationManager` below). The `Continuation` is stored per-stream so
  `stopMotionUpdates()` — and a restart via `sensorUpdateInterval`'s `didSet`
  calling `start...Updates()` again — can `finish()` the old stream before
  starting a new one (CMMotionManager just replaces the handler in place on a
  second `start` call, so without this the old stream's consuming `Task` would
  leak). Producer and consumer both run on MainActor, so this is structural
  parity with `LocationManager`, not a race fix.
- **LocationManager** wraps `CLLocationManager` using **modern async/await**
  (`for try await update in CLLocationUpdate.liveUpdates()`).
- Both cap chart arrays at `UserSettings.graphMaxPoints`.
- **Running state & client tracking:** `MotionManager.isMotionRunning` /
  `isAltitudeRunning` and `LocationManager.isRunning` reflect whether a stream
  actually started (the old `updatesStarted` flag is gone). Screens that share a
  manager register via `start…Updates(for: clientID)` and release via
  `releaseMotionUpdates(for:)` / `releaseAltitudeUpdates(for:)` /
  `releaseLocationUpdates(for:)`; a sensor stops and resets only when no client
  needs it, which prevents one screen's late `onDisappear` from undoing the
  next screen's `onAppear`. The watch app uses this; iOS still calls the
  client-less start/stop. `MotionManager` naming: `stopMotionUpdates()` /
  `resetMotionUpdates()` act on *both* motion and altitude;
  `stopDeviceMotionUpdates()` / `resetDeviceMotionUpdates()` and
  `stopAltitudeUpdates()` / `resetAltitudeUpdates()` act on one.
- **Recording keeps sensors alive across navigation:** while
  `RecordingManager.isRecording`, iOS skips the stop in
  `ContentView.onChangeOfSelectedTab()` and the stop/reset in
  `LocationView.onDisappear()`; on the watch, `WatchRecordingController`'s own
  sensor claim outlives any screen's release. Pause and
  Delete are disabled during a recording on both platforms (on iOS Start too —
  only Record/Stop stays enabled), so a session can't end up with gaps or lose
  data. `CustomControlsView` dims disabled buttons itself (secondary foreground,
  non-interactive glass) because its explicit colors override SwiftUI's
  automatic disabled styling.
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
- **Recordings (SwiftData + CloudKit):** `RecordingManager` is the sole write
  path. On iOS, both entry points (`CustomControlsView`'s Record button and
  `RecordingControlSection`) go through `RecordingController`
  (`Sensor-App/Views/Recordings/`): `start()` stops and resets every sensor,
  restarts them all, then calls `startRecording()`, so a session never contains
  data from before the tap; `stop()` calls `stopRecording(motionArray:altitudeArray:locationArray:source:)`,
  which converts in-memory models to `MotionMeasurement` / `AltitudeMeasurement` /
  `LocationMeasurement` rows inside a `SensorSession` and saves in one batch,
  then stops and resets the sensors.
  The schema is versioned (`ModelsSchemaV1` → `DatabaseMigrationPlan`) and
  synced via CloudKit private database. `RecordingsScreen` has a
  `RecordingControlSection` at the top: Start Recording when idle (no sensors
  run on that tab, so `RecordingController.start()` starting all of them is
  what makes this work), and while active, live motion/altitude/location
  sample counts (mirroring `WatchRecordingView`) plus Stop Recording. A
  `RecordingsStack` enum drives the
  recordings navigation (`RecordingsScreen` → `RecordingDetailScreen` →
  individual measurement views). Saved sessions can be renamed (iOS only) via
  `RecordingManager.rename(_:to:)`, which trims and rejects empty names. It's
  reached from the detail screen's editable title (`.navigationTitle(Binding)`
  + `.toolbarRole(.editor)`) and from a swipe action / context menu + alert on
  `RecordingsScreen`. Custom swipe actions replace `onDelete`'s synthesized
  one, so Delete is declared explicitly there. `ExportManager.getFile` passes
  every filename through `sanitizedFilename(_:)`, so `/`, `:` etc. never reach
  the file system. See `Sensor-App-Framework/SwiftData/DataArchitecture.md`.
- **Full Screen Charts:** `ExpandableChartView` wraps each `LineGraphSubView`
  with an expand-button overlay; tapping it sets `AppState.selectedChart`,
  which `ContentView` presents as a `FullScreenChartView` via
  `.fullScreenCover(item:)`. The presentation is anchored on `ContentView`
  (not on the individual `*View`) specifically so it survives the iPad
  compact↔regular branch swap — see `onSizeClassChange` above. The full-screen
  view shows the same chart maximised with a statistics bar (Min/Max/Avg) in a
  `.safeAreaInset(edge: .bottom)`.
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
- **MetricKit diagnostics:** `MetricKitManager` (iOS-only, `Sensor-App-Framework/API/MetricKitManager.swift`)
  wraps `MXMetricManager`, consuming `metricReports`/`diagnosticReports` as
  `for await` sequences. Exposes `latestReport` (CPU/GPU time, peak memory,
  suspended-memory average, weighted hang/launch time) and `diagnostics`
  (crash/hang/CPU/disk-write/launch/memory events, capped at 50). DEBUG builds
  also dump raw JSON payloads to the documents directory. Injected the same
  way as the other managers (`@State` in `SensorAppApp`, `.environment(...)`);
  surfaced in `DiagnosticsScreen` off `SettingsScreen`.
- **Kickstart Exchange ad banner:** `AdBannerView` wraps `ExchangeBannerAdView`
  from the `KickstartSDK` package (product `KickstartExchange`). Uses the
  `"preview"` API key in DEBUG, otherwise reads `KICKSTART_EXCHANGE_API_KEY`
  from Info.plist (sourced from the gitignored `Secret.xcconfig`). It's a
  plain SwiftUI view, not a manager — no app-lifecycle SDK initialization.
  Shown via `.safeAreaInset(edge: .bottom)` in `PositionScreen` and
  `LocationScreen` (compact-width only on the latter).
- **Kickstart Signal feature board:** `SignalBoardScreen`
  (`Sensor-App/Views/Settings/`) wraps `SignalBoardView` from the same
  `KickstartSDK` package (product `KickstartSignal`, SDK ≥ 0.6.0) in a
  `NavigationStack` with a Close button. Presented as a sheet from the
  "Feedback → Feature Requests" section in `SettingsScreen`, where users can
  suggest features and vote. Reuses the same API-key logic as `AdBannerView`
  (`"preview"` in DEBUG, `KICKSTART_EXCHANGE_API_KEY` otherwise) — no separate
  secret.
- **Unit conversion:** sensor values are stored internally in SI/default
  units (meters, m/s, kPa, radians) and converted only at the edges via
  `CalculationManager` (`calculateSpeed`/`calculatePressure`/`calculateHeight`,
  driven by `UserSettings`' unit fields). This applies both to the live
  in-memory models (`LocationModel`/`AltitudeModel`, via `calculatedX`/`xUnit`
  computed properties) and to persisted recordings, via
  `Extension+LocationMeasurement.swift` / `Extension+AltitudeMeasurement.swift`
  in `Sensor-App-Framework/SwiftData/`, which mirror the same computed-property
  pattern onto the SwiftData models so exported/reviewed sessions also honor
  current unit settings. `Extension+MotionMeasurement.swift` follows the same
  file-naming pattern but only converts stored radians to degrees for
  attitude — no `UserSettings` involved; the underlying `MotionMeasurementV1`
  `attitudeRoll`/`Pitch`/`Yaw` fields are radians, and their doc-comments now
  say so (previously mislabeled "degrees" — see `SwiftData/DataArchitecture.md`).

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

- `LocationModel` / `AltitudeModel` computed properties (plus their SwiftData
  mirrors `Extension+LocationMeasurement.swift` / `Extension+AltitudeMeasurement.swift`)
  previously instantiated fresh `CalculationManager()` / `SettingsManager()` on
  every access. Mitigated by adding `CalculationManager.shared` /
  `SettingsManager.shared` singletons and switching all ~20 call sites to use
  them — no more per-access allocation. Note this is a mitigation, not the full
  fix: these are value types with no environment access, so properly injecting
  the managers (rather than reaching for a shared instance) would require
  turning the computed `var`s into methods and threading the managers through
  every `*View`/`*List` call site — deferred as a larger follow-up refactor.

## Known issues

- **App Shortcuts not visible in Shortcuts.app:** The `SensorAppShortcuts`
  provider compiles and Siri phrases work, but the default shortcuts do not
  appear automatically under the app's entry in the Shortcuts app. The
  "missing `updateAppShortcutParameters()` call" candidate is ruled out — it's
  already wired up (`AppState.updateShortcutParameter()`, called from
  `SensorAppApp`'s `.onAppear`). Remaining candidates: an iOS 27 beta
  registration timing issue, or a requirement that the app be run on a
  physical device at least once post-install. See Journal.md for the full
  investigation log.
