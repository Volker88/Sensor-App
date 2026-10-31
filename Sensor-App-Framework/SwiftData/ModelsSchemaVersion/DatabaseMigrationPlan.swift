//
//  DatabaseMigrationPlan.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

/// Declares the ordered list of schema versions and any lightweight or custom
/// migration stages between them.
///
/// Currently only `ModelsSchemaV1` exists, so `stages` is empty. When a new
/// schema version is introduced, append it to `schemas` and add the
/// corresponding `MigrationStage` to `stages`.
public enum DatabaseMigrationPlan: SchemaMigrationPlan {

    /// All schema versions in chronological order, oldest first.
    public static var schemas: [any VersionedSchema.Type] {
        [
            ModelsSchemaV1.self,
            ModelsSchemaV2.self
        ]
    }

    /// Migration stages between consecutive schema versions.
    public static var stages: [MigrationStage] {
        [
            migrateV1toV2
        ]
    }

    /// V2 only adds optional sample archives and defaulted counts to `SensorSession`,
    /// so the store migrates in place. Existing sessions keep their per-sample rows.
    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: ModelsSchemaV1.self,
        toVersion: ModelsSchemaV2.self
    )
}
