# Data Architecture — SwiftData

Persistent storage for Sensor-App. All files live in `Sensor-App-Framework/SwiftData/`.

---

## Overview

Recording sessions and their sensor measurements are persisted with **SwiftData** and synchronized across the user's devices via **CloudKit** (private database). The store is shared across the main app and any future extensions through an **App Group** container.

---

## Schema & Versioning

### `ModelsSchemaV1` / `ModelsSchemaV2` — `VersionedSchema`

Every schema version is a `VersionedSchema` enum that owns its model types as nested classes
(`ModelsSchemaVersion/ModelsSchemaV1.swift`, `ModelsSchemaV2.swift`).

```
ModelsSchemaV1  (1.0.0)              ModelsSchemaV2  (2.0.0, current)
├── SensorSession                    ├── SensorSession  + sample archives & counts
├── MotionMeasurement                ├── MotionMeasurement    (unchanged, legacy)
├── AltitudeMeasurement              ├── AltitudeMeasurement  (unchanged, legacy)
└── LocationMeasurement              └── LocationMeasurement  (unchanged, legacy)
```

**V2 stores samples as archives, not rows.** Saving linked one `…Measurement` row per sample to its
session, and SwiftData's relationship bookkeeping made that cost grow roughly quadratically on device:
a 10-minute recording (~23,000 motion samples) spent 64 s just linking rows on an iPad, while the
simulator showed no such growth. V2 adds `motionSampleArchive` / `altitudeSampleArchive` /
`locationSampleArchive` (`Data?`, `.externalStorage`, synced as CloudKit assets) and their
`…SampleCount`s to `SensorSession`. See `Recording/SampleArchive.swift` for the format.

The change is additive on purpose: V1 → V2 is a lightweight migration, CloudKit's production schema
only gains fields (it can never drop record types), and sessions recorded before V2 keep their rows
untouched, so older app versions on other devices can still read them.

### Type aliases

`SwiftData+Typealiases.swift` re-exports the current schema's types at the top level so call sites never reference a versioned namespace directly:

```swift
public typealias LatestModelSchema       = ModelsSchemaV2
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
| `schemas` | `[ModelsSchemaV1.self, ModelsSchemaV2.self]` |
| `stages` | `[migrateV1toV2]` — `.lightweight`, V2 only adds optional/defaulted attributes |

`DatabaseMigrationTests` writes a real V1 store and opens it through the plan.

---

## Models

### `SensorSession`

The root aggregate. One session captures a recording interval and its samples: archived on the session
since V2, or as per-sample rows for sessions recorded before.

| Property | Type | Default | Notes |
|---|---|---|---|
| `id` | `UUID` | `UUID()` | Stable identity |
| `name` | `String` | `""` | User-visible label; defaults to formatted date/time |
| `startedAt` | `Date` | `.distantPast` | When recording began |
| `endedAt` | `Date?` | `nil` | `nil` while recording is in progress |
| `createdAt` | `Date` | `.distantPast` | Wall-clock time the record was inserted |
| `source` | `String` | `"iPhone"` | Device identifier (`"iPhone"`, `"iPad"`, `"Apple Watch"`) |
| `motionSampleArchive` | `Data?` | `nil` | V2: compressed archive of all motion samples (`.externalStorage`) |
| `altitudeSampleArchive` | `Data?` | `nil` | V2: altitude samples |
| `locationSampleArchive` | `Data?` | `nil` | V2: location samples |
| `motionSampleCount` / `altitudeSampleCount` / `locationSampleCount` | `Int` | `0` | V2: counts, readable without decoding |
| `motionMeasurements` | `[MotionMeasurement]?` | `nil` | Legacy (pre-V2 sessions only); cascade-deleted with session |
| `altitudeMeasurements` | `[AltitudeMeasurement]?` | `nil` | Legacy; cascade-deleted with session |
| `locationMeasurements` | `[LocationMeasurement]?` | `nil` | Legacy; cascade-deleted with session |

Computed helpers (in `Extension+SensorSession.swift`):

| Computed property | Type | Description |
|---|---|---|
| `duration` | `TimeInterval?` | `endedAt - startedAt`; `nil` while recording |
| `isCompleted` | `Bool` | `true` when `endedAt` is set |
| `motionSampleTotal` etc. | `Int` | Sample count from the V2 count or the legacy rows — never decodes |
| `loadMotionSamples()` etc. | `async throws -> [MotionModel]` … | Samples in recording order: decodes the archive off the main thread (`@concurrent`), or maps legacy rows. **The only read path views should use** |

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
| `attitudeRoll/Pitch/Yaw` | `Double` | Euler angles, stored in **radians** (copied verbatim from `MotionModel`; doc-comments correctly say "radians" — no conversion happens in `MotionMeasurement.init(from:)`; degrees are exposed separately via `Extension+MotionMeasurement.swift` below) |
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

- `SensorSession` owns three `@Relationship(deleteRule: .cascade)` arrays — deleting a session deletes all its measurements automatically. Since V2 these only hold data for sessions recorded before V2; new sessions leave them empty.
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

## Writing Data — `RecordingManager` + `RecordingStore`

`RecordingManager` (`@Observable`, main actor) is the only write path the UI talks to. It holds an
injected `ModelContext?` and hands the heavy work to `RecordingStore`, a plain `actor` backed by the
same `ModelContainer`, so saving or deleting a large session never blocks the main thread:

| Method | Description |
|---|---|
| `startRecording(name:)` | Sets `isRecording = true`, captures `startedAt` and session name. Ignored while `isSaving` |
| `stopRecording(motionArray:altitudeArray:locationArray:source:) async -> Bool` | Sets `isRecording = false` and `isSaving = true`, then `RecordingStore.saveSession(...)` builds the `SensorSession` with one sample archive per sensor and saves once. Returns `false` (and logs) if the save fails |
| `delete(_:) async -> Bool` | Marks the session as pending (`isPendingDeletion(_:)`, so lists hide it at once), then `RecordingStore.deleteSession(id:)` removes it. Returns `false` (and logs) if the delete fails, which also un-hides the session |
| `rename(_:to:)` | Stays on the main context — a single attribute change |

The live in-memory sensor data (`MotionModel`, `AltitudeModel`, `LocationModel`) is archived only when `stopRecording` is called — nothing is written to the store during a live recording. The arrays are `Sendable` value types, so the call itself is the snapshot.

**`RecordingStore` details**

- It is a plain `actor`, **not** a `@ModelActor`, and creates a fresh `ModelContext` (autosave off) for
  each operation. The `@ModelActor` macro's `DefaultSerialModelExecutor` runs each job on the thread
  that enqueued it, so every call from main-actor code ran the save on the main thread. A plain actor
  always runs on the cooperative pool. `RecordingMainThreadTests` keeps a main-actor ticker running
  through a 30,000-sample save and fails if the main thread stalls for 250 ms or more.
- **Save:** `SensorSession.setSamples(motion:altitude:location:)` encodes one `SampleArchive` per sensor
  (`nil` for a sensor without samples), then the session is inserted and saved once, so `@Query` only
  sees it once it's complete.
- **Delete:** one `delete(model:where:)` per legacy measurement type, using
  `#Predicate { $0.session?.id == sessionID }` (the session's `UUID`, not its `persistentModelID`), then
  the session itself, then one `save()`. Archives go with the session; the per-type deletes only find
  rows for pre-V2 sessions, where they replace the slow row-by-row cascade.
