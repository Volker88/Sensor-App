# Journal.md — Sensor-App

A living, slightly opinionated logbook of how this app is built, why, and what
bit us along the way. Read it like a story, not a spec sheet.

## The Big Picture

Imagine handing someone an iPhone and saying, "Everything this slab of glass
can *feel* about the world — show it to me." That's Sensor-App. Your phone is
secretly bristling with sensors: it knows which way is down (gravity), how it's
tumbling through space (gyroscope + attitude), where on Earth it is (GPS), how
high the air pressure says you are (barometer/altimeter), and which way north
is (magnetometer). Sensor-App pulls all of that out of the black box and puts
it on screen — as live numbers, as scrolling line charts, and as exportable CSV
logs you can hand to a spreadsheet. It runs on iPhone, iPad, *and* Apple Watch.

Think of it as a stethoscope for your device's inner ear.

## Architecture Deep Dive

The app is three buildings on one campus:

1. **The Framework** (`Sensor-App-Framework`) is the engine room. It doesn't
   know or care what the UI looks like. It talks to Apple's Core Motion and
   Core Location, converts units, persists settings, and exports files. Pure
   logic, fully testable.
2. **The iOS app** (`Sensor-App`) is the showroom — TabView, navigation,
   charts, the Liquid Glass controls.
3. **The Watch app** (`Sensor-App-WatchApp`) is the compact pop-up shop:
   same engine, a much simpler storefront (a `List` and one view per sensor).

The glue is the **`@Observable` + `@Environment` pattern**. Each manager is a
`@MainActor @Observable` class — think of it as a translator that sits between
raw hardware and SwiftUI. The app creates each manager *once* (`@State`),
drops them into the environment, and every view that needs sensor data simply
reaches into the environment and reads a published property. When the sensor
ticks, the property changes, and SwiftUI redraws. No Combine, no `@Published`,
no `ObservableObject` — the modern observation model does it all.

**Navigation** is the clever bit. Instead of stringly-typed segues, every
destination is an *enum that knows how to be a view*. `RootTab`, `MotionStack`,
`PositionStack`, and `MagnetometerStack` are plain `Hashable` enums that drive
`navigationDestination(for:)`. `AppState` holds the current tab and a
navigation-path array per tab. The payoff: the same enum cases let **Siri**
deep-link into any screen (an App Intent just sets `appState.appIntentTab` and
the UI follows).

One subtle shape worth knowing: the UI **adapts to size class**. On an iPhone,
sensors live *inside* a tab's `NavigationStack` (drill down: Motion →
Acceleration → Log). On an iPad, those same screens fan out flat into sidebar
`TabSection`s. `ContentView` reads the horizontal size class and arranges
accordingly; `AppState` translates App-Intent navigation into the right shape
for whichever layout is active.

## The Codebase Map

```
Sensor-App-Framework/        ← the engine room (no UI)
  API/                       ← managers (the "translators")
    MotionManager            CMMotionManager + CMAltimeter  (callbacks)
    LocationManager          CLLocationManager              (async/await)
    SettingsManager          UserDefaults <-> UserSettings JSON, app icons
    CalculationManager       unit conversions (Measurement)
    ExportManager            writes CSV to temp dir, returns URL
    AppUpdates               version check → release-notes sheet
  Model/                     value types: MotionModel, LocationModel,
                             AltitudeModel, AxisStatistics, UserSettings,
                             MapKitSettings, …
  Extension/                 Logger categories, Double helpers
  Localization/              SupportedLanguage enum, preview modifier

Sensor-App/                  ← the iOS showroom
  Layout/                    SensorAppApp (entry), ContentView (TabView),
                             Navigation/ (AppState, RootTab, *Stack enums)
  Views/                     per sensor: *Screen / *View / *List
                             + CardView, LineGraph, Notification, Settings,
                               CustomControls (Liquid Glass), ReleaseNotes,
                               Statistics/SensorStatisticsSection
  AppIntents/                NavigateIntent, NavigationOption, Shortcuts
  Resources/                 *.xcstrings, Assets.xcassets, *.icon

Sensor-App-WatchApp/         ← the watch storefront (one *View per sensor)
Tests/                       iOSUnitTests (Swift Testing), *UITests (XCTest)
Configuration/               *.xcconfig (targets, version, signing secrets)
```

## Tech Stack & Why

