//
//  LocationMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    /// A single GPS / location sample captured by `CLLocationManager` during
    /// a recording session.
    ///
    /// One `LocationMeasurement` is created for each `CLLocationUpdate`
    /// delivered by the async live-updates stream. It stores the full set of
    /// position, accuracy, speed, and course values available from Core Location
    /// at that instant.
    ///
    /// The `session` back-reference is the inverse of
    /// `SensorSession.locationMeasurements`. It is optional to satisfy CloudKit's
    /// requirement that all relationships be optional.
    @Model
    public class LocationMeasurement {

        /// Stable identifier for this measurement.
        public var id = UUID()

        /// Sequence number within the session, starting at 1.
        public var counter: Int = 0

        /// Human-readable timestamp string at the moment this sample was taken.
        public var timestamp: String = ""

        /// Longitude of the device, in decimal degrees (WGS-84).
        public var longitude: Double = 0.0

        /// Latitude of the device, in decimal degrees (WGS-84).
        public var latitude: Double = 0.0

        /// Altitude above mean sea level, in metres.
        public var altitude: Double = 0.0

        /// Current speed of the device, in metres per second. Negative if
        /// unavailable.
        public var speed: Double = 0.0

        /// Direction of travel, in degrees measured clockwise from true north
        /// (0–360). Negative if unavailable.
        public var course: Double = 0.0

        /// Radius of uncertainty for the horizontal position, in metres.
        /// Smaller values indicate higher accuracy.
        public var horizontalAccuracy: Double = 0.0

        /// Uncertainty for the vertical position (altitude), in metres.
        /// Smaller values indicate higher accuracy.
        public var verticalAccuracy: Double = 0.0

        /// Combined GPS accuracy indicator derived from horizontal and vertical
        /// accuracy.
        public var GPSAccuracy: Double = 0.0

        // MARK: - Relationship

        /// The session this measurement belongs to.
        @Relationship(inverse: \SensorSession.locationMeasurements)
        public var session: SensorSession?

        // MARK: - Init

        /// Creates a `LocationMeasurement` by copying values from an in-memory
        /// `LocationModel` snapshot.
        public init(from model: LocationModel, session: SensorSession? = nil) {
            self.id = UUID()
            self.counter = model.counter
            self.timestamp = model.timestamp
            self.longitude = model.longitude
            self.latitude = model.latitude
            self.altitude = model.altitude
            self.speed = model.speed
            self.course = model.course
            self.horizontalAccuracy = model.horizontalAccuracy
            self.verticalAccuracy = model.verticalAccuracy
            self.GPSAccuracy = model.GPSAccuracy
            self.session = session
        }
    }
}
