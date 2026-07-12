//
//  MotionMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    @Model
    public class MotionMeasurement {

        public var id = UUID()

        public var counter: Int = 0

        public var timestamp: String = ""
        public var accelerationXAxis: Double = 0.0

        public var accelerationYAxis: Double = 0.0

        public var accelerationZAxis: Double = 0.0

        public var gravityXAxis: Double = 0.0

        public var gravityYAxis: Double = 0.0

        public var gravityZAxis: Double = 0.0

        public var gyroXAxis: Double = 0.0

        public var gyroYAxis: Double = 0.0

        public var gyroZAxis: Double = 0.0

        public var magnetometerCalibration: Int = 0

        public var magnetometerXAxis: Double = 0.0

        public var magnetometerYAxis: Double = 0.0

        public var magnetometerZAxis: Double = 0.0

        public var attitudeRoll: Double = 0.0

        public var attitudePitch: Double = 0.0

        public var attitudeYaw: Double = 0.0

        public var attitudeHeading: Double = 0.0

        @Relationship(inverse: \SensorSession.motionMeasurements)
        public var session: SensorSession?

        public init(from model: MotionModel, session: SensorSession? = nil) {
            self.id = UUID()
            self.counter = model.counter
            self.timestamp = model.timestamp
            self.accelerationXAxis = model.accelerationXAxis
            self.accelerationYAxis = model.accelerationYAxis
            self.accelerationZAxis = model.accelerationZAxis
            self.gravityXAxis = model.gravityXAxis
            self.gravityYAxis = model.gravityYAxis
            self.gravityZAxis = model.gravityZAxis
            self.gyroXAxis = model.gyroXAxis
            self.gyroYAxis = model.gyroYAxis
            self.gyroZAxis = model.gyroZAxis
            self.magnetometerCalibration = model.magnetometerCalibration
            self.magnetometerXAxis = model.magnetometerXAxis
            self.magnetometerYAxis = model.magnetometerYAxis
            self.magnetometerZAxis = model.magnetometerZAxis
            self.attitudeRoll = model.attitudeRoll
            self.attitudePitch = model.attitudePitch
            self.attitudeYaw = model.attitudeYaw
            self.attitudeHeading = model.attitudeHeading
            self.session = session
        }
    }
}
