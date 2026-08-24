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
    MotionManager            CMMotionManager + CMAltimeter  (AsyncStream-bridged)
    LocationManager          CLLocationManager              (async/await)
    SettingsManager          UserDefaults <-> UserSettings JSON, app icons
    CalculationManager       unit conversions (Measurement)
    ExportManager            writes CSV to temp dir, returns URL
    AppUpdates               version check → release-notes sheet
  Model/                     value types: MotionModel, LocationModel,
                             AltitudeModel, AxisStatistics, UserSettings,
                             MapKitSettings, …
  Recording/                 RecordingManager (SwiftData write path)
  SwiftData/                 schema (ModelsSchemaV1), versioning, container,
                             CloudKit init helper, type aliases
  Extension/                 Logger categories, Double/Date helpers
  Localization/              SupportedLanguage enum, preview modifier

Sensor-App/                  ← the iOS showroom
  Layout/                    SensorAppApp (entry), ContentView (TabView),
                             Navigation/ (AppState, RootTab, *Stack enums,
                               RecordingsStack)
  Views/                     per sensor: *Screen / *View / *List
                             + CardView, LineGraph (incl. FullScreenChartView,
                               ExpandableChartView), Notification, Settings,
                               CustomControls (Liquid Glass), ReleaseNotes,
                               Recordings, Statistics/SensorStatisticsSection
  AppIntents/                NavigateIntent, NavigationOption, Shortcuts
  Resources/                 *.xcstrings, Assets.xcassets, *.icon

Sensor-App-WatchApp/         ← the watch storefront (one *View per sensor,
                             WatchRecordingView)
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

### 🧹 Pre-ship housekeeping — force-unwraps, singletons, and MotionManager catches up (2026-08-24)

**The ask:** before cutting the 7.0.0 update, a pass through the known-tech-debt
list with one rule: no user-facing behavior changes, code quality only.

**What got fixed, cheaply:**
- `ExportManager.getFile`'s two force-unwraps disappeared for free by switching
  from `NSURL(...).appendingPathComponent(_:)` (optional-returning) to
  `URL.temporaryDirectory.appending(path:)` (non-optional). No signature
  change, no swiftlint-disable pragma needed anymore.
- The two `Bundle.main.bundleIdentifier!` sites (`Extension+Logger.swift`,
  `SettingsManager.clearUserDefaults()`) got a nil-coalesce and a `guard let`
  respectively — the `guard` specifically, since `removePersistentDomain(forName:)`
  targeting a made-up fallback string would be worse than just skipping the clear.
- `ModelsSchemaV1.versionIdentifier` dropped its `nonisolated(unsafe) static var`
  for a plain `static let` — it was never mutated, so `VersionedSchema`'s
  `{ get }` requirement was happy with an immutable value all along.
- `MotionMeasurementV1`'s attitude fields finally say what they are: radians,
  not degrees. The doc-comment bug flagged in the units-conversion entry below
  (2026-07-16) is closed — the fields were always radians, only the comment lied.

**The `.shared` singleton mitigation.** `LocationModel` / `AltitudeModel` /
`Extension+LocationMeasurement.swift` / `Extension+AltitudeMeasurement.swift`
no longer `CalculationManager()` / `SettingsManager()` a fresh instance on
every chart point — `CalculationManager.shared` / `SettingsManager.shared` now
cover all ~20 call sites. This is deliberately *not* the full DI fix from
*If I Were Starting Over* below: these are value types with no environment
access, so real DI would mean turning every `calculatedX` var into a method
and threading managers through every `*View`/`*List` call site. Since both
classes are effectively stateless for this purpose (`fetchUserSettings()`
always re-reads `UserDefaults` live, regardless of instance), the singleton
buys back the actual cost — repeated allocation — without the blast radius.
Full DI stays on the wishlist. One loose end this surfaced: `SensorAppApp` was
also injecting a `CalculationManager` into the SwiftUI environment via
`@State`/`.environment(...)`, but nothing ever read it back via
`@Environment(CalculationManager.self)` — confirmed by grep, zero matches.
Removed that dead injection (and its mirror in `NavEmbedded.swift`'s preview
trait); `.shared` is genuinely the only path to `CalculationManager` now.

