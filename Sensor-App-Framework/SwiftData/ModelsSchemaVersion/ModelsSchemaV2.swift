//
//  ModelsSchemaV2.swift
//  Sensor-App-Framework
//

import Foundation
import SwiftData

/// The second versioned schema for the Sensor-App SwiftData store.
///
/// V2 stores a session's samples as compressed JSON archives on `SensorSession`
/// (`motionSampleArchive`, `altitudeSampleArchive`, `locationSampleArchive` plus counts)
/// instead of one row per sample. Linking tens of thousands of rows to a session
/// made saving a long recording take minutes on device.
///
/// The change is purely additive, so V1 → V2 is a lightweight migration and the
/// CloudKit schema only gains fields. The per-sample measurement models are kept
/// unchanged: sessions recorded before V2 still keep their samples there and are
/// read through them.
///
/// When a future schema version is needed, add a `ModelsSchemaV3` enum and a
/// corresponding `MigrationStage` in `DatabaseMigrationPlan`.
public enum ModelsSchemaV2: VersionedSchema {

    public static let versionIdentifier = Schema.Version(2, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [
            SensorSession.self,
            MotionMeasurement.self,
            AltitudeMeasurement.self,
            LocationMeasurement.self
        ]
    }

}
