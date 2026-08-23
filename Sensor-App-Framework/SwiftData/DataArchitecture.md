# Data Architecture — SwiftData

Persistent storage for Sensor-App. All files live in `Sensor-App-Framework/SwiftData/`.

---

## Overview

Recording sessions and their sensor measurements are persisted with **SwiftData** and synchronized across the user's devices via **CloudKit** (private database). The store is shared across the main app and any future extensions through an **App Group** container.

---

## Schema & Versioning

### `ModelsSchemaV1` — `VersionedSchema` (1.0.0)

Defined in `ModelsSchemaVersion/ModelsSchemaV1.swift`. Every schema version is a `VersionedSchema` enum that owns its model types as nested classes.

```
ModelsSchemaV1  (Schema.Version 1.0.0)
├── SensorSession
├── MotionMeasurement
├── AltitudeMeasurement
└── LocationMeasurement
```

### Type aliases

`SwiftData+Typealiases.swift` re-exports the current schema's types at the top level so call sites never reference a versioned namespace directly:

```swift
public typealias LatestModelSchema       = ModelsSchemaV1
public typealias SensorSession           = LatestModelSchema.SensorSession
public typealias MotionMeasurement       = LatestModelSchema.MotionMeasurement
public typealias AltitudeMeasurement     = LatestModelSchema.AltitudeMeasurement
public typealias LocationMeasurement     = LatestModelSchema.LocationMeasurement
```

When a new schema version is added, only `LatestModelSchema` needs to change; all other code follows automatically.

### `DatabaseMigrationPlan` — `SchemaMigrationPlan`

Defined in `ModelsSchemaVersion/DatabaseMigrationPlan.swift`. Lists every `VersionedSchema` in chronological order. Migration stages are added here when a model changes incompatibly.

| Property | Value |
|---|---|
| `schemas` | `[ModelsSchemaV1.self]` |
| `stages` | `[]` (no migrations yet) |

---

## Models

### `SensorSession`

The root aggregate. One session captures a recording interval and owns three optional arrays of measurements.

| Property | Type | Default | Notes |
|---|---|---|---|
| `id` | `UUID` | `UUID()` | Stable identity |
| `name` | `String` | `""` | User-visible label; defaults to formatted date/time |
| `startedAt` | `Date` | `.distantPast` | When recording began |
| `endedAt` | `Date?` | `nil` | `nil` while recording is in progress |
| `createdAt` | `Date` | `.distantPast` | Wall-clock time the record was inserted |
| `source` | `String` | `"iPhone"` | Device identifier (`"iPhone"`, `"Apple Watch"`, …) |
| `motionMeasurements` | `[MotionMeasurement]?` | `nil` | Cascade-deleted with session |
| `altitudeMeasurements` | `[AltitudeMeasurement]?` | `nil` | Cascade-deleted with session |
| `locationMeasurements` | `[LocationMeasurement]?` | `nil` | Cascade-deleted with session |

Computed helpers (in `Extension+SensorSession.swift`):

| Computed property | Type | Description |
|---|---|---|
| `duration` | `TimeInterval?` | `endedAt - startedAt`; `nil` while recording |
| `isCompleted` | `Bool` | `true` when `endedAt` is set |

### `MotionMeasurement`

One snapshot from `CMMotionManager`. Consolidates all motion sensor axes into a single row to avoid four separate tables.

| Property | Type | Sensor group |
|---|---|---|
| `id` | `UUID` | — |
| `counter` | `Int` | Sequence index within the session |
| `timestamp` | `String` | Formatted sample time |
| `accelerationXAxis/YAxis/ZAxis` | `Double` | User acceleration (g) |
| `gravityXAxis/YAxis/ZAxis` | `Double` | Gravity vector (g) |
| `gyroXAxis/YAxis/ZAxis` | `Double` | Rotation rate (rad/s) |
| `magnetometerCalibration` | `Int` | Calibration accuracy level |
| `magnetometerXAxis/YAxis/ZAxis` | `Double` | Magnetic field (µT) |
| `attitudeRoll/Pitch/Yaw` | `Double` | Euler angles, stored in **radians** (copied verbatim from `MotionModel`; the field doc-comment says "degrees" but no conversion happens in `MotionMeasurement.init(from:)` — see `Extension+MotionMeasurement.swift` below) |
| `attitudeHeading` | `Double` | True heading (degrees) |
| `session` | `SensorSession?` | Back-reference to owning session |

### `AltitudeMeasurement`

One snapshot from `CMAltimeter`.

| Property | Type | Notes |
|---|---|---|
| `id` | `UUID` | — |
| `counter` | `Int` | Sequence index within the session |
| `timestamp` | `String` | Formatted sample time |
| `pressureValue` | `Double` | Barometric pressure (kPa) |
| `relativeAltitudeValue` | `Double` | Altitude change since start (m) |
| `session` | `SensorSession?` | Back-reference to owning session |

### `LocationMeasurement`

One fix from `CLLocationManager`.

| Property | Type | Notes |
|---|---|---|
| `id` | `UUID` | — |
| `counter` | `Int` | Sequence index within the session |
| `timestamp` | `String` | Formatted sample time |
| `longitude` | `Double` | Decimal degrees |
| `latitude` | `Double` | Decimal degrees |
| `altitude` | `Double` | GPS altitude (m) |
| `speed` | `Double` | Ground speed (m/s) |
| `course` | `Double` | Direction of travel (degrees) |
| `horizontalAccuracy` | `Double` | Horizontal error radius (m) |
| `verticalAccuracy` | `Double` | Vertical error (m) |
| `GPSAccuracy` | `Double` | HDOP or equivalent |
| `session` | `SensorSession?` | Back-reference to owning session |

