//
//  Extension+LocationMeasurement.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.07.26.
//

import SwiftUI

@MainActor
extension LocationMeasurement {

    /// Speed converted to the unit selected in user settings.
    public var calculatedSpeed: Double {
        CalculationManager().calculateSpeed(ms: speed, to: SettingsManager().fetchUserSettings().GPSSpeedSetting)
    }

    /// Active speed unit string (e.g. "m/s", "km/h", "mph").
    public var speedUnit: String {
        SettingsManager().fetchUserSettings().GPSSpeedSetting
    }

    /// Altitude converted to the height unit selected in user settings.
    public var calculatedAltitude: Double {
        CalculationManager().calculateHeight(
            height: altitude, to: SettingsManager().fetchUserSettings().altitudeHeightSetting)
    }

    /// Active altitude unit string (e.g. "m", "ft").
    public var heightUnit: String {
        SettingsManager().fetchUserSettings().altitudeHeightSetting
    }

    /// Horizontal accuracy converted to the accuracy unit selected in user settings.
    public var calculatedHorizontalAccuracy: Double {
        CalculationManager().calculateHeight(
            height: horizontalAccuracy,
            to: SettingsManager().fetchUserSettings().locationAccuracySetting)
    }

    /// Active horizontal accuracy unit string (e.g. "m", "ft").
    public var horizontalAccuracyUnit: String {
        SettingsManager().fetchUserSettings().locationAccuracySetting
    }

    /// Vertical accuracy converted using the same altitude height unit as `calculatedAltitude`.
    public var calculatedVerticalAccuracy: Double {
        CalculationManager().calculateHeight(
            height: verticalAccuracy,
            to: SettingsManager().fetchUserSettings().altitudeHeightSetting)
    }
}
