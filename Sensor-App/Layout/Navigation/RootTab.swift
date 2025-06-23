//
//  RootTab.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.06.25.
//

import SwiftUI

/// Root TabView Tab's
enum RootTab: Hashable {
    case position
    case location
    case altitude
    case motion
    case acceleration
    case gravity
    case gyroscope
    case attitude
    case magnetometer
    case settings

    // Computed property for the string representation (similar to rawValue)
    var stringValue: String {
        switch self {
            case .position:
                return "Position"
            case .location:
                return "Location"
            case .altitude:
                return "Altitude"
            case .motion:
                return "Motion"
            case .acceleration:
                return "Acceleration"
            case .gravity:
                return "Gravity"
            case .gyroscope:
                return "Gyroscope"
            case .attitude:
                return "Attitude"
            case .magnetometer:
                return "Magnetometer"
            case .settings:
                return "Settings"
        }
    }

    var localizedString: LocalizedStringResource {
        switch self {
            case .position:
                return LocalizedStringResource("Position")
            case .location:
                return LocalizedStringResource("Location")
            case .altitude:
                return LocalizedStringResource("Altitude")
            case .motion:
                return LocalizedStringResource("Motion")
            case .acceleration:
                return LocalizedStringResource("Acceleration")
            case .gravity:
                return LocalizedStringResource("Gravity")
            case .gyroscope:
                return LocalizedStringResource("Gyroscope")
            case .attitude:
                return LocalizedStringResource("Attitude")
            case .magnetometer:
                return LocalizedStringResource("Magnetometer")
            case .settings:
                return LocalizedStringResource("Settings")
        }
    }

    var symbolImage: String {
        switch self {
            case .position:
                return "location"
            case .location:
                return "location"
            case .altitude:
                return "Altitude"
            case .motion:
                return "speedometer"
            case .acceleration:
                return "Acceleration"
            case .gravity:
                return "Gravity"
            case .gyroscope:
                return "gyroscope"
            case .attitude:
                return "Attitude"
            case .magnetometer:
                return "wave.3.right"
            case .settings:
                return "gear"
        }
    }
}

// MARK: - View Extension
extension RootTab: View {
    var body: some View {
        switch self {
            case .position:
                PositionScreen()
            case .location:
                LocationScreen()
            case .altitude:
                AltitudeScreen()
            case .motion:
                MotionScreen()
            case .acceleration:
                AccelerationScreen()
            case .gravity:
                GravityScreen()
            case .gyroscope:
                GyroscopeScreen()
            case .attitude:
                AttitudeScreen()
            case .magnetometer:
                MagnetometerScreen()
            case .settings:
                SettingsScreen()
        }
    }
}
