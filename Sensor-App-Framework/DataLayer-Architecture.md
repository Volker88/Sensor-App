# Data Layer Architecture — Sensor-App-Framework

This document describes every type that stores, transforms, or publishes sensor
data in the shared framework. The framework has no UI dependencies; it is
imported by both the iOS app and the watchOS app.

---

## Overview

```
Hardware sensors
      │
      ▼
MotionManager / LocationManager      ← @MainActor @Observable classes
      │  publishes model snapshots
      ▼
MotionModel / LocationModel / AltitudeModel  ← immutable value types
      │  graphValue(for: GraphDetail)
      ▼
LineGraphSubView  (Charts)           ← consumes *Chart arrays
```

Settings flow:

```
SettingsManager  ←→  UserDefaults (JSON)
      │  fetchUserSettings() → UserSettings
      ▼
MotionManager / LocationManager  (cap chart arrays at graphMaxPoints)
CalculationManager               (unit conversion)
```

---

## Data Models

### `MotionModel`  —  `struct, Hashable`
**File:** `Model/MotionModel.swift`

One snapshot produced by `CMDeviceMotion`. Immutable; all axes are stored in
SI units as delivered by CoreMotion (acceleration in g, gyro in rad/s,
magnetometer in µT, attitude in radians).

| Group | Properties |
|---|---|
| Identity | `counter: Int`, `timestamp: String` |
| Acceleration | `accelerationXAxis/Y/Z: Double` |
| Gravity | `gravityXAxis/Y/Z: Double` |
| Gyroscope | `gyroXAxis/Y/Z: Double` |
| Magnetometer | `magnetometerCalibration: Int`, `magnetometerXAxis/Y/Z: Double` |
| Attitude | `attitudeRoll/Pitch/Yaw: Double` (rad), `attitudeHeading: Double` |

`graphValue(for: GraphDetail) -> Double` is the single dispatch point that
maps a `GraphDetail` case to the corresponding stored property, converting
attitude angles from radians to degrees on the way out.

---

### `LocationModel`  —  `@MainActor struct, Hashable`
**File:** `Model/LocationModel.swift`

One snapshot from `CLLocation`. Raw values are stored as delivered by
CoreLocation; unit conversion is done on demand through computed properties.

| Property | Units |
|---|---|
| `longitude, latitude` | Degrees |
| `altitude` | Metres |
| `speed` | m/s (raw) |
| `course` | Degrees relative to true north |
| `horizontalAccuracy, verticalAccuracy` | Metres |
| `GPSAccuracy` | `CLLocationAccuracy` constant |

Computed properties `calculatedSpeed / speedUnit`,
`calculatedAltitude / heightUnit`, and
`calculatedHorizontalAccuracy / horizontalAccuracyUnit / calculatedVerticalAccuracy`
delegate to `CalculationManager` and `SettingsManager` for the active unit
preference (accuracy conversion uses `UserSettings.locationAccuracySetting`).

> **Known tech debt:** each computed property instantiates a fresh
> `CalculationManager()` and `SettingsManager()` on every access. Both should
> be injected once rather than allocated per call. The same pattern was later
> copied onto the persisted SwiftData models — see
> `Extension+LocationMeasurement.swift` etc. under Observable Managers/Tech
> Debt Summary below.

---

### `AltitudeModel`  —  `@MainActor struct, Hashable`
**File:** `Model/AltitudeModel.swift`

One snapshot from `CMAltimeter`.

| Property | Units |
|---|---|
| `pressureValue` | kPa |
| `relativeAltitudeValue` | Metres (delta from start) |

Same computed-property pattern as `LocationModel`:
`calculatedPressure / pressureUnit` and `calculatedAltitude / altitudeUnit`.
Same tech debt applies.

---

### `UserSettings`  —  `Codable struct`
**File:** `Model/UserSettings.swift`

All user-configurable preferences. Persisted as JSON in `UserDefaults` via
`SettingsManager`. Every sensor manager reads this at update time.

| Property | Purpose |
|---|---|
| `showReleaseNotes` | Show release notes sheet on first launch after update |
| `GPSSpeedSetting` | Speed unit: km/h, mph, m/s, knots |
| `GPSAccuracySetting` | Desired `CLLocationAccuracy` preset |
| `frequencySetting` | Sensor update interval in Hz |
| `pressureSetting` | Pressure unit: hPa, bar, inHg |
| `altitudeHeightSetting` | Height unit: m, ft |
| `locationAccuracySetting` | Unit for GPS horizontal/vertical accuracy (default: meters) |
| `graphMaxPoints` | Rolling chart window size (capped per manager) |

