//
//  AltitudeModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

/// A snapshot of barometric altitude data captured at a single point in time.
public struct AltitudeModel: Hashable {

    /// Sequential index of this measurement sample within the current session.
    public let counter: Int

    /// Human-readable timestamp of when this sample was recorded.
    public let timestamp: String

    /// Atmospheric pressure in kilopascals (kPa), as reported by the barometer.
    public let pressureValue: Double

    /// Altitude change in meters relative to the starting point of the session.
    public let relativeAltitudeValue: Double
}

extension AltitudeModel {
    /// Returns the raw sensor value for the given graph axis.
    public func graphValue(for graph: GraphDetail) -> Double {
        switch graph {
            case .pressureValue: return pressureValue
            case .relativeAltitudeValue: return relativeAltitudeValue
            default: return 0
        }
    }

    /// Pressure converted to the unit selected in user settings.
    public var calculatedPressure: Double {
        let pressureSetting = SettingsManager.shared.fetchUserSettings().pressureSetting

        return CalculationManager.shared.calculatePressure(pressure: pressureValue, to: pressureSetting)
    }

    /// Localized pressure unit string derived from user settings (e.g. "kPa", "hPa", "mbar").
    public var pressureUnit: String {
        let pressureSettings = SettingsManager.shared.fetchUserSettings().pressureSetting

        return pressureSettings
    }

    /// Relative altitude converted to the height unit selected in user settings.
    public var calculatedAltitude: Double {
        let altitudeSetting = SettingsManager.shared.fetchUserSettings().altitudeHeightSetting

        return CalculationManager.shared.calculateHeight(height: relativeAltitudeValue, to: altitudeSetting)
    }

    /// Localized altitude unit string derived from user settings (e.g. "m", "ft").
    public var altitudeUnit: String {
        let altitudeSetting = SettingsManager.shared.fetchUserSettings().altitudeHeightSetting

        return altitudeSetting
    }
}
