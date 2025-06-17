//
//  MotionStack.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

/// Motion Routes
enum MotionStack: String, Hashable {
    case acceleration
    case accelerationLog
    case gravity
    case gravityLog
    case gyroscope
    case gyroscopeLog
    case attitude
    case attitudeLog
}

extension MotionStack: View {
    var body: some View {
        switch self {
            case .acceleration:
                AccelerationScreen()
            case .accelerationLog:
                AccelerationList()
            case .gravity:
                GravityScreen()
            case .gravityLog:
                GravityList()
            case .gyroscope:
                GyroscopeScreen()
            case .gyroscopeLog:
                GyroscopeList()
            case .attitude:
                AttitudeScreen()
            case .attitudeLog:
                AttitudeList()
        }
    }
}
