//
//  SensorSessionV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    @Model
    public class SensorSession {

        public var id = UUID()

        public var name = ""

        public var startedAt = Date.distantPast

        public var endedAt: Date?

        public var createdAt = Date.distantPast

        public var source = "iPhone"

        @Relationship(deleteRule: .cascade)
        public var motionMeasurements: [MotionMeasurement]?

        @Relationship(deleteRule: .cascade)
        public var altitudeMeasurements: [AltitudeMeasurement]?

        @Relationship(deleteRule: .cascade)
        public var locationMeasurements: [LocationMeasurement]?

        public init(
            name: String,
            startedAt: Date,
            endedAt: Date? = nil,
            createdAt: Date,
            source: String,
            motionMeasurements: [MotionMeasurement]? = nil,
            altitudeMeasurements: [AltitudeMeasurement]? = nil,
            locationMeasurements: [LocationMeasurement]? = nil
        ) {
            self.name = name
            self.startedAt = startedAt
            self.endedAt = endedAt
            self.createdAt = createdAt
            self.source = source
            self.motionMeasurements = motionMeasurements
            self.altitudeMeasurements = altitudeMeasurements
            self.locationMeasurements = locationMeasurements
        }
    }
}
