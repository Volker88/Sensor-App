//
//  AltitudeMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    @Model
    public class AltitudeMeasurement {

        public var id = UUID()

        public var counter: Int = 0

        public var timestamp: String = ""

        public var pressureValue: Double = 0.0

        public var relativeAltitudeValue: Double = 0.0

        @Relationship(inverse: \SensorSession.altitudeMeasurements)
        public var session: SensorSession?

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