**MotionManager grew an AsyncStream.** Wrapped both `CMMotionManager`/
`CMAltimeter` closure callbacks in `AsyncStream<MotionModel>` /
`AsyncStream<AltitudeModel>`, consumed by a `Task { for await model in stream
{ ... } }` — the same shape `LocationManager` already had. Model construction
stays inside the CoreMotion closure unchanged; only the resulting model gets
yielded instead of directly mutating state. The subtlety that made this
non-trivial: `sensorUpdateInterval`'s `didSet` calls `start...Updates()` again
while updates may already be running, and CMMotionManager just replaces the
handler in place — so the *old* stream's continuation has to be explicitly
`finish()`ed before starting a new one, or its consuming `Task` would leak
forever, suspended on a stream that will never yield or finish again. That
leak risk didn't exist in the old closure-only version — CMMotionManager just
dropped the old closure reference, no consequences. Worth remembering next
time someone asks "didn't this used to be simpler?" — yes, it did. This
refactor traded a bit of added lifecycle bookkeeping for structural parity
with `LocationManager`, not for a concurrency-safety fix: both producer and
consumer already ran on MainActor before and after (CoreMotion delivers
`to: .main`), so no race was fixed here.

**Known-issue update.** The Shortcuts-visibility investigation (see 2026-06-28
below) loses one candidate: `updateAppShortcutParameters()` turned out to
already be wired up (`AppState.updateShortcutParameter()`, called from
`SensorAppApp`'s `.onAppear`) — CLAUDE.md's known-issues note was stale on
this point and has been corrected.

**What's still open:** the full DI refactor (see *If I Were Starting Over*),
the parked iPad-restoration feature in `AppState.onSizeClassChange`, and the
narrowed Shortcuts-visibility investigation.

---

### 📢 Kickstart Exchange — a banner ad that's just a `View` (2026-08-19)

**The ask:** add a monetization surface without dragging a heavyweight SDK
lifecycle into the app.

**The shape of the solution.** `AdBannerView` is nothing more than a SwiftUI
wrapper around `ExchangeBannerAdView` from the new `KickstartSDK` package
(product `KickstartExchange`). No delegate, no `AppDelegate` hook, no
singleton `.configure()` call at launch — the SDK is parameterized entirely
by the `apiKey` passed into the view's initializer. That's the whole
integration surface:

```swift
struct AdBannerView: View {
    var body: some View {
        ExchangeBannerAdView(apiKey: apiKey).padding()
    }
    private var apiKey: String {
        #if DEBUG
            "preview"
        #else
            Bundle.main.object(forInfoDictionaryKey: "KICKSTART_EXCHANGE_API_KEY") as? String ?? "preview"
        #endif
    }
}
```

**Debug/release split.** DEBUG builds hardcode the SDK's `"preview"` key so
Previews and Simulator runs never hit a real ad network. Release builds pull
`KICKSTART_EXCHANGE_API_KEY` out of Info.plist, which is itself populated by
`$(KICKSTART_EXCHANGE_API_KEY)` from the gitignored `Secret.xcconfig` — the
same pattern already used for `APP_GROUP_ID` and `CLOUDKIT_CONTAINER_ID`. No
new secret-handling machinery needed.

**Placement.** The banner drops into `PositionScreen` and `LocationScreen`
via the same `.safeAreaInset(edge: .bottom)` slot used elsewhere for floating
controls. On `LocationScreen` it's gated to `horizontalSizeClass != .compact`
— a full-width ad banner competing with the map and the floating controls on
an iPhone-sized screen was more clutter than value, so it only shows on
iPad's roomier layout.

**What surprised us.** How little there was to it. Because the SDK exposes
itself as a plain `View`, "integrating an ad network" and "adding any other
subview" were the same amount of work.

---

### 📈 MetricKit — on-device diagnostics (2026-07-17)

**The ask:** see crashes, hangs, and performance regressions from real user
devices without shipping a third-party crash reporter.

**The pattern.** `MetricKitManager` is `#if os(iOS)`-gated and wraps
`MXMetricManager` with two independent `Task { for await report in ... }`
loops — one over `manager.metricReports` (Apple's once-daily aggregated
performance digest), one over `manager.diagnosticReports` (near-real-time
crash/hang/exception events). Async sequences instead of the traditional
`MXMetricManagerSubscriber` delegate meant the manager could stay a plain
`@Observable` class with no delegate-protocol boilerplate — just two `for
await` loops kicked off from `init()`.

**What it surfaces.** `latestReport` is a `MetricReportSummary`: CPU time,
GPU time, peak memory, average suspended-memory, and a weighted average of
hang/launch time computed by walking the returned `Histogram` buckets by hand
(MetricKit gives you distributions, not scalars — the midpoint-times-count
weighted sum was the least lossy way to boil that down to a single number for
the UI). `diagnostics` is a capped ring buffer (50 entries, newest first) of
crash / hang / CPU exception / disk-write exception / app-launch / memory
exception events, each with a short human-readable detail string built per
diagnostic type.

**DEBUG breadcrumb.** In DEBUG builds, every raw report is also JSON-encoded
and written to the documents directory (`metric-report-<timestamp>.json`,
`diagnostic-<type>-<timestamp>.json`) — a zero-effort way to inspect the full
payload MetricKit actually sent, without needing a device that's crashed in
the wild.

**Wiring.** Injected exactly like every other manager: `@State` in
`SensorAppApp`, `.environment(metricKitManager)`. `DiagnosticsScreen` (linked
from `SettingsScreen`) reads it via `@Environment` and renders a Performance
section and a Diagnostics section, each falling back to a
`ContentUnavailableView` when empty — no special-casing needed for the
"nothing collected yet" state, SwiftUI's built-in empty-state view handles it.

---

### 📐 Default-unit storage & configurable units (2026-07-16)

**The ask (two PRs, one architecture):** store every sensor value internally
in one canonical unit, and let users pick their preferred *display* unit
independently — including, now, the unit for GPS horizontal/vertical
accuracy, not just speed/pressure/height.

**The existing shape held up.** `CalculationManager` already converted
`Measurement` values between units (`calculateSpeed`/`calculatePressure`/
`calculateHeight`, unchanged since 2019); `LocationModel`/`AltitudeModel`
already exposed `calculatedX`/`xUnit` computed properties that called into it
using the symbol strings stored in `UserSettings`. No new unit enum was
needed — Foundation's `Measurement`/`UnitSpeed`/`UnitPressure`/`UnitLength`
plus a plain `String` symbol in settings was already expressive enough.
`740ec63` just extended the vocabulary: a new `locationAccuracySetting:
String` field (default `UnitLength.meters.symbol`) and matching
`calculatedHorizontalAccuracy`/`horizontalAccuracyUnit`/
`calculatedVerticalAccuracy` properties on `LocationModel`.

**The real addition: converting persisted data too.** Until this point, unit
conversion only applied to the *live* in-memory models — a `SensorSession`
pulled up in `RecordingsScreen` days later would show raw stored values with
no unit conversion. `801a184` closed that gap with two new files —
`Extension+LocationMeasurement.swift` and `Extension+AltitudeMeasurement.swift`
— that mirror the exact same `calculatedX`/`xUnit` computed-property pattern
onto the *persisted* SwiftData models. The underlying `@Model` types still
store raw SI values (so old recordings remain valid even if a user changes
their unit preference tomorrow); the conversion happens at read time, same
as the live models. A third file, `Extension+MotionMeasurement.swift`, adds
`attitudeRollDegrees`/`attitudePitchDegrees`/`attitudeYawDegrees` for the same
reason — but there we found the stored `attitudeRoll`/`Pitch`/`Yaw` fields are
actually radians despite their doc-comment claiming degrees, copied verbatim
from `MotionModel` with no conversion at write time. Worth a follow-up: either
fix the comment or convert at write time and drop the extra properties.
*(Update 2026-08-24: fixed the comment — see the pre-ship housekeeping entry
above.)*

**What didn't get fixed at the time.** The two settings-driven extension files
called `CalculationManager()` and `SettingsManager()` fresh, per property
access — exactly the tech debt already flagged for `LocationModel`/
`AltitudeModel`. Copying the pattern was the fast way to ship consistent
behavior across live and persisted data, but it meant the "inject services
instead of brewing them" fix now had four call sites instead of two.
*(Update 2026-08-24: all four now go through `.shared` singletons — see the
pre-ship housekeeping entry above. Full DI is still open, see *If I Were
Starting Over*.)*

---

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

### 🔍 Full Screen Charts — Portrait & Landscape (2026-07-06)

**The ask:** let users expand any sensor chart to fill the screen, useful in
both portrait and landscape orientations where the inline chart is too narrow
to read fine-grained fluctuations.

**The pattern.** Rather than threading sheet state into every `*View`, the
solution uses a single nullable `@State<ChartSelection?>` at the screen level.
`ExpandableChartView` wraps an existing `LineGraphSubView` with a transparent
expand-button overlay (a filled circle SF Symbol in `.topTrailing`); tapping
sets that binding. The parent presents `FullScreenChartView` as a `.sheet`.

`ChartSelection` is a three-property struct (`graph`, `detail`, `title`) — just
enough information to reconstruct the chart in the sheet without passing the
entire manager down. It's `Sendable` and trivially constructable.

`FullScreenChartView` is a `NavigationStack` with a `LineGraphSubView` sized to
`maxWidth: .infinity, maxHeight: .infinity`. The statistics bar (introduced in
#130) reuses `resolvedStats` — a computed property that routes to the right
manager based on `selection.graph` — so Min/Max/Avg appear for free in the full
screen view with no extra wiring.

**Landscape bonus.** Because the view fills the available frame rather than a
fixed height, rotating the device to landscape gives a wider time window with
more visible detail. No extra orientation handling required — SwiftUI layout
does it for free.

---

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
1. ~~A missing `AppShortcutsProvider.updateAppShortcutParameters()` call at app
   launch.~~ Ruled out (2026-08-24): `AppState.updateShortcutParameter()` already
   calls it, wired from `SensorAppApp`'s `.onAppear`.
2. iOS 27 beta timing / caching quirk — the Shortcuts daemon may need a device
   reboot or re-install cycle to index a new provider.
3. The `AppShortcuts.xcstrings` catalog may require manual phrase localisation
   before the system accepts the shortcut entries.

The issue does not block the intent from working via Siri voice — it only
affects the Shortcuts.app browsable list.

### 🗄️ SwiftData Recording Layer — Persistent Sessions (2026-07-12)

**The ask:** persist sensor recordings so users can review, browse, and
eventually export past sessions — even across app restarts and on multiple
devices.

**The architecture.** Live sensor data already lives in the managers' in-memory
arrays (`motionArray`, `altitudeArray`, `locationArray`). Rather than writing to
the database on every sensor tick (which would thrash the store at up to 100 Hz),
the decision was to persist *at the end of a session only*. `RecordingManager.stopRecording()`
converts each in-memory value type to a SwiftData `@Model` instance and inserts
everything into a single `ModelContext`, then calls `context.save()` once. One
write, one transaction, zero mid-session I/O.

**Schema design.** Four models inside `ModelsSchemaV1`:

```
SensorSession              ← the root aggregate (name, start/end timestamps, source device)
├── MotionMeasurement      ← all motion axes in one row (avoids four separate tables)
├── AltitudeMeasurement    ← pressure + relative altitude
└── LocationMeasurement    ← GPS fix + accuracy
```

Relationships are `@Relationship(deleteRule: .cascade)` — deleting a session
nukes all its measurements automatically. Every property has a default value
and every relationship is Optional, both required by CloudKit. (The `@Attribute(.unique)` 
annotation is explicitly off-limits for the same reason.)

**CloudKit sync.** `SwiftDataContainer` opens the store with
`.private(containerID)` (pulled from `Info.plist` at runtime, injected by
`.xcconfig`). A DEBUG-only `InitializeCloudKitSchema` helper pushes the schema
to CloudKit once; set its flag back to `false` after the first run.

**Navigation.** A new `RecordingsStack` enum drives the recordings flow:
`RecordingsScreen` (session list, `@Query` sorted by `startedAt`) →
`RecordingDetailScreen` → per-measurement-type detail views. The recordings tab
is a fourth top-level destination alongside Position, Motion, and Magnetometer.

**What stayed simple.** Because the live arrays already existed, the conversion
in `stopRecording` is mechanical: one `for` loop per measurement type, one
`context.insert` per item. No custom mapping logic. `RecordingManager` itself is
under 90 lines.

---

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

- ~~**Wrap Core Motion in an `AsyncStream`.**~~ Done 2026-08-24 — see the
  pre-ship housekeeping entry above. Worth the honesty check though: it's
  structural parity with `LocationManager`, not a concurrency-safety fix,
  since both producer and consumer already ran on MainActor either way.
- **Full DI for `LocationModel`/`AltitudeModel`, not just the singleton
  mitigation.** As of 2026-08-24 these (and `Extension+LocationMeasurement.swift`
  / `Extension+AltitudeMeasurement.swift`) go through `CalculationManager.shared`
  / `SettingsManager.shared` instead of `new`-ing a fresh instance per access —
  that killed the repeated-allocation cost. What's still missing is *real* DI:
  these are value types with no `@Environment` access, so doing this properly
  means turning every `calculatedX` var into a method and threading the already
  environment-injected managers through every `*View`/`*List` call site. Only
  worth doing if these classes ever grow real state that must stay in sync
  with the interactively-edited environment instance — today they're
  effectively stateless (`fetchUserSettings()` always re-reads `UserDefaults`
  live), so the singleton carries no known correctness risk.
- ~~**Kill the force-unwraps.**~~ Done 2026-08-24 — `ExportManager.getFile` now
  uses `URL.temporaryDirectory.appending(path:)` (non-optional, no unwrap
  needed), and the two `Bundle.main.bundleIdentifier!` sites got a
  nil-coalesce / `guard let`.
- **Finish the parked iPad-restoration feature.** `AppState.onSizeClassChange`
  carries a big block of intentionally-disabled logic that would preserve the
  navigation stack across iPhone↔iPad size-class changes. It's a deliberate
  TODO, not dead code — pick it up when the feature's worth shipping.

---
*Keep this file alive: every non-trivial bug, architectural fork, or "huh,
TIL" moment earns a paragraph here.*