---

## Relationships

```
SensorSession  1 ──cascade──► *  MotionMeasurement    (inverse: session)
               1 ──cascade──► *  AltitudeMeasurement  (inverse: session)
               1 ──cascade──► *  LocationMeasurement  (inverse: session)
```

- `SensorSession` owns three `@Relationship(deleteRule: .cascade)` arrays — deleting a session deletes all its measurements automatically.
- Each measurement holds a `@Relationship(inverse: \SensorSession.<array>)` back-reference. All relationship properties are `Optional` to satisfy CloudKit's requirement that no relationship be non-optional.

---

## Container

### `ContainerConfiguration`

Reads two build-time identifiers from `Info.plist` (injected by `.xcconfig`):

| Key | Resolves to |
|---|---|
| `APP_GROUP_ID` | `group.<bundle>` (`.dev` suffix in Debug) |
| `CLOUDKIT_CONTAINER_ID` | `iCloud.<bundle>` |

### `SwiftDataContainer`

`nonisolated` class so widgets and extensions can construct it from non-main-actor contexts. Exposes one `ModelContainer?` property.

| Consumer type | `allowsSave` | `cloudKitDatabase` | Migration plan |
|---|---|---|---|
| Main app | `true` | `.private(containerID)` | `DatabaseMigrationPlan` |
| Extension / widget | `false` | `.none` | None (reads already-migrated store) |
| Fallback (error) | `false` | `.none` | None (in-memory only) |

Three-level fallback strategy:

1. **Normal path** — open on-disk store with CloudKit and migration.
2. **In-memory fallback** — if the store cannot be opened (e.g. file protection during lock screen background refresh), open a transient in-memory store without CloudKit.
3. **Nil container** — if even the in-memory store fails, `modelContainer` is set to `nil`. Widgets render placeholder content; the main app unwraps explicitly and fails loudly.

Extensions must never drive migration (file I/O fails inside the extension sandbox when the device is locked); they open the already-migrated store read-only with CloudKit disabled.

---

## Writing Data — `RecordingManager`

`RecordingManager` (`@Observable`) is the only write path. It holds an injected `ModelContext?` and exposes:

| Method | Description |
|---|---|
| `startRecording(name:)` | Sets `isRecording = true`, captures `startedAt` and session name |
| `stopRecording(motionArray:altitudeArray:locationArray:source:)` | Creates `SensorSession` + all three measurement arrays from the in-memory live-data models, inserts everything, calls `context.save()` |
| `delete(_:)` | Deletes a `SensorSession` (cascade removes all measurements) and saves |

The live in-memory sensor data (`MotionModel`, `AltitudeModel`, `LocationModel`) is converted to persistent `@Model` instances only when `stopRecording` is called — nothing is written to the store during a live recording.

---

## Unit Conversion on Persisted Data

`@Model` types store raw values exactly as captured (SI units for
motion/altitude, native `CLLocation` values for location) — a user changing
their preferred unit later never rewrites old rows. Instead, three extension
files add computed properties that convert at *read* time, mirroring the
`calculatedX`/`xUnit` pattern already used by the in-memory `LocationModel`/
`AltitudeModel`:

| File | Adds to | Computed properties |
|---|---|---|
| `Extension+LocationMeasurement.swift` | `LocationMeasurement` | `calculatedSpeed`/`speedUnit`, `calculatedAltitude`/`heightUnit`, `calculatedHorizontalAccuracy`/`horizontalAccuracyUnit`, `calculatedVerticalAccuracy` |
| `Extension+AltitudeMeasurement.swift` | `AltitudeMeasurement` | `calculatedPressure`/`pressureUnit`, `calculatedAltitude`/`altitudeUnit` |
| `Extension+MotionMeasurement.swift` | `MotionMeasurement` | `attitudeRollDegrees`/`attitudePitchDegrees`/`attitudeYawDegrees` (radians → degrees; no `UserSettings` involved) |

The `LocationMeasurement`/`AltitudeMeasurement` extensions call
`CalculationManager()` and `SettingsManager().fetchUserSettings()` fresh on
every access — the same instantiate-per-call pattern already flagged as tech
debt on `LocationModel`/`AltitudeModel` (see `DataLayer-Architecture.md`).
`Extension+MotionMeasurement.swift` is the exception: it's a pure arithmetic
conversion with no settings dependency, so it doesn't carry the same cost.

Net effect: a `SensorSession` recorded months ago, viewed today after the
user changed their preferred speed/pressure/height/accuracy unit, displays
correctly in the new unit without any migration or backfill.

---

## CloudKit Schema Initialization

`InitializeCloudKitSchema.initialize(_:)` is a DEBUG-only one-time helper. When passed `true`, it builds an `NSPersistentCloudKitContainer` from the managed object model derived from the four `@Model` types and calls `initializeCloudKitSchema()` to push the schema to CloudKit. Set the flag back to `false` after the first successful run.

---

## Adding a New Schema Version

1. Create `ModelsSchemaVersionV2/` with updated model files nested inside a new `ModelsSchemaV2: VersionedSchema`.
2. Add `ModelsSchemaV2.swift` analogous to `ModelsSchemaV1.swift`.
3. Update `LatestModelSchema` in `SwiftData+Typealiases.swift` to point to `ModelsSchemaV2`.
4. Append `ModelsSchemaV2.self` to `DatabaseMigrationPlan.schemas` and add the required `MigrationStage` to `stages`.
5. Run `InitializeCloudKitSchema.initialize(true)` once in DEBUG to push the new schema to CloudKit.
