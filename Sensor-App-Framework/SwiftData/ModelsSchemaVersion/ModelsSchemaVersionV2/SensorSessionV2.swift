//
//  SensorSessionV2.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 26.10.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV2 {

    /// A recorded sensor session that groups all measurements captured between
    /// a start and stop event.
    ///
    /// Sessions recorded since V2 keep their samples in the `…SampleArchive` attributes
    /// (see `SampleArchive`), written once when the recording stops. Sessions
    /// recorded before V2 keep them as `MotionMeasurement` / `AltitudeMeasurement` /
    /// `LocationMeasurement` rows in the relationships below; those rows are never
    /// converted, so older app versions on other devices can still read them.
    /// Read samples through `loadMotionSamples()` etc., which handle both. Deleting a
    /// session cascades to any legacy rows; archives are deleted with the session.
    ///
    /// CloudKit sync is enabled, so every property has a default value and all
    /// relationships are optional — required by the CloudKit constraint that
    /// disallows non-optional relationships.
    @Model
    nonisolated public class SensorSession {

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

        // MARK: - Sample archives (V2)

        /// Compressed archive of all motion samples. `nil` for sessions recorded
        /// before V2 (their samples are in `motionMeasurements`). Stored outside the
        /// database file, and synced to CloudKit as an asset.
        @Attribute(.externalStorage)
        public var motionSampleArchive: Data?

        /// Compressed archive of all altitude samples; see `motionSampleArchive`.
        @Attribute(.externalStorage)
        public var altitudeSampleArchive: Data?

        /// Compressed archive of all location samples; see `motionSampleArchive`.
        @Attribute(.externalStorage)
        public var locationSampleArchive: Data?

        /// Number of samples in `motionSampleArchive`, so counts can be shown without
        /// decoding the archive.
        public var motionSampleCount = 0

        /// Number of samples in `altitudeSampleArchive`.
        public var altitudeSampleCount = 0

        /// Number of samples in `locationSampleArchive`.
        public var locationSampleCount = 0

        // MARK: - Legacy per-sample rows (V1)

        /// Motion samples (acceleration, gravity, gyroscope, magnetometer,
        /// attitude) of a session recorded before V2. Empty for newer sessions.
        @Relationship(deleteRule: .cascade)
        public var motionMeasurements: [MotionMeasurement]?

        /// Barometric pressure and relative-altitude samples of a session
        /// recorded before V2. Empty for newer sessions.
        @Relationship(deleteRule: .cascade)
        public var altitudeMeasurements: [AltitudeMeasurement]?

        /// GPS / location samples of a session recorded before V2. Empty for
        /// newer sessions.
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
