//
//  DatabaseMigrationPlan.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

public enum DatabaseMigrationPlan: SchemaMigrationPlan {

    public static var schemas: [any VersionedSchema.Type] {
        [
            ModelsSchemaV1.self
        ]
    }

    public static var stages: [MigrationStage] {
        []
    }
}
