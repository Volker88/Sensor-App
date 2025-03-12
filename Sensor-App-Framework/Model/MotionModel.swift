//
//  MotionModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

public struct MotionModel: Hashable {
    public let counter: Int
    public let timestamp: String
    public let accelerationXAxis: Double
    public let accelerationYAxis: Double
    public let accelerationZAxis: Double
    public let gravityXAxis: Double
    public let gravityYAxis: Double
    public let gravityZAxis: Double
    public let gyroXAxis: Double
    public let gyroYAxis: Double
    public let gyroZAxis: Double
    public let magnetometerCalibration: Int
    public let magnetometerXAxis: Double
    public let magnetometerYAxis: Double
    public let magnetometerZAxis: Double
    public let attitudeRoll: Double
    public let attitudePitch: Double
    public let attitudeYaw: Double
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
