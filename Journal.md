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

### 🧪 The settings test that only passed on one screen size (2026-10-31)

**The symptom:** `SettingsViewUITests` tapped pickers that were sometimes still
below the fold. It scrolled with blind `swipeUp()` calls on section headers,
which assumed a particular screen height: too few swipes on a small phone, and
an overshoot past the picker on a tall iPad.

**The fix:** a small `XCUIElement.scrollTo(_:maxSwipes:)` helper that swipes
the collection view slowly and re-checks `exists && isHittable` after each
swipe. On a tall screen it doesn't swipe at all; on a small one it stops as
soon as the element can be tapped. The picker options are now tapped with
`tapWhenReady()`, so the menu's appear animation can't race the tap.

**Lesson:** scroll *until* a condition holds, not *by* a fixed amount. UI
tests that encode a screen size break on the next device you add to the plan.

### 🧩 Trading speed for a format we can read (2026-10-29)

**The question:** "Can I just append new sensors to the archive?" It turned up
a trap in the hand-written binary format: the decoder demanded the exact
format version and column counts, so adding one column later would have made
every installed V2 app reject new archives. We made it skip unknown columns
and tolerate missing optional ones, and hardened it against 32-bit overflow on
the watch.

**Then the real question:** the bytes carry no labels, so the meaning of
"the second double column" lives only in the agreement between writer and
reader. Swapping two same-typed columns would show *wrong values with no
error*, which no round-trip test catches. For code maintained by one person,
that's a lot of invisible rules.

**Measured, not guessed** (Mac, 30,000 motion samples): JSON + LZFSE takes
about 1.1 s to save and 5.8 MB, binary 0.32 s and 3.6 MB. With recordings
capped at about 15 minutes in practice, JSON's cost is noticeable but
acceptable, and it runs in the background anyway. So V2 ships JSON: the models
are `Codable` with explicit `CodingKeys`, unknown keys are ignored, and new
properties must be optional.

**Gotchas worth remembering:**

- `JSONEncoder` *throws* on NaN and ±infinity by default, so a single one would
  fail the whole save. We first assumed the sensors produce them; the docs say
  otherwise: CoreMotion and Core Location mark invalid values with negative
  numbers (`speed`/`course` `-1`, a negative `heading`). Filtering them out would
  mean inventing data or leaving gaps, so they're kept as a safety net, stored as
  `"nan"`/`"inf"`/`"-inf"`, forever.
- A negative NaN comes back positive. Harmless, but the bit-exact test had to
  learn that NaN is NaN.
- Keys are a persisted format too, so `SampleArchiveTests` decodes hard-coded
  JSON for every model. That's the golden-file test the binary format never
  had.

The binary version lives on in a git stash ("performance fix binary") in case
speed ever matters more than readability.

### 📦 22,615 rows walk into a session (2026-10-26)

**The report:** with the background save in place, the UI stayed smooth, but a
10-minute recording still took over a minute to save on an iPad.

**Measure, don't guess.** Timing logs split the save into "building" and
"writing": **64 s building, 2.5 s writing** for 22,615 motion samples. The
first two theories died quickly. CloudKit lock contention? A test running a
second context hammering the same store changed nothing. Store size? Build
time didn't depend on it. Running the same unit test *on the iPad* with a
local, CloudKit-free store reproduced it: 51 s on device, 0.6 s on the
simulator. Time Profiler then showed almost no CPU during those 51 s.

**The culprit:** splitting "building" into steps on the device. Creating the
`MotionMeasurement` objects took 25 ms per 2,000; inserting them 12 ms;
**linking them to the session took 563 ms** (45 ms on the simulator), and
10× the samples cost ~90× the time: SwiftData's relationship bookkeeping grows
roughly quadratically on device. Linking in fresh-context chunks only cut it to
16 s, with every chunk slower than the last.

**The fix: stop storing samples as rows.** Schema V2 keeps each sensor's
samples as one LZFSE-compressed `SampleArchive` on `SensorSession` (originally a
binary column format; switched to JSON on 2026-10-29, see above). Result on the iPad: **30,000
motion samples save in ~120 ms** (117 ms encoding, 2 ms writing), delete is
milliseconds, and iCloud syncs a few records plus assets instead of tens of
thousands of records (we'd been seeing "Request Rate Limited" from CloudKit).

**Design choices worth remembering:**

- *Additive, not destructive.* V2 only adds optional/defaulted attributes, so
  V1 → V2 is a lightweight migration and CloudKit's production schema (which
  can never drop record types) only gains fields. Old sessions keep their rows
  and are read through them; converting them would have deleted the data that
  older app versions on other devices still read.