| Choice | Why |
|---|---|
| **SwiftUI + `@Observable`** | One UI codebase across iPhone/iPad/Watch; modern observation removes Combine boilerplate and re-renders precisely. |
| **Swift Concurrency** | `async/await` reads top-to-bottom; `LocationManager` consumes `CLLocationUpdate.liveUpdates()` as a clean async sequence. |
| **Swift Charts** | First-party, declarative line graphs — `LineMark` over a `ForEach`, no third-party charting dependency. |
| **App Intents** | Siri + Shortcuts deep-linking for free, sharing the same route enums as the UI. |
| **String Catalogs (`.xcstrings`)** | 10 languages managed in one place, type-safe via `LocalizedStringResource`. |
| **Swift Testing** | Expressive `@Test`/`#expect`, parameterized `arguments:` for the unit suite (UI tests stay on XCTest where the tooling lives). |
| **File-system-synchronized groups** | The folder *is* the project — less `.pbxproj` merge pain. (Trade-off: stray files get built. See war story below.) |
| **`.xcconfig` files** | Build settings live in text, diff cleanly, and keep signing secrets out of git (`Secret.xcconfig`). |
| **Liquid Glass (iOS 27)** | `.glassEffect`, `GlassEffectContainer`, `.glassProminent` buttons for a native, modern control surface. |

## The Journey

### 🐛 The `actool` nil-object crash (the duplicate-assets ghost)

**Symptom:** the build died with
`Exception while running actool: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]`.

**The hunt:** `actool` is the asset compiler, so suspicion fell on the asset
catalogs and the new `.icon` (Icon Composer) bundles. Listing
`Sensor-App/Resources` revealed the culprits hiding in plain sight: nine
directories with the tell-tale Finder/iCloud " 2" and " 3" suffixes —
`Assets 2.xcassets`, `AppIcon-V1 2.icon`, and friends — all created a week after
the originals, all with locked-down `drwx------` permissions and **0 bytes of
real content**. They were half-finished duplicate copies, missing the
`Contents.json` / `icon.json` manifests that make a catalog valid.

**The "aha":** normally a stray folder is harmless — but this project uses
**file-system-synchronized groups**, where the folder on disk *is* the build
input. So `actool` dutifully tried to compile the broken duplicates, found a
catalog with no manifest, and handed `nil` to an array that refused it. Crash.

**The fix:** delete the nine duplicates. They were untracked by git and absent
from `project.pbxproj`, so nothing else needed to change. Build green in ~9s.

**Lesson burned in:** with synced groups, *keep the resource folders pristine* —
a stray duplicate isn't cosmetic clutter, it's a build input.

### 🧭 Navigation that bends to the device

Getting one set of route enums to serve both an iPhone's nested stacks and an
iPad's flat sidebar — *and* Siri deep-links — took real thought. The resolution
was to make `AppState.appIntentDrivenNavigation` size-class aware: on iPad it
just sets the tab; on iPhone it sets the parent tab and then pushes the child
onto the stack. The 0.5 s delay that lets the tab switch settle before pushing
is now expressed as `Task { [appIntentTab] in try await Task.sleep(for: .seconds(0.5)); … }`,
inheriting `@MainActor` from the class rather than reaching for GCD.

### ⚡ Default `@MainActor` isolation + Approachable Concurrency (2026-07-01)

Two lines in `Configuration/General.xcconfig` changed the shape of the whole
codebase:

```xcconfig
SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor
SWIFT_APPROACHABLE_CONCURRENCY = YES
```