`graphMaxPointsInt()` is a convenience accessor that casts the `Double` to
`Int` for array bounds checks.

---

### `MapKitSettings`  —  `Codable struct`  +  `MapType` enum
**File:** `Model/MapKitSettings.swift`

Map display preferences stored independently from `UserSettings`.

`MapType: String, Codable, CaseIterable` covers `.standard`, `.satellite`,
`.hybrid`, `.satelliteFlyover`, `.hybridFlyover`, `.mutedStandard`.

---

### `AxisStatistics`  —  `struct`
**File:** `Model/AxisStatistics.swift`

Aggregate statistics for one sensor axis computed from its full history array.

| Property | Description |
|---|---|
| `min: Double` | Smallest recorded value |
| `max: Double` | Largest recorded value |
| `average: Double` | Mean across all samples |

Produced by the `Collection<Double>.statistics` extension (see Extensions).
Each manager exposes `statistics(for: GraphDetail) -> AxisStatistics?` which
returns `nil` when the backing array is empty.

---

### `GraphDetail`  +  `Graph`  —  enums
**File:** `Model/GraphDetailModel.swift`

`GraphDetail` names every plottable axis across all three sensor domains
(20+ cases). It is the single argument passed to both `graphValue(for:)` on
each model and to `LineGraphSubView` in the UI.

`Graph` (.location, .motion, .altitude) is a domain selector used by
`LineGraphSubView` to pick the right manager's chart array at the call site.

The combination avoids any string-based dispatch: the compiler catches every
missing case when a new sensor axis is added.

---

## Observable Managers

All managers are `@MainActor @Observable` classes. They are created once with
`@State` in the app entry point and distributed globally via `.environment(...)`.
Views receive them with `@Environment` and bind with `@Bindable`.

---

### `MotionManager`
**File:** `API/MotionManager.swift`

Wraps `CMMotionManager` (device motion) and `CMAltimeter` (barometric
altitude) in a single object.

**Published state:**

| Property | Contents |
|---|---|
| `motion: MotionModel?` | Latest snapshot |
| `motionArray: [MotionModel]` | Full session history |
| `motionChart: [MotionModel]` | Rolling window ≤ `graphMaxPoints` |
| `altitude: AltitudeModel?` | Latest altimeter snapshot |
| `altitudeArray / altitudeChart` | Same pattern for altitude |
| `updatesStarted: Bool` | Whether any updates are running |
| `authorizationStatus` | Proxies `CMMotionActivityManager.authorizationStatus()` |

**Lifecycle:**

- `startMotionUpdates()` — sets `deviceMotionUpdateInterval`, starts
  `startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main)`. Uses
  closure callbacks on `.main`.
- `startAltitudeUpdates()` — starts `startRelativeAltitudeUpdates(to: .main)`.
  The callback is already delivered on `.main`; the manager updates its state directly.
- `stopMotionUpdates()` — stops both CMMotionManager and CMAltimeter.
- `resetMotionUpdates()` — clears all arrays and resets counters to 1.
- `sensorUpdateInterval` — `didSet` restarts both update loops.

`statistics(for: GraphDetail) -> AxisStatistics?` — returns min/max/average across
the full `altitudeArray` (pressure/relative altitude cases) or `motionArray`
(all other axes). Reuses `graphValue(for:)` so attitude values arrive already in degrees.

**Simulator mock data:** in `DEBUG && targetEnvironment(simulator)`, `init()`
calls `mockData()` which seeds 1 000 synthetic readings so the UI renders
without hardware.

---

### `LocationManager`
**File:** `API/LocationManager.swift`

Wraps `CLLocationManager` with a modern `async`/`await` update loop.

**Published state:**

| Property | Contents |
|---|---|
| `location: LocationModel?` | Latest fix |
| `locationArray: [LocationModel]` | Full session history |
| `locationChart: [LocationModel]` | Rolling window ≤ `graphMaxPoints` |
| `updatesStarted: Bool` | Loop sentinel |
| `authorizationStatus` | Proxies `CLLocationManager.authorizationStatus` |

**Lifecycle:**

- `startLocationUpdates()` — creates a `Task` containing a
  `for try await update in CLLocationUpdate.liveUpdates()` loop. The loop
  checks `updatesStarted` on each iteration and `break`s when it is `false`.
- `stopLocationUpdates()` — sets `updatesStarted = false`; the loop exits on
  the next iteration.
- `resetLocationUpdates()` — clears arrays and resets the counter.

`statistics(for: GraphDetail) -> AxisStatistics?` — returns min/max/average across
the full `locationArray`. Reuses `graphValue(for:)` so speed and altitude are
already unit-converted.

