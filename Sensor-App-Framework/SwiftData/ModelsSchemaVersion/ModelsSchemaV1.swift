//
//  ModelsSchemaV1.swift
//  Sensor-App-Framework
//

import Foundation
import SwiftData

/// The first (and currently only) versioned schema for the Sensor-App SwiftData
/// store.
///
/// All four persistent model types — `SensorSession`, `MotionMeasurement`,
/// `AltitudeMeasurement`, and `LocationMeasurement` — are declared as nested
/// classes inside this enum so they are namespaced to the schema version.
/// Public type aliases in `SwiftData+Typealiases.swift` expose them without
/// the version prefix for day-to-day use.
///
/// When a future schema version is needed, add a `ModelsSchemaV2` enum and a
/// corresponding `MigrationStage` in `DatabaseMigrationPlan`.
public enum ModelsSchemaV1: VersionedSchema {

    public nonisolated(unsafe) static var versionIdentifier = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [
            SensorSession.self,
            MotionMeasurement.self,
            AltitudeMeasurement.self,
            LocationMeasurement.self
        ]
    }

}