**What they do.** The first makes `@MainActor` the implicit isolation for every
unannotated type and function — no more risk of forgetting to annotate a new
manager or view helper and accidentally leaving it unprotected. The second
enables a curated bundle of five upcoming features, the most impactful being
`NonisolatedNonsendingByDefault` (unstructured `async` functions now run on the
caller's actor by default instead of jumping to the cooperative thread pool) and
`InferIsolatedConformances` (a `@MainActor` type's protocol conformances are
inferred as `@MainActor`-isolated, so you don't get surprising nonisolated
witness mismatches).

**How the codebase held up.** Almost perfectly. Because every manager and view
was already explicitly `@MainActor @Observable`, the compiler had no new
ambiguity to resolve in the hot paths. The only error the flags surfaced was a
single line in `NotificationEnvironmentKey.swift`:

```swift
// before — conflicted: @MainActor-inferred initializer assigned to nonisolated(unsafe)
nonisolated(unsafe) static let defaultValue = ShowNotificationAction { _ in }

// after — type and property share the same @MainActor isolation; SwiftUI handles it
static let defaultValue = ShowNotificationAction { _ in }
```

The `nonisolated(unsafe)` annotation was a pre-6.2 workaround so that an
`EnvironmentKey.defaultValue` could be declared without actor annotation. With
default `@MainActor` isolation, the type and the property align, `EnvironmentKey`
conformance is inferred as `@MainActor`-isolated (via `InferIsolatedConformances`),
and SwiftUI on iOS 27+ is perfectly happy — `EnvironmentValues` is accessed
exclusively from view bodies, which are already on the main actor.

**Alongside, two legacy GCD calls were retired:**
- `MotionManager.startAltitudeUpdates` had a redundant `DispatchQueue.main.async {}`
  wrapping code that was already running inside a `.main`-delivered CoreMotion
  callback. Gone.
- `AppState.appIntentDrivenNavigation` used `DispatchQueue.main.asyncAfter` for
  the tab-switch delay. Replaced with `Task { [appIntentTab] in try await
  Task.sleep(for: .seconds(0.5)); … }`. The task inherits `@MainActor` from its
  enclosing class, `appIntentTab` is captured by value before the `defer` resets it,
  and the navigation properties are accessed safely without any GCD involvement.

Zero errors after the change. The engine is cleaner.

---

### 🚀 Version 7.0 — iOS 27 and the Siri Shortcuts chapter (2026-06-28)

**The bump:** This release crosses a milestone — marketing version 7.0.0, build
`20260628.1`, and a deployment target lift to iOS/watchOS/tvOS/macOS/visionOS
**27.0**. The version jump reflects the new OS baseline and a meaningful feature
addition: Siri and Shortcuts deep-linking.

**What shipped — App Intents:**
Three new files land in `Sensor-App/AppIntents/`:

- `NavigationIntent.swift` — defines `NavigateIntent: AppIntent`. It receives an
  injected `AppState` via `@Dependency`, accepts a `NavigationOption` parameter,
  and on `perform()` sets `appState.appIntentTab` to the matching destination.
  The intent is foreground-only (`supportedModes: .foreground`) so the app comes
  to front when Siri fires it.
- `NavigationOption.swift` — an `AppEnum` covering all eight destinations
  (location, altitude, acceleration, gravity, gyroscope, attitude, magnetometer,
  settings), each with a title, subtitle, and SF Symbol icon. This is the same
  vocabulary the UI already uses, so the Siri surface and the nav stack share
  one truth.
- `SensorAppShortcuts.swift` — the `AppShortcutsProvider` that registers the
  intent with two phrases: *"Navigate in {appName}"* and *"Navigate to {option}
  in {appName}"*.

The design is clean: Siri knows about sensors because the sensors are already
enums. No duplicate routing logic.

**What shipped — LocationManager error handling:**
`LocationManager.startLocationUpdates()` previously ran its `for try await`
loop inside a bare `Task { }` — if `CLLocationUpdate.liveUpdates()` threw, the
error would silently vanish. Wrapped the loop in a proper `do/catch` that logs
to `Logger.coreLocation.error(...)`. Small fix, but important for diagnosing
location failures in the field.

**⚠️ Known issue — Shortcuts not appearing:**
The App Shortcuts infrastructure compiles cleanly and Siri voice phrases work,
but the shortcuts **do not appear automatically** under Sensor-App in the
Shortcuts app. The expected behaviour is that `AppShortcutsProvider` conformers
surface their shortcuts without any explicit registration call — but so far
they're invisible to the Shortcuts UI.

Candidates under investigation:
1. A missing `AppShortcutsProvider.updateAppShortcutParameters()` call at app
   launch (required in some configurations to trigger registration).
2. iOS 27 beta timing / caching quirk — the Shortcuts daemon may need a device
   reboot or re-install cycle to index a new provider.
3. The `AppShortcuts.xcstrings` catalog may require manual phrase localisation
   before the system accepts the shortcut entries.

The issue does not block the intent from working via Siri voice — it only
affects the Shortcuts.app browsable list.

### 📊 Sensor Statistics — Min, Max, Average (2026-07-09)

**The ask:** show aggregate statistics (minimum, maximum, average) for every
sensor axis across three surfaces: the main `*View` screen, the `*List` history
log, and the `FullScreenChartView`.

**The shape of the solution.** The key insight was that the backing history
arrays (`motionArray`, `altitudeArray`, `locationArray`) already hold every
recorded data point. Statistics are therefore *derived values* — computed
properties — and reset for free the moment the trash button clears those arrays.
No separate reset path, no extra state.

**Three new pieces in the framework:**

```
AxisStatistics          simple value type: min, max, average
Collection<Double>.statistics    single-pass extension (one loop: min, max, sum)
MotionManager.statistics(for: GraphDetail) -> AxisStatistics?
LocationManager.statistics(for: GraphDetail) -> AxisStatistics?
```

The `statistics(for:)` method on each manager reuses the existing
`graphValue(for:)` dispatch that the chart already calls — so attitude values
arrive pre-converted to degrees, location speed is already unit-converted, and
there's no duplicated mapping logic.

**The reusable UI component.** `SensorStatisticsSection` is a SwiftUI `Section`
containing a `Grid` with four columns (axis label, Min, Max, Avg). It accepts an
`[AxisEntry]` array, which callers construct inline by calling
`manager.statistics(for: .someAxis)`. When no data has been recorded yet, the
section shows a single localized "No data recorded yet" placeholder row. The grid
is wrapped in `HStack { Spacer … Grid … Spacer }` so it centres itself within
the list row rather than hugging the leading edge.

**Three insertion points:**
- `*View` — added as a section between the sensor readouts and the Refresh Rate
  section (7 views updated).
- `*List` — lists restructured from `List(array.reversed(), id: \.self)` to
  `List { SensorStatisticsSection; ForEach(array.reversed()) }`, stats pinned at
  the top (6 lists updated).
- `FullScreenChartView` — added a `.safeAreaInset(edge: .bottom)` bar showing
  Min/Max/Avg for the *single axis* the chart is displaying. The view now
  inherits both manager environments and calls `statistics(for: selection.detail)`
  keyed by `selection.graph` to route to the right manager.

**Localization.** Five new string keys ("Statistics", "Min", "Max", "Avg",
"No data recorded yet") translated into all ten supported languages and added to
`Localizable.xcstrings` in one JSON edit.

**What surprised us.** The `graphValue(for:)` reuse was the real win — it meant
zero duplicated axis-to-property mapping. The statistics method is four lines
per manager; the heavy lifting was already done years ago when the chart layer
was designed.

---

## Engineer's Wisdom

- **Separate the engine from the showroom.** All sensor/IO logic lives in a
  framework with zero UI imports, so it's unit-testable and shared verbatim by
  the watch app.
- **Make illegal navigation unrepresentable.** Enum routes that conform to
  `View` beat stringly-typed destinations and double as the App Intents
  vocabulary.
- **One observation model, everywhere.** `@MainActor @Observable` managers +
  `@Environment` + `@Bindable` — no mixing in legacy `ObservableObject`.
- **Mock at the seams.** Managers self-populate sample data under
  `DEBUG && simulator` / `enable-testing`, so previews, the simulator, and UI
  tests all have live-looking data without hardware.
- **Localize from day one.** String Catalogs + `LocalizedStringResource` mean a
  new label is one entry away from ten languages.

## If I Were Starting Over…

- **Wrap Core Motion in an `AsyncStream`.** `LocationManager` already speaks
  fluent `async/await`; `MotionManager` is still closure-based (the redundant
  `DispatchQueue.main.async` wrapper is gone, but the underlying callback model
  remains). Unifying both behind async sequences would read better and make
  backpressure and cancellation first-class.
- **Inject services into models, don't brew them.** `LocationModel` and
  `AltitudeModel` `new` up a `CalculationManager()` *and* a `SettingsManager()`
  on every computed-property access — a fresh `UserDefaults` decode per chart
  point. Pass the formatting in, or precompute display values.
- **Kill the force-unwraps.** `ExportManager.getFile` force-unwraps the temp-URL;
  `URL.temporaryDirectory.appending(path:)` plus a `guard let`/throw would be
  honest about failure.
- **Finish the parked iPad-restoration feature.** `AppState.onSizeClassChange`
  carries a big block of intentionally-disabled logic that would preserve the
  navigation stack across iPhone↔iPad size-class changes. It's a deliberate
  TODO, not dead code — pick it up when the feature's worth shipping.

---
*Keep this file alive: every non-trivial bug, architectural fork, or "huh,
TIL" moment earns a paragraph here.*
