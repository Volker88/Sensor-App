//
//  SettingsModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 06.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation
import SwiftUI

// MARK: - Class Definition
class SettingsAPI {

    // MARK: - GPS Settings
    public let GPSSpeedSettings = [
        UnitSpeed.metersPerSecond.symbol,
        UnitSpeed.kilometersPerHour.symbol,
        UnitSpeed.milesPerHour.symbol
    ]

    public let GPSAccuracyOptions = ["Best", "10 Meter", "100 Meter", "Kilometer", "3 Kilometer"]

    // MARK: - Altitude Settings
    public let altitudePressure = [
        UnitPressure.millibars.symbol,
        UnitPressure.bars.symbol,
        UnitPressure.newtonsPerMetersSquared.symbol,
        UnitPressure.hectopascals.symbol,
        UnitPressure.kilopascals.symbol,
        UnitPressure.poundsForcePerSquareInch.symbol,
        UnitPressure.millimetersOfMercury.symbol,
        UnitPressure.inchesOfMercury.symbol
    ]

    public let altitudeHeight = [
        UnitLength.millimeters.symbol,
        UnitLength.centimeters.symbol,
        UnitLength.meters.symbol,
        UnitLength.inches.symbol,
        UnitLength.feet.symbol,
        UnitLength.yards.symbol
    ]

    // MARK: - UserDefaults
    ///
    ///  Call this function to clear all UserDefaults
    ///
    public func clearUserDefaults() {

        var userSettings = fetchUserSettings()
        let releaseNotes = userSettings.showReleaseNotes
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        userSettings.showReleaseNotes = releaseNotes

        saveUserSettings(userSettings: userSettings)

        Log.shared.add(.userDefaults, .default, "Clear Userdefaults")
    }

    /// Read UserSettings
    ///
    /// This function returns UserSettings from UserDefaults and returns back standard settings if UserDefaults can't be fetched
    ///
    /// - Returns: UserSettings
    ///
    public func fetchUserSettings() -> UserSettings {

        var userSettings = UserSettings(
            showReleaseNotes: true,
            GPSSpeedSetting: "m/s",
            GPSAccuracySetting: "Best",
            frequencySetting: 1.0,
            pressureSetting: "kPa",
            altitudeHeightSetting: "m",
            graphMaxPoints: 150
        )

        if let settings = UserDefaults.standard.data(forKey: "UserSettings") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(UserSettings.self, from: settings) {
                userSettings = decoded
                Log.shared.print("Read Settings: \(userSettings)")
                Log.shared.add(.userDefaults, .default, "UserSettings fetched: \(userSettings)")
            } else {
                Log.shared.add(.userDefaults, .error, "UserSettings could not be fetched")
            }
        }

        /// Overwrite user settings in case of UI Testing
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
            userSettings = UserSettings(
                showReleaseNotes: true,
                GPSSpeedSetting: "m/s",
                GPSAccuracySetting: "Best",
                frequencySetting: 1.0,
                pressureSetting: "kPa",
                altitudeHeightSetting: "m",
                graphMaxPoints: 150
            )
            print("Testing in progress")
        }
        #endif

        return userSettings
    }

    /// Save UserSettings
    ///
    /// Save UserSettings to UserDefaults
    ///
    /// - Parameter userSettings: Settings to save to UserDefaults
    ///
    public func saveUserSettings(userSettings: UserSettings) {
        let encoder = JSONEncoder()
        let settings = userSettings

        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "UserSettings")
            Log.shared.print("Save Settings: \(settings)")
            Log.shared.add(.userDefaults, .default, "UserSettings saved: \(settings)")
        } else {
            Log.shared.add(.userDefaults, .error, "UserSettings could not be saved")
        }
    }

    /// Read MapKitSettings
    ///
    /// This function returns MapKitSettings from UserDefaults and returns back standard settings if MapKitSettings can't be fetched
    ///
    /// - Precondition:iOS
    /// - Returns: UserSettings
    ///
    @available(watchOS, unavailable)
    public func fetchMapKitSettings() -> MapKitSettings {
        var mapKitSettings = MapKitSettings(
            showsCompass: true,
            showsScale: true,
            showsBuildings: true,
            showsTraffic: true,
            isRotateEnabled: true,
            isScrollEnabled: true,
            mapType: .standard,
            zoom: 500
        )

        if let settings = UserDefaults.standard.data(forKey: "MapKitSettings") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(MapKitSettings.self, from: settings) {
                mapKitSettings = decoded
                Log.shared.add(.userDefaults, .default, "MapKitSettings fetched: \(mapKitSettings)")
            } else {
                Log.shared.add(.userDefaults, .error, "MapKitSettings could not be fetched")
            }
        }
        Log.shared.print("Read Settings: \(mapKitSettings)")

        return mapKitSettings
    }

    /// Save MapKitSettings
    ///
    /// Save MapKitSettings to UserDefaults
    ///
    /// - Precondition:iOS
    /// - Parameter mapKitSettings: Settings to save to UserDefaults
    ///
    @available(watchOS, unavailable)
    public func saveMapKitSettings(mapKitSettings: MapKitSettings) {
        let encoder = JSONEncoder()
        let settings = mapKitSettings

        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "MapKitSettings")
            Log.shared.add(.userDefaults, .default, "MapKitSettings saved: \(settings)")
        } else {
            Log.shared.add(.userDefaults, .error, "MapKitSettings could not be fsaved")
        }
        Log.shared.print("Save Settings: \(settings)")
    }

    // MARK: - Methods
    ///
    ///  Get  current timestamp
    ///
    ///  Get the current timestamp in dd-MM-yyyyy HH:mm:ss.SSS format
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Current timestamp
    ///
    public func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyyHHmmssSSS")
        let dateString = dateFormatter.string(from: NSDate() as Date)

        return dateString
    }
}
