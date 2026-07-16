//
//  Extension+AltitudeMeasurement.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 14.07.26.
//

import SwiftUI

@MainActor
extension AltitudeMeasurement {

    /// Pressure converted to the unit selected in user settings.
    public var calculatedPressure: Double {
        CalculationManager().calculatePressure(
            pressure: pressureValue, to: SettingsManager().fetchUserSettings().pressureSetting)
    }

    /// Active pressure unit string (e.g. "kPa", "hPa", "mbar").
    public var pressureUnit: String {
        SettingsManager().fetchUserSettings().pressureSetting
    }

    /// Relative altitude converted to the height unit selected in user settings.
    public var calculatedAltitude: Double {
        CalculationManager().calculateHeight(
            height: relativeAltitudeValue, to: SettingsManager().fetchUserSettings().altitudeHeightSetting)
    }

    /// Active altitude unit string (e.g. "m", "ft").
    public var altitudeUnit: String {
        SettingsManager().fetchUserSettings().altitudeHeightSetting
    }
}
