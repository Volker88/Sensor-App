//
//  MotionMeasurementV1.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension ModelsSchemaV1 {

    /// A single motion sample captured by `CMMotionManager` during a recording
    /// session.
    ///
    /// One `MotionMeasurement` is created for each tick of the motion update
    /// loop and contains the full set of values available from Core Motion at
    /// that instant: user acceleration, gravity, gyroscope rotation rate,
    /// calibrated magnetic field, and device attitude.
    ///
    /// The `session` back-reference is the inverse of
    /// `SensorSession.motionMeasurements`. It is optional to satisfy CloudKit's
    /// requirement that all relationships be optional.
    @Model
    public class MotionMeasurement {

        /// Stable identifier for this measurement.
        public var id = UUID()

        /// Sequence number within the session, starting at 1.
        public var counter: Int = 0

        /// Human-readable timestamp string at the moment this sample was taken.
        public var timestamp: String = ""

        // MARK: - User Acceleration (g)

        /// User-applied acceleration along the X axis, in g.
        public var accelerationXAxis: Double = 0.0

        /// User-applied acceleration along the Y axis, in g.
        public var accelerationYAxis: Double = 0.0

        /// User-applied acceleration along the Z axis, in g.
        public var accelerationZAxis: Double = 0.0

        // MARK: - Gravity (g)

        /// Gravity vector component along the X axis, in g.
        public var gravityXAxis: Double = 0.0

        /// Gravity vector component along the Y axis, in g.
        public var gravityYAxis: Double = 0.0

        /// Gravity vector component along the Z axis, in g.
        public var gravityZAxis: Double = 0.0

        // MARK: - Gyroscope (rad/s)

        /// Rotation rate around the X axis, in radians per second.
        public var gyroXAxis: Double = 0.0

        /// Rotation rate around the Y axis, in radians per second.
        public var gyroYAxis: Double = 0.0

        /// Rotation rate around the Z axis, in radians per second.
        public var gyroZAxis: Double = 0.0

        // MARK: - Magnetometer

        /// Magnetometer calibration accuracy level (`CMMagneticFieldCalibrationAccuracy`
        /// raw value: -1 uncalibrated, 0 low, 1 medium, 2 high).
        public var magnetometerCalibration: Int = 0

        /// Calibrated magnetic field along the X axis, in microteslas.
        public var magnetometerXAxis: Double = 0.0

        /// Calibrated magnetic field along the Y axis, in microteslas.
        public var magnetometerYAxis: Double = 0.0

        /// Calibrated magnetic field along the Z axis, in microteslas.
        public var magnetometerZAxis: Double = 0.0

        // MARK: - Attitude (radians)

        /// Roll angle of the device, in radians.
        public var attitudeRoll: Double = 0.0

        /// Pitch angle of the device, in radians.
        public var attitudePitch: Double = 0.0

        /// Yaw angle of the device, in radians.
        public var attitudeYaw: Double = 0.0

        /// True heading of the device, in degrees (0–360).
        public var attitudeHeading: Double = 0.0

        // MARK: - Relationship

        /// The session this measurement belongs to.
        @Relationship(inverse: \SensorSession.motionMeasurements)
        public var session: SensorSession?

        // MARK: - Init

        /// Creates a `MotionMeasurement` by copying values from an in-memory
        /// `MotionModel` snapshot.
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