- The `@Model` classes and the three sensor structs are declared `nonisolated` (the framework defaults to
  `@MainActor`), so they can be created on the actor. Unit-conversion helpers that read
  `SettingsManager.shared` stay `@MainActor`.

Measured with `RecordingPerformanceTests` (5,000 motion + 500 altitude + 500 location samples, on-disk
store, simulator): save 3.56 s (rows, main thread) → 0.6 s (rows, background) → 14–30 ms (archives);
delete 6.9 s → 0.02 s → 2–3 ms. On an iPad, 30,000 motion samples save in ~120 ms (117 ms encoding,
2 ms writing); with rows, 20,000 took 51 s.

---

### Converting legacy sessions — `LegacyRecordingConverter`

A one-time job that turns pre-V2 sessions into archives, one transaction per session (rows → archives →
delete rows → save), skipping sessions that already have archives. It runs at launch (iPhone/iPad,
background priority, from `SensorAppApp`) since the V2 release, but is gated account-wide: nothing is
converted while the account's newest old-format session is less than 90 days old; after that, all of
them are. It's deprecated for iOS 28, when it is removed **together with the legacy read fallback** (see CLAUDE.md,
"Known tech debt").

---

## Unit Conversion on Persisted Data

> Since V2, the recording views and the CSV export work on the `MotionModel` / `AltitudeModel` /
> `LocationModel` values returned by `load…Samples()` and use the models' own `calculatedX`/`xUnit`
> properties. The `…Measurement` extensions below only serve the legacy rows.

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
`CalculationManager.shared` and `SettingsManager.shared.fetchUserSettings()` —
mitigating the instantiate-per-call pattern previously flagged as tech debt
on `LocationModel`/`AltitudeModel` (see `DataLayer-Architecture.md`).
`Extension+MotionMeasurement.swift` is the exception: it's a pure arithmetic
conversion with no settings dependency, so it never had that cost.

Net effect: a `SensorSession` recorded months ago, viewed today after the
user changed their preferred speed/pressure/height/accuracy unit, displays
correctly in the new unit without any migration or backfill.

---

## CloudKit Schema Initialization

`InitializeCloudKitSchema.initialize(_:)` is a DEBUG-only one-time helper. When passed `true`, it builds an `NSPersistentCloudKitContainer` from the managed object model derived from the four `@Model` types and calls `initializeCloudKitSchema()` to push the schema to CloudKit. Set the flag back to `false` after the first successful run.

---

## Adding a New Schema Version

1. Create `ModelsSchemaVersionV3/` with **all** model files nested inside a new `ModelsSchemaV3: VersionedSchema` (copy unchanged models too: each version needs its own types, and their relationship inverses must point at the new version's `SensorSession`).
2. Add `ModelsSchemaV3.swift` analogous to `ModelsSchemaV2.swift`.
3. Update `LatestModelSchema` in `SwiftData+Typealiases.swift` to point to `ModelsSchemaV3`.
4. Append `ModelsSchemaV3.self` to `DatabaseMigrationPlan.schemas` and add the required `MigrationStage` to `stages`; extend `DatabaseMigrationTests`.
5. Add the new framework files to the `Sensor-App` and `Sensor-App-Watch` exclusion lists in `project.xcproj`.
6. Run `InitializeCloudKitSchema.initialize(true)` once in DEBUG to push the new schema to CloudKit, then **deploy the schema to production** in the CloudKit Console before shipping.
