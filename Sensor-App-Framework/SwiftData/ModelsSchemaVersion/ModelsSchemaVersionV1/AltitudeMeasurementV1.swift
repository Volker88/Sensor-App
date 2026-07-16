//
//  AltitudeMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    /// A single barometric pressure and relative-altitude sample captured by
    /// `CMAltimeter` during a recording session.
    ///
    /// One `AltitudeMeasurement` is created for each altimeter update. It
    /// stores the raw pressure value and the altitude change relative to the
    /// point where the altimeter was started.
    ///
    /// The `session` back-reference is the inverse of
    /// `SensorSession.altitudeMeasurements`. It is optional to satisfy CloudKit's
    /// requirement that all relationships be optional.
    @Model
    public class AltitudeMeasurement {

        /// Stable identifier for this measurement.
        public var id = UUID()

        /// Sequence number within the session, starting at 1.
        public var counter: Int = 0

        /// Human-readable timestamp string at the moment this sample was taken.
        public var timestamp: String = ""

        /// Atmospheric pressure at the time of measurement, in kilopascals.
        public var pressureValue: Double = 0.0

        /// Change in altitude since the altimeter was started, in metres.
        /// Positive values indicate upward movement.
        public var relativeAltitudeValue: Double = 0.0

        // MARK: - Relationship

        /// The session this measurement belongs to.
        @Relationship(inverse: \SensorSession.altitudeMeasurements)
        public var session: SensorSession?

        // MARK: - Init

        /// Creates an `AltitudeMeasurement` by copying values from an in-memory
        /// `AltitudeModel` snapshot.
        public init(from model: AltitudeModel, session: SensorSession? = nil) {
            self.id = UUID()
            self.counter = model.counter
            self.timestamp = model.timestamp
            self.pressureValue = model.pressureValue
            self.relativeAltitudeValue = model.relativeAltitudeValue
            self.session = session
        }
    }
}
