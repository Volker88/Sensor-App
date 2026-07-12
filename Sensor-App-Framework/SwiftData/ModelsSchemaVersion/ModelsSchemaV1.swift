//
//  ModelsSchemaV1.swift
//  Sensor-App-Framework
//

import Foundation
import SwiftData

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
