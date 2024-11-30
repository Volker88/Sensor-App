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

extension MotionModel {
    func graphValue(for graph: GraphDetail) -> Double {  // swiftlint:disable:this cyclomatic_complexity
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
