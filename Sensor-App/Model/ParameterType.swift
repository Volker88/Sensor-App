//
//  ParameterType.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - Parameter Types
enum ParameterType {
    case longitude
    case latitude
    case altitude
    case speed
    case course
    case horizontalAccuracy
    case verticalAccuracy
    case GPSAccuracy
    case accelerationXAxis
    case accelerationYAxis
    case accelerationZAxis
    case gravityXAxis
    case gravityYAxis
    case gravityZAxis
    case gyroXAxis
    case gyroYAxis
    case gyroZAxis
    case magnetometerCalibration
    case magnetometerXAxis
    case magnetometerYAxis
    case magnetometerZAxis
    case attitudeRoll
    case attitudePitch
    case attitudeYaw
    case attitudeHeading
    case pressureValue
    case relativeAltitudeValue
}
