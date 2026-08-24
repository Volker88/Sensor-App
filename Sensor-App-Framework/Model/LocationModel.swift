//
//  LocationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

/// A single GPS/location measurement snapshot captured by `LocationManager`.
///
/// Each instance represents one reading from `CLLocationUpdate`, tagged with
/// a sequential `counter` and a `timestamp`. Raw sensor values are stored in
/// SI units; use the computed properties (`calculatedSpeed`, `calculatedAltitude`,
/// `calculatedHorizontalAccuracy`, `calculatedVerticalAccuracy`) to obtain
/// user-preferred units at display time.
public struct LocationModel: Hashable {

    /// Sequential index of this measurement within the current session.
    public let counter: Int

    /// Longitude in degrees (WGS-84).
    public var longitude: Double

    /// Latitude in degrees (WGS-84).
    public var latitude: Double

    /// Altitude above mean sea level in meters.
    public var altitude: Double

    /// Instantaneous speed in meters per second as reported by Core Location.
    public var speed: Double

    /// Direction of travel in degrees relative to true north (0–360).
    public var course: Double

    /// Horizontal radius of uncertainty in meters.
    public var horizontalAccuracy: Double

    /// Vertical accuracy of the altitude value in meters.
    public var verticalAccuracy: Double

    /// Timestamp of the measurement.
    public var timestamp: String

    /// Desired GPS accuracy setting in effect when this measurement was taken.
    public var GPSAccuracy: Double
}

extension LocationModel {

    /// Returns the raw Double value for the given `GraphDetail` axis.
    ///
    /// Speed is returned as `calculatedSpeed` (user-preferred unit) so the chart
    /// reflects the same value the user sees in the readout. All other values are
    /// returned as-is from the stored properties. Returns `0` for axes that don't
    /// apply to location data.
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

    /// Speed converted to the unit selected in user settings (km/h, mph, knots, or m/s).
    public var calculatedSpeed: Double {
        let speedSettings = SettingsManager.shared.fetchUserSettings().GPSSpeedSetting

        return CalculationManager.shared.calculateSpeed(ms: speed, to: speedSettings)
    }

    /// The localized abbreviation of the speed unit currently selected in settings (e.g. `"km/h"`).
    public var speedUnit: String {
        let speedSettings = SettingsManager.shared.fetchUserSettings().GPSSpeedSetting

        return speedSettings
    }

    /// Altitude converted to the height unit selected in user settings (meters, feet, etc.).
    public var calculatedAltitude: Double {
        let heightSettings = SettingsManager.shared.fetchUserSettings().altitudeHeightSetting

        return CalculationManager.shared.calculateHeight(height: altitude, to: heightSettings)
    }

    /// The localized abbreviation of the altitude unit currently selected in settings (e.g. `"m"` or `"ft"`).
    public var heightUnit: String {
        let heightSettings = SettingsManager.shared.fetchUserSettings().altitudeHeightSetting

        return heightSettings
    }

    /// Horizontal accuracy converted to the accuracy unit selected in user settings.
    public var calculatedHorizontalAccuracy: Double {
        CalculationManager.shared.calculateHeight(
            height: horizontalAccuracy,
            to: SettingsManager.shared.fetchUserSettings().locationAccuracySetting)
    }

    /// The localized abbreviation of the accuracy unit selected in settings (e.g. `"m"`, `"ft"`).
    public var horizontalAccuracyUnit: String {
        SettingsManager.shared.fetchUserSettings().locationAccuracySetting
    }

    /// Vertical accuracy converted using the same altitude height unit as `calculatedAltitude`.
    public var calculatedVerticalAccuracy: Double {
        CalculationManager.shared.calculateHeight(
            height: verticalAccuracy,
            to: SettingsManager.shared.fetchUserSettings().altitudeHeightSetting)
    }
}
