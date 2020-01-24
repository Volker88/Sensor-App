//
//  GraphDetailModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation

// MARK: - GraphDetail Types
enum GraphDetail {
    // LocationModel
    case latitude
    case longitude
    case altitude
    case speed
    case course
    case horizontalAccuracy
    case verticalAccuracy
    case GPSAccuracy
    
    // MotionModel
    case accelerationXAxis
    case accelerationYAxis
    case accelerationZAxis
    case gravityXAxis
    case gravityYAxis
    case gravityZAxis
    case gyroXAxis
    case gyroYAxis
    case gyroZAxis
    case magnetometerXAxis
    case magnetometerYAxis
    case magnetometerZAxis
    case attitudeRoll
    case attitudePitch
    case attitudeYaw
    case attitudeHeading
    
    // AltitudeModel
    case pressureValue
    case relativeAltitudeValue
}