- *One read path.* `session.loadMotionSamples()` etc. decode archives off the
  main thread or map legacy rows, returning the same `MotionModel` structs the
  live screens use, so the views and the CSV export reuse the models' unit
  conversion instead of the `…Measurement` mirrors.
- *Test the edges a real device produces.* Timestamps come from a
  locale-dependent format style (hello, Arabic-Indic digits), an archive must
  survive ±infinity and NaN should one ever appear (the sensor APIs mark invalid
  values with negative numbers instead), and it must reject corrupt input instead of
  trapping. `SampleArchiveTests` covers those, `DatabaseMigrationTests` opens a
  real V1 store through the migration plan.

**Verified on device (2026-10-26):** a 16,793-sample recording saved 234 ms
after Stop, and the same build shows recordings made before and after the
change side by side, each read through its own path.

**Cleaning up the old rows:** a one-time `LegacyRecordingConverter` ships
with V2 and runs at launch, but converts nothing until the account's newest
old-format recording is 90 days old. Old-format recordings can only come from
pre-V2 app versions, so a recent one means a device that hasn't updated and
would lose access to converted samples. Because recordings only shipped in
September, that gate alone pushes the first conversions to late December.
It's marked `@available(iOS, deprecated: 28.0)` so the compiler reminds us to
remove it with iOS 28, together with the legacy read fallback (marked the same
way): by then every device should be on archives, and the remaining accounts
that never converted are an accepted loss.

**Before shipping:** deploy the new CloudKit fields to production, and note
that older app versions show new sessions without their samples.

### 🐢 The save button that froze the world (2026-10-25)

**The report:** stop a long recording and the app goes dead for seconds —
no animations, no taps, nothing. Delete that session from the list and it
happens again. On a big enough session it looks exactly like a crash, and
MetricKit dutifully files it as an `MXHangDiagnostic`.

**Measure first.** Before touching anything we wrote
`RecordingPerformanceTests` — XCTest on purpose, because Swift Testing still
has no `measure {}`, no CPU/memory metrics and no baselines (the
correctness checks went into the Swift Testing `RecordingManagerTests`
instead). It saves and deletes a 5,000/500/500-sample session against a real
on-disk SQLite store. The baseline was damning: **3.56 s to save, 6.5–6.9 s
to delete**, and CPU time matched wall-clock time almost exactly. This wasn't
the disk — it was SwiftData's per-object bookkeeping, all on the main actor.

**Two surprises in those numbers.** Delete was *twice as slow* as save while
touching the same 6,000 rows: the cascade rule faults in and deletes every
measurement one by one. And 3.5 s for 6,000 inserts is absurd for SQLite —
the loop set `measurement.session = session` on every row, and each
assignment updates the inverse array one element at a time.

**The fix:** a background `RecordingStore` actor on the same container.
`RecordingManager` keeps its API but `stopRecording`/`delete` became `async`.
Saving now assigns each relationship once (`session.motionMeasurements =
[...]`) and saves once; deleting runs one `delete(model:where:)` per
measurement type, keyed on the session's `UUID` through the to-one
relationship, then deletes the session. Result: **save 0.6 s, delete
0.02 s**, and neither touches the main thread.

**The "aha!" moments:**

- *Default `@MainActor` isolation reaches into your models.* With
  `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, every `@Model` class and the
  `MotionModel`/`AltitudeModel`/`LocationModel` structs were silently
  main-actor types, so the background actor couldn't create a single
  measurement. They're now `nonisolated` (and the structs `Sendable`); only
  the unit-conversion helpers that read `SettingsManager.shared` are
  explicitly `@MainActor`. No schema change, no migration.
- *A `@ModelActor` isn't necessarily off the main thread.* The first version
  was a `@ModelActor`, created from a `@concurrent` factory, with a test
  asserting its work ran off the main thread. That test passed, and on device
  stopping a few-minute recording still froze the UI for a second. A new test
  that kept a main-actor ticker running through a 30,000-sample save showed a
  **3.35 s** gap: the entire save. A thread probe settled it: the factory ran
  in the background, but every call from main-actor code ran on the main
  thread, because the macro's `DefaultSerialModelExecutor` runs each job on
  whichever thread enqueues it. The old test passed only because its `await`
  sat inside `#expect`, whose closure isn't main-actor isolated, so the call
  happened to come from a background thread. `RecordingStore` is now a plain
  `actor` with a fresh `ModelContext` per operation, and the longest
  main-thread gap during that save is **7–20 ms**. Lesson: assert the thing
  users feel (main-thread responsiveness), not a proxy for it.
