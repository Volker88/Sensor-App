//
//  LocationMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    @Model
    public class LocationMeasurement {

        public var id = UUID()

        public var counter: Int = 0

        public var timestamp: String = ""

        public var longitude: Double = 0.0

        public var latitude: Double = 0.0

        public var altitude: Double = 0.0

        public var speed: Double = 0.0

        public var course: Double = 0.0

        public var horizontalAccuracy: Double = 0.0

        public var verticalAccuracy: Double = 0.0

        public var GPSAccuracy: Double = 0.0

        @Relationship(inverse: \SensorSession.locationMeasurements)
        public var session: SensorSession?

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