**Simulator mock data:** only injected when the `enable-testing` launch
argument is present, keeping the UI test environment deterministic.

---

### `SettingsManager`
**File:** `API/SettingsManager.swift`

Reads and writes `UserSettings` as a JSON blob in `UserDefaults`.
`fetchUserSettings()` returns a fresh value-type snapshot on each call.

---

### `CalculationManager`
**File:** `API/CalculationManager.swift`

Stateless unit-conversion helper. Used by model computed properties and,
directly, by views that need converted values (e.g. speed display in
`LocationView`). Contains no stored state; can be discarded after use.

---

### `ExportManager`
**File:** `API/ExportManager.swift`

Stateless CSV helper. `getFile(exportText:filename:)` writes the string to a
temp file and returns the URL. The URL is force-unwrapped (known tech debt).

---

### `MetricKitManager`
**File:** `API/MetricKitManager.swift`  ·  `#if os(iOS)` only

`@Observable` class wrapping `MXMetricManager`. Two `Task { for await report
in ... }` loops in `init()` consume `manager.metricReports` (daily
aggregated performance digest) and `manager.diagnosticReports` (crash/hang/
exception events) as async sequences — no `MXMetricManagerSubscriber`
delegate.

**Published state:**

| Property | Contents |
|---|---|
| `latestReport: MetricReportSummary?` | CPU time, GPU time, peak memory, average suspended memory, weighted hang/launch time (computed from `Histogram` buckets) |
| `diagnostics: [DiagnosticEvent]` | Ring buffer, capped at 50, newest first — crash / hang / CPU exception / disk-write exception / app-launch / memory exception |

In `DEBUG`, every raw report is also JSON-encoded and written to
`URL.documentsDirectory` for local inspection. Injected the same way as the
other managers (`@State` in `SensorAppApp`, `.environment(...)`); consumed by
`DiagnosticsScreen` (iOS, linked from `SettingsScreen`).

---

### `RecordingManager`
**File:** `Recording/RecordingManager.swift`

`@Observable` class and the sole write path for the SwiftData store. Requires
an injected `ModelContext?` (provided by `SensorAppApp` after the container is
opened). Holds minimal recording state: `isRecording`, `startedAt`, `sessionName`.

| Method | Description |
|---|---|
| `startRecording(name:)` | Sets `isRecording = true`; captures start time and optional name |
| `stopRecording(motionArray:altitudeArray:locationArray:source:)` | Converts live-data models to persistent `@Model` instances, inserts them plus the parent `SensorSession`, calls `context.save()` |
| `delete(_:)` | Deletes a `SensorSession` (cascade removes all measurements) and saves |

Live sensor data is **not** written to the store during recording — it remains
in the managers' in-memory arrays. Persistence happens only when `stopRecording`
is called, converting `MotionModel` / `AltitudeModel` / `LocationModel` values
to `MotionMeasurement` / `AltitudeMeasurement` / `LocationMeasurement` at once.

---

## Extensions

### `Extension+Double`
`localizedDecimal()` formats a `Double` for CSV export using the device locale
decimal separator. Used in every `*List.shareCSV()` method.

### `Extension+Logger`
Provides typed `Logger` subsystem constants (`Logger.coreMotion`,
`Logger.coreLocation`, `Logger.recording`) for consistent OSLog output.

### `Extension+Date`
Convenience formatting helpers used when constructing `sessionName` defaults
and measurement timestamps.

### `Collection<Double>.statistics`
Single-pass extension that iterates the collection once to compute min, max,
and sum simultaneously, then returns an `AxisStatistics` value. Returns `nil`
for empty collections. Used by both `MotionManager.statistics(for:)` and
`LocationManager.statistics(for:)`.

---

## Localization Support

`SupportedLanguage: String, CaseIterable` enumerates the ten shipped locales
(en, zh-Hans, cs, fr, de, it, ja, ko, pt, es). Used by
`PreviewLocalizationModifier` to preview any locale inside Xcode Previews
via `.previewLocalization(.german)`.

---

## Tech Debt Summary

| Location | Issue |
|---|---|
| `LocationModel` computed properties | Instantiate `CalculationManager()` + `SettingsManager()` on every access |
| `AltitudeModel` computed properties | Same as above |
| `Extension+LocationMeasurement.swift` | Same as above — copied onto the persisted `LocationMeasurement` model |
| `Extension+AltitudeMeasurement.swift` | Same as above — copied onto the persisted `AltitudeMeasurement` model |
| `ExportManager.getFile` | Force-unwraps the temp-file URL |