- *Synced folders aren't just a test-file trap.* The new framework file
  compiled straight into the iOS and watch app targets ("Cannot find type
  'MotionModel' in scope") until it joined `RecordingManager.swift` in their
  exclusion lists. CLAUDE.md now says so.

**UX:** after Stop, the Recordings tab shows "Saving…" and every recording
control is disabled until the save lands (`isSaving` also blocks
`startRecording`, so two sessions can't interleave). Deleted rows vanish
immediately via `isPendingDeletion(_:)` — IDs are never removed on success,
so a row can't flash back before `@Query` catches up. Failures are logged
and surfaced as a toast on iOS or a label/haptic on the watch.

**Verified on device (2026-10-26):** stopping a multi-minute recording
shows "Saving…" immediately on iPhone and Apple Watch, `@Query` picks up the
background save on its own, and both saves and the predicate deletes from
the background context sync across devices through iCloud.

### 💡 Keeping the lights on during a recording (2026-10-25)

A long recording had a quiet enemy: Auto-Lock. Once the screen went dark the
app was suspended, CoreMotion and the barometer went silent, and the session
just… ended early. The fix is a single UIKit flag,
`UIApplication.shared.isIdleTimerDisabled`, but *where* it gets flipped matters.
Setting it in `RecordingController.start()` and clearing it in `stop()` would
have meant tracking every way a session can end. Instead `ContentView` derives
`isRecording && keepScreenOnWhileRecording` and hands it to a tiny
`IdleTimerModifier`, which mirrors that value into the flag with
`onChange(of:initial:)` and resets it on disappear. Because it follows state
instead of reacting to events, any path that drops `isRecording` back to
`false` also lets the screen sleep again. It sits on the root view, so tab
switches don't touch it, and the watch never sees it.

The new "Keep Screen On While Recording" setting (default on) turned up a
latent bug. `UserSettings` used synthesized `Codable`, so adding a non-optional
field would have made every existing user's saved JSON fail to decode, and
`fetchUserSettings()` would have quietly reset *all* their settings to
defaults. (`locationAccuracySetting` had the same hidden trap.) `UserSettings`
now has a hand-written `init(from:)` that uses `decodeIfPresent` for the
newer keys. A unit test decodes an old payload to keep it that way.

To make the behaviour visible, the Recordings tab now shows a quiet "Screen
Stays On" line under the live sample counters while it applies. All the new
strings ship in all ten languages.

### 🌐 The statistics table that only spoke English (2026-10-25)

**The report:** switch the app to German, open any sensor, scroll to
Statistics — the header said "Statistiken", but every row read "Roll",
"Pitch", "Lat", "Speed"… in English.

**The culprit:** `AxisEntry.label` was a `String`. `Text("Min")` with a
literal is a `LocalizedStringKey` and gets looked up; `Text(someString)` is
treated as verbatim and never touches the String Catalog. So the header
strings were translated while the row labels, the only ones passing through
a stored property, were not. Making the property a `LocalizedStringResource`
fixed it at the type level: every `AxisEntry(label: "X", …)` call site stays
the same, but the literal now becomes a resource the compiler extracts.
`AxisEntry` became `Identifiable` via `label.key`, since `ForEach(id: \.label)`
no longer applied.

**The bonus bug:** some keys (`Roll`, `Pitch`, `Heading`) were already in the
catalog but had never been shown, and they'd been translated without context:
German "Tonhöhe" (musical pitch) and "Überschrift" (a text heading), Italian
"Pause attive", Korean "휠체어 주행" (wheelchair rolling). They now use the
attitude terms (Nicken, Kurs, Rollio, 롤…) and carry a comment so the next
translation pass knows they're about device attitude. **Lesson:** a
translation done without a key comment is a guess.

### ✏️ Names worth remembering: renaming recordings (2026-10-25)

Every session was named after its start time ("18 Oct 2026, 09:14"), because
nothing in the UI ever passed a name to `startRecording(name:)`. Five of those
in a row and the list reads like a timestamp log. Now you can rename a session
after the fact: tap the title on the detail screen (`.navigationTitle(_:)` with
a `Binding<String>` plus `.toolbarRole(.editor)` gives you the system Rename
action for free), or swipe/long-press a row in the list for an alert with a
pre-filled text field.

Both routes go through the new `RecordingManager.rename(_:to:)`, next to
`delete(_:)`, so trimming, the "empty name is rejected" rule and save-error
logging all live in one place. The detail screen's title binding reads
`session.name` and writes through `rename`, so a rejected empty name just
falls back to the stored one on the next read. No schema change: `name`
already existed, and CloudKit syncs the edit like any other.

**Gotcha #1:** custom `.swipeActions` stop SwiftUI from synthesizing the
`onDelete` swipe. Adding Rename silently removed swipe-to-delete, so Delete is
now declared explicitly next to Rename and `onDelete` is gone.

**Gotcha #2:** the default name has a colon in it, which is a terrible thing
to hand to a file system. `ExportManager.getFile` now runs every name through
`sanitizedFilename(_:)` (`/ \ : * ? " < > |` and newlines become `-`, leading
dots are dropped, empty falls back to `export`). The display name stays as
typed; only the exported file gets cleaned up.

**Gotcha #3, in the tests:** the first `RecordingManagerTests` crashed the
host with "This model instance was destroyed by calling ModelContext.reset".
The in-memory `ModelContainer` was a local in `init`. It deallocated as soon
as setup returned, took the context with it, and left the inserted session
unusable. The suite now keeps the container as a stored property. Also
remember that `Tests/` is synced into *every* target with explicit
exclusion/inclusion lists in `project.xcproj`. A new test file lands in the
app, watch and framework targets until you add it to all four lists.

### ⏺️ Record from anywhere on the wrist (2026-10-24)

Until now, recording on the watch meant backing out to Home and opening
*Record Session*. Every sensor screen already had a bottom toolbar, so the
obvious move was a third button: Record, which flips to a red
`stop.circle.fill` mid-session, exactly like the iOS radial menu.

The interesting bit wasn't the button, it was *who owns the sensors*.
`WatchRecordingView` used to keep a stable client ID and skip its own release
while recording. That works when there's one entry point, but now you can start
a recording on Acceleration, wander to Location and stop it there. That
"skip the release" trick would have turned into a guessing game about which
screen was still holding what.

**Aha:** the recording is a client too. `WatchRecordingController` (the watch
twin of iOS's `RecordingController`) claims motion, altitude *and* location
under one stable `"WatchRecording"` ID on `start()` and releases it on
`stop()`. Screens go back to the boring rule: claim on appear, release on
disappear, always. The client-set bookkeeping in the managers keeps the
sensors alive for as long as *anyone* needs them. Since the recording's claim
covers everything, `WatchRecordingView` lost its `onAppear`/`onDisappear`
completely and is now a plain UI over the controller.

A small SwiftLint side quest: adding the record branch pushed
`SensorControls.perform(_:)` to cyclomatic complexity 11. Splitting the
`(action, sensor)` tuple switch into `startUpdates()` / `pauseUpdates()` /
`deleteValues()` reads better anyway.

### 🧽 Same rules, one place: the post-recording cleanup (2026-10-24)

**The ask:** a readability pass over the watch-controls and recording work
from the day before.

**The bug the refactor found.** iOS had two ways to start a recording, and
they had quietly drifted apart. `RecordingControlSection` stopped and reset
the sensors first; `CustomControlsView`'s Record button didn't, so a session
started from a sensor screen also saved every sample collected *before* the
tap, stamped with a `startedAt` that came after them. Both now call one
`RecordingController` (`start()` / `stop()`), and the behavior follows the
correct one: fresh buffers, then record. Hoisting duplicated code first and
only then comparing the copies is how this showed up. Side by side in two
files, the missing reset was easy to miss.

**Seven watch screens, one modifier.** Every watch sensor view had the same
static client string, the same `onAppear` / `onDisappear` pair and the same
toolbar line. `.sensorScreen(.motion)` (`SensorScreenModifier`) now does all
three. The client ID became a per-instance `UUID` in the modifier's `@State`,
which is unique by construction, so nobody has to hand-type an ID that might
collide. `WatchRecordingView` keeps its hand-written lifecycle on purpose: it
*needs* a stable ID so its claim survives leaving mid-recording.

**API that says what it does.** `MotionManager.releaseUpdates(for:)` was
named differently from `LocationManager.releaseLocationUpdates(for:)` and
released motion *and* altitude together. It's now
`releaseMotionUpdates(for:)` / `releaseAltitudeUpdates(for:)`, backed by new
single-sensor `stopDeviceMotionUpdates()` / `stopAltitudeUpdates()` /
`resetDeviceMotionUpdates()` / `resetAltitudeUpdates()`. As a result, the
watch Altitude screen's Pause and Delete no longer touch device motion. The
public `updatesStarted` flag is gone: nothing outside the managers read it
anymore. `MotionManager` only ever wrote it, and `LocationManager`'s loop now
relies on task cancellation, which it already did.

**Shared button vocabulary.** iOS `CustomControlsView.ButtonType` and watch
`SensorControls.ButtonType` were copies of each other. They are now the
framework's `SensorControlAction`, which holds the cases, symbols and
localized keys. The localized keys still resolve, because the shared
`Localizable.xcstrings` is a member of the framework target too. Each app
keeps only what's genuinely per-target: accessibility identifiers (each
target has its own `UIIdentifiers`) and, on iOS, the radial-menu offsets.

**Lesson:** a duplicated code path is a bug that just hasn't happened yet. In
this case it already had.

### ⌚ Watch controls — and the screen that stopped its successor (2026-10-23)

**The report:** on Apple Watch, values would sometimes just… freeze, and the
only cure was backing out and re-entering the screen. There were no controls,
because each watch `*View` drove the sensors purely from `onAppear` /
`onDisappear`.

**The war story:** every watch screen shares one `MotionManager`, and during
navigation SwiftUI is free to fire the *outgoing* screen's `onDisappear`
**after** the incoming screen's `onAppear`. So Gyroscope would start device
motion, and a beat later Acceleration's `onDisappear` would stop and reset it.
Two more gremlins were hiding in plain sight: `GravityView.onDisappear` called
`startMotionUpdates()` (a copy-paste slip that never stopped anything), and
`WatchRecordingView.onDisappear` stopped *and reset* all sensors even
mid-recording, so wandering off during a session left you with an empty or
truncated save.

**The fix:** the managers now track *who* wants each sensor.
`startMotionUpdates(for:)` / `startAltitudeUpdates(for:)` /
`startLocationUpdates(for:)` add a client ID (a stable per-screen string) to a
`Set`, and `releaseUpdates(for:)` / `releaseLocationUpdates(for:)` remove it,
stopping a sensor only when its set is empty and resetting data only when
nothing is left running. A `Set` rather than a counter makes a doubled
`onAppear` harmless. The recording screen just skips its release while
`isRecording`, and since its ID is stable across visits, the claim gets
dropped cleanly the next time you leave with no recording active.

**The "aha!":** the old `updatesStarted` flag was flipped to `true` *before*
the authorization/availability guards, so it said nothing about whether data
was flowing. The new `isMotionRunning` / `isAltitudeRunning` / `isRunning`
flags are only set once a stream really starts, which keeps the new
`SensorControls` toolbar (Start/Pause toggle + Delete, with `.click` haptics)
honest. Pause and Delete are disabled mid-recording on both platforms (on iOS
Start too): a session should be one unbroken capture, so the only way to stop
it is Stop Recording. A small UI gotcha surfaced on iOS: `.disabled(true)` did
block the taps, but the buttons still *looked* live, because the hard-coded
`.foregroundStyle(Color.primary/.red)` overrides SwiftUI's automatic dimming
and `.interactive()` glass still bounces on touch. The fix is a `.secondary`
foreground plus `.interactive(!isDisabled)`. iOS also got the navigation half of this rule: switching tabs or
leaving the Location screen no longer stops the sensors while a recording runs.
Closing the loop, the iOS Recordings tab got a `RecordingControlSection`:
Start Recording when idle, and while recording, the same live sample counters as
the watch plus Stop Recording. With Pause and Delete locked during a session,
there needed to be an obvious place to start and end it besides the floating
record control. The subtle part was that no sensor runs on the Recordings tab
(switching tabs stops them), so a naive `startRecording()` there would save an
empty session. The button has to reset the buffers and start every sensor
itself, the way `WatchRecordingView` does. Two cleanups fell out along the way:
`sensorUpdateInterval`'s `didSet` now only restarts streams that are already
running (before, it quietly resumed paused sensors and started the altimeter
on every motion screen), and `LocationManager` now cancels its previous
`liveUpdates()` loop, because a quick stop → start used to leave two loops
appending the same fixes.

### 🗳️ Kickstart Signal — letting users vote on what's next (2026-10-23)

**The ask:** give users a way to suggest features and upvote each other's ideas,
without building a backend or a feedback form from scratch.

**Same SDK, second product.** `KickstartSDK` bumped from 0.5.0 to 0.6.0, and
the app target now links a second product, `KickstartSignal`, next to
`KickstartExchange`. Just like the ad banner (see 2026-08-19), the integration
surface is a single SwiftUI view: `SignalBoardView(apiKey:)`. `SignalBoardScreen`
wraps it in a `NavigationStack` with a Close toolbar button, and
`SettingsScreen` presents it as a sheet from a new **Feedback → Feature
Requests** section.

**No new secret.** The board uses the exact same key resolution as
`AdBannerView`: `"preview"` in DEBUG, `KICKSTART_EXCHANGE_API_KEY` from
Info.plist (populated from the gitignored `Secret.xcconfig`) in release. One
Kickstart account, one key, two products.

**Shipping it.** Marketing version is now 7.2.0 (build `20261023.1`), with a
release-notes entry ("Added a feature request and voting board") and new
strings in `Localizable.xcstrings` / `ReleaseNotes.xcstrings`.

**Lesson:** when a vendor ships features as plain `View`s, adding the second
one costs about as much as adding the first: a package product, a screen, and
a button.

### 📱 Getting ready for the iPhone Duo (2026-10-10)

**The ask:** make the app behave on the foldable iPhone Duo.

**The trap was an idiom check doing a size class's job.** `ContentView.isCompact`
was `horizontalSizeClass == .compact || idiom == .phone`, and `AppState` skipped
`onSizeClassChange` entirely on iPhones. That was fine while no phone ever
changed shape. A Duo is still `.phone`, so it would have been pinned to the
narrow layout when unfolded and its state never translated.

**Fix #1 went too far.** Dropping the idiom check and keying off size class
alone looked like the textbook answer, and it worked: until we looked at what
"regular" means on a phone. A Plus/Max in landscape is regular-wide but short,
and the flat sidebar layout has about nine tabs. On the Max it was merely
cramped. Adding a vertical-size-class check fixed that.

**The aha moment came from the Duo itself.** Unfolded, it reports regular width
*and* regular height, so every size-class rule said "flat layout", and the
adaptable `TabView` rendered those nine tabs as a bottom tab bar with a More
overflow menu (the sidebar presentation only happens on iPad). No size class can
tell a Duo from an iPad. The honest rule is a product decision: sidebar on iPad
only, phones always grouped. That put the idiom check back, deliberately this
time, in a small pure function (`NavigationLayout.usesCompactLayout`) with unit
tests, and the answer is published as a `usesCompactLayout` environment value so
`LocationScreen`'s ad banner can't drift out of sync with it (it was showing a
second banner on the Duo).

**Side effects worth knowing.** `AppState.isIphone` and its test-only init
parameter are gone, since phones never change layout `onSizeClassChange` has
nothing to do there, and the nine `AppStateTests` no longer need the override.
The layout switch and the state translation now share one decision
(`isCompact`), fed to `AppState` as a derived `.compact`/`.regular`.

**Lesson:** size classes describe space, not device capability or product
intent. When the real rule is "iPad only", say so in one tested place instead of
approximating it with size classes.

### 🧩 Finishing the parked iPad-restoration feature (2026-09-15)

**The ask:** resizing the app on iPad (Split View, Stage Manager) was dumping
users back to the Position tab's root, no matter what they'd been looking at.
`AppState.onSizeClassChange` had the fix already half-written — a full
compact↔regular mapping sitting commented out, with a "pick this up when it's
worth shipping" TODO in *If I Were Starting Over*.

**Uncommenting it wasn't enough.** Two bugs would have shipped if the block
had just been flipped back on: no fallback for when the user was sitting on
the bare `.position`/`.motion` hub screen (regular layout has no tab for
that, so `selectedTab` would've ended up pointing at nothing), and missing
`else` branches that left a single-level drill (`positionStack == [.location]`)
untouched instead of clearing it — which double-pushes `LocationScreen` under
regular layout, where `.location` is now the tab's own root. There was also a
second, unrelated bug hiding behind it: `ContentView.onChangeOfSelectedTab()`
fires on *any* `selectedTab` mutation and unconditionally stops sensors and
wipes every stack, so the restoration would've undone itself the instant it
ran. Fixed with a one-shot `suppressNextSelectedTabChange` flag on `AppState`
— set right before the tab reassignment, consumed (and cleared) by
`ContentView`, so a genuine user-initiated tab switch still gets the full
stop/reset treatment.

**The simplification that mattered more than the fix.** The first working
version was a straight port of the parked logic: a wall of
`if stack.contains(.location) { … } else if stack.contains(.altitude) { … }`
repeated for every sensor, in both directions. It worked, but it was exactly
the kind of code that grows a new `else if` every time someone adds a screen.
The insight that collapsed it: compact-mode stacks are always ordered
`[root, leaf?, …]` by construction — you can only push a detail screen onto
one that's already showing — so `stack.first` *is* the tab to switch to, and
`stack.dropFirst()` *is* the regular-mode stack, at any depth. Going the other
way, prepending the tab's own root case back onto the stack does the same job
in reverse. That turned into two small, reusable properties instead of a
combinatorial matrix: `PositionStack`/`MotionStack.rootTab` (which tab a stack
entry belongs to, however deep) and `RootTab.compactParent` /
`positionStackRoot` / `motionStackRoot` (the reverse lookup).
`onSizeClassChange` dropped from ~100 lines to ~25 — and, as a bonus, it now
handles a hypothetical 3rd-level drill (Map → pin detail, say) with zero
changes to the transition logic, just one new line in `rootTab`'s switch.

### 🖼️ The full-screen chart that kept closing itself (2026-09-15)

**The report:** open a chart full screen (say, Acceleration → X-Axis), resize
the iPad window, and the cover slams shut. Same day as the restoration fix
above, same underlying cause, different symptom.

**Why the tab fix didn't cover this one too.** `onSizeClassChange` correctly
preserves `selectedTab` and the stacks now — but `selectedChart`, the state
driving the full-screen cover, lived as local `@State` on each `*View`
(`AccelerationView`, `LocationView`, and five more), with `.fullScreenCover`
attached right there. The problem isn't navigation *state*, it's view
*identity*: `ContentView`'s `if isCompact { Tab(.motion) { MotionScreen() } }
else { TabSection { Tab(.acceleration) { AccelerationScreen() } } }` is two
structurally different branches. SwiftUI has no way to carry `@State` across
an `if/else` swap like that — it tears down whichever branch stops being
active and builds the other from scratch, no matter how well `AppState`
remembers what *should* be showing. Any cover or sheet presented from state
inside the torn-down branch dies with it.

**The fix:** move `selectedChart` onto `AppState` and the `.fullScreenCover`
modifier onto `ContentView` itself — the one thing in this tree that *isn't*
torn down when the compact/regular branch swaps, since it's the view holding
the `if/else`, not a subject of it. `ExpandableChartView` now reads
`@Environment(AppState.self)` and sets `appState.selectedChart` directly
instead of threading a `@Binding` down from each screen, which also deleted
seven copies of the same `@State` + `.fullScreenCover` pair. General lesson
for this codebase: state that must outlive a compact/regular branch swap
belongs on `AppState`, not locally — the same rule `selectedChart` now
follows alongside `selectedTab` and the nav stacks.

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

**What's still open:** the full DI refactor (see *If I Were Starting Over*)
and the narrowed Shortcuts-visibility investigation.

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
- ~~**Finish the parked iPad-restoration feature.**~~ Done 2026-09-15 — see
  the Journey entry above. Turned into a depth-agnostic `first`/`dropFirst()`
  translation instead of the originally-parked combinatorial mapping.

---
*Keep this file alive: every non-trivial bug, architectural fork, or "huh,
TIL" moment earns a paragraph here.*
