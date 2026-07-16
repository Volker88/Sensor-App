//
//  Extension+MotionMeasurement.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.07.26.
//

import SwiftUI

extension MotionMeasurement {

    /// Attitude roll angle in degrees (converted from stored radians).
    public var attitudeRollDegrees: Double { attitudeRoll * 180 / .pi }

    /// Attitude pitch angle in degrees (converted from stored radians).
    public var attitudePitchDegrees: Double { attitudePitch * 180 / .pi }

    /// Attitude yaw angle in degrees (converted from stored radians).
    public var attitudeYawDegrees: Double { attitudeYaw * 180 / .pi }
}
