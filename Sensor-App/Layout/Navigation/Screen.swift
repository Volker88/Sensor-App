//
//  Screen.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.05.25.
//

import SwiftUI

enum Screen: Hashable {
    case homeScreen
    case location
    case acceleration
    case gravity
    case gyroscope
    case magnetometer
    case attitude
    case altitude
    case settings
}

extension Screen: View {
    var body: some View {
        switch self {
            case .homeScreen:
                HomeScreen()
            case .location:
                LocationScreen()
            case .acceleration:
                AccelerationScreen()
            case .gravity:
                GravityScreen()
            case .gyroscope:
                GyroscopeScreen()
            case .magnetometer:
                MagnetometerScreen()
            case .attitude:
                AttitudeScreen()
            case .altitude:
                AltitudeScreen()
            case .settings:
                SettingsScreen()
        }
    }
}
