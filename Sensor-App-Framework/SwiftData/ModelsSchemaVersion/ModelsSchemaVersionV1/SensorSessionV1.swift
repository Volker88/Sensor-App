//
//  SensorSessionV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    /// A recorded sensor session that groups all measurements captured between
    /// a start and stop event.
    ///
    /// `SensorSession` is the root entity in the SwiftData schema. Every
    /// measurement type (`MotionMeasurement`, `AltitudeMeasurement`,
    /// `LocationMeasurement`) belongs to exactly one session via an optional
    /// inverse relationship. Deleting a session cascades to all its
    /// child measurements.
    ///
    /// CloudKit sync is enabled, so every property has a default value and all
    /// relationships are optional — required by the CloudKit constraint that
    /// disallows non-optional relationships.
    @Model
    public class SensorSession {

        /// Stable identifier for this session.
        public var id = UUID()

        /// User-visible name of the recording session.
        public var name = ""

        /// Timestamp when the recording was started.
        public var startedAt = Date.distantPast

        /// Timestamp when the recording was stopped. `nil` while a session is
        /// still active.
        public var endedAt: Date?

        /// Timestamp when the record was first persisted to the store.
        public var createdAt = Date.distantPast

        /// Device that captured this session (e.g. `"iPhone"`, `"Apple Watch"`).
        public var source = "iPhone"

        /// Motion samples (acceleration, gravity, gyroscope, magnetometer,
        /// attitude) recorded during this session.
        @Relationship(deleteRule: .cascade)
        public var motionMeasurements: [MotionMeasurement]?

        /// Barometric pressure and relative-altitude samples recorded during
        /// this session.
        @Relationship(deleteRule: .cascade)
        public var altitudeMeasurements: [AltitudeMeasurement]?

        /// GPS / location samples recorded during this session.
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
