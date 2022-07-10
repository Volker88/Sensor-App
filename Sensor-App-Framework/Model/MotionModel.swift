//
//  MotionModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

struct MotionModel: Hashable {
    let counter: Int
    let timestamp: String
    let accelerationXAxis: Double
    let accelerationYAxis: Double
    let accelerationZAxis: Double
    let gravityXAxis: Double
    let gravityYAxis: Double
    let gravityZAxis: Double
    let gyroXAxis: Double
    let gyroYAxis: Double
    let gyroZAxis: Double
    let magnetometerCalibration: Int
    let magnetometerXAxis: Double
    let magnetometerYAxis: Double
    let magnetometerZAxis: Double
    let attitudeRoll: Double
    let attitudePitch: Double
    let attitudeYaw: Double
    let attitudeHeading: Double
}
