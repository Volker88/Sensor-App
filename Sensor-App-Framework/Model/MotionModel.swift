//
//  MotionModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

/// A snapshot of all motion sensor data captured at a single point in time.
public struct MotionModel: Hashable {

    /// Sequential index of this measurement sample within the current session.
    public let counter: Int

    /// Human-readable timestamp of when this sample was recorded.
    public let timestamp: String

    // MARK: - User Acceleration (g)
    /// User acceleration along the X axis, in g, excluding gravity.
    public let accelerationXAxis: Double

    /// User acceleration along the Y axis, in g, excluding gravity.
    public let accelerationYAxis: Double

    /// User acceleration along the Z axis, in g, excluding gravity.
    public let accelerationZAxis: Double

    // MARK: - Gravity (g)
    /// Gravity vector component along the X axis, in g.
    public let gravityXAxis: Double

    /// Gravity vector component along the Y axis, in g.
    public let gravityYAxis: Double

    /// Gravity vector component along the Z axis, in g.
    public let gravityZAxis: Double

    // MARK: - Gyroscope (rad/s)
    /// Rotation rate around the X axis, in radians per second.
    public let gyroXAxis: Double

    /// Rotation rate around the Y axis, in radians per second.
    public let gyroYAxis: Double

    /// Rotation rate around the Z axis, in radians per second.
    public let gyroZAxis: Double

    // MARK: - Magnetometer
    /// Calibration accuracy of the magnetometer.
    /// Maps to `CMMagneticFieldCalibrationAccuracy`: -1 = uncalibrated, 0 = low, 1 = medium, 2 = high.
    public let magnetometerCalibration: Int

    /// Magnetic field strength along the X axis, in microtesla.
    public let magnetometerXAxis: Double

    /// Magnetic field strength along the Y axis, in microtesla.
    public let magnetometerYAxis: Double

    /// Magnetic field strength along the Z axis, in microtesla.
    public let magnetometerZAxis: Double

    // MARK: - Attitude (radians / degrees)
    /// Roll angle in radians (rotation around the device's longitudinal axis).
    public let attitudeRoll: Double

    /// Pitch angle in radians (rotation around the device's lateral axis).
    public let attitudePitch: Double

    /// Yaw angle in radians (rotation around the device's vertical axis).
    public let attitudeYaw: Double

    /// Device heading relative to magnetic north, in degrees (0–360).
    public let attitudeHeading: Double
}

extension MotionModel {
    public func graphValue(for graph: GraphDetail) -> Double {  // swiftlint:disable:this cyclomatic_complexity
        switch graph {
            case .accelerationXAxis: return accelerationXAxis
            case .accelerationYAxis: return accelerationYAxis
            case .accelerationZAxis: return accelerationZAxis
            case .gravityXAxis: return gravityXAxis
            case .gravityYAxis: return gravityYAxis
            case .gravityZAxis: return gravityZAxis
            case .gyroXAxis: return gyroXAxis
            case .gyroYAxis: return gyroYAxis
            case .gyroZAxis: return gyroZAxis
            case .magnetometerXAxis: return magnetometerXAxis
            case .magnetometerYAxis: return magnetometerYAxis
            case .magnetometerZAxis: return magnetometerZAxis
            case .attitudeRoll: return attitudeRoll * 180 / .pi
            case .attitudePitch: return attitudePitch * 180 / .pi
            case .attitudeYaw: return attitudeYaw * 180 / .pi
            case .attitudeHeading: return attitudeHeading
            default: return 0
        }
    }
}
