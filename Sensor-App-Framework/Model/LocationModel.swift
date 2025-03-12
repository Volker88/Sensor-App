//
//  LocationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

@MainActor
public struct LocationModel: Hashable {
    public let counter: Int  // Counter
    public var longitude: Double  // Longitude in Degrees
    public var latitude: Double  // Latitude in Degrees
    public var altitude: Double  // Altitude measures in Meters
    public var speed: Double  // Speed in meter per second
    public var course: Double  // Direction the device is travelling in degrees relative to north
    public var horizontalAccuracy: Double  // Radius of uncertainity in Meters
    public var verticalAccuracy: Double  // Accuracy in Meters
    public var timestamp: String  // Timestamp of the measurement
    public var GPSAccuracy: Double  // GPS Desired Accuracy
}

extension LocationModel {
    public func graphValue(for graph: GraphDetail) -> Double {
        switch graph {
            case .latitude: return latitude
            case .longitude: return longitude
            case .altitude: return altitude
            case .speed: return calculatedSpeed
            case .course: return course
            case .horizontalAccuracy: return horizontalAccuracy
            case .verticalAccuracy: return verticalAccuracy
            case .GPSAccuracy: return GPSAccuracy
            default: return 0
        }
    }

    public var calculatedSpeed: Double {
        let calculation = CalculationManager()
        let speedSettings = SettingsManager().fetchUserSettings().GPSSpeedSetting

        return calculation.calculateSpeed(ms: speed, to: speedSettings)
    }

    public var speedUnit: String {
        let speedSettings = SettingsManager().fetchUserSettings().GPSSpeedSetting

        return speedSettings
    }

    public var calculatedAltitude: Double {
        let calculation = CalculationManager()
        let heightSettings = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return calculation.calculateHeight(height: altitude, to: heightSettings)
    }

    public var heightUnit: String {
        let heightSettings = SettingsManager().fetchUserSettings().altitudeHeightSetting

        return heightSettings
    }
}
