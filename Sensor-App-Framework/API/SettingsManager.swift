//
//  SettingsModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 06.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import OSLog
import SwiftUI

@MainActor
@Observable
class SettingsManager {

    var currentAppIconIndex = 0
    var userSettings = UserSettings(
        showReleaseNotes: true,
        GPSSpeedSetting: "m/s",
        GPSAccuracySetting: "Best",
        frequencySetting: 1.0,
        pressureSetting: "kPa",
        altitudeHeightSetting: "m",
        graphMaxPoints: 150
    )

    var mapSettings = MapKitSettings(
        showsCompass: true,
        showsScale: true,
        showsBuildings: true,
        showsTraffic: true,
        isRotateEnabled: true,
        isPitchEnabled: true,
        isScrollEnabled: true,
        mapType: .standard,
        zoom: 500
    )

    var speedSetting = 0
    var accuracySetting = 0
    var pressureSetting = 0
    var heightSetting = 0

    let iconNames: [String] = ["AppIcon-V3", "AppIcon-V1", "AppIcon-V2"]

    init() {
        #if os(iOS)
            if let currentIcon = UIApplication.shared.alternateIconName {
                self.currentAppIconIndex = iconNames.firstIndex(of: currentIcon) ?? 0
            }
        #endif

        userSettings = fetchUserSettings()

        #if os(iOS)
            mapSettings = fetchMapKitSettings()
        #endif
    }

    func changeIcon(value: Int) {
        #if os(iOS)
            let index = iconNames.firstIndex(of: UIApplication.shared.alternateIconName ?? "Default") ?? 0

            if value == 0 {
                UIApplication.shared.setAlternateIconName(nil)
            }

            if index != value {
                UIApplication.shared.setAlternateIconName(iconNames[value]) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Success!")
                    }
                }
            }
        #endif
    }

    func saveSettings() {
        userSettings.GPSSpeedSetting = GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = altitudeHeight[heightSetting]

        saveUserSettings(userSettings: userSettings)
        #if os(iOS)
            saveMapKitSettings(mapKitSettings: mapSettings)
        #endif
    }

    func discardChanges() {
        speedSetting = GPSSpeedSettings.firstIndex(of: userSettings.GPSSpeedSetting) ?? 0
        accuracySetting = GPSAccuracyOptions.firstIndex(of: userSettings.GPSAccuracySetting) ?? 0
        pressureSetting = altitudePressure.firstIndex(of: userSettings.pressureSetting) ?? 0
        heightSetting = altitudeHeight.firstIndex(of: userSettings.altitudeHeightSetting) ?? 0

        userSettings = fetchUserSettings()
        #if os(iOS)
            mapSettings = fetchMapKitSettings()
        #endif
    }

    public let GPSSpeedSettings = [
        UnitSpeed.metersPerSecond.symbol,
        UnitSpeed.kilometersPerHour.symbol,
        UnitSpeed.milesPerHour.symbol,
        UnitSpeed.knots.symbol
    ]

    public let GPSAccuracyOptions = ["Best", "10 Meter", "100 Meter", "Kilometer", "3 Kilometer"]

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

    ///  Call this function to clear all UserDefaults
    public func clearUserDefaults() {
        var userSettings = fetchUserSettings()
        let releaseNotes = userSettings.showReleaseNotes

        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        userSettings.showReleaseNotes = releaseNotes

        saveUserSettings(userSettings: userSettings)

        Logger.userDefaults.debug("Clear Userdefaults")
    }

    /// Read UserSettings
    ///
    /// This function returns UserSettings from UserDefaults and returns back standard settings if UserDefaults can't be fetched
    /// - Returns: UserSettings
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
            } else {
                Logger.userDefaults.error("UserSettings could not be fetched")
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
    /// - Parameter userSettings: Settings to save to UserDefaults
    public func saveUserSettings(userSettings: UserSettings) {
        self.userSettings = userSettings

        let encoder = JSONEncoder()
        let settings = userSettings

        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "UserSettings")
        } else {
            Logger.userDefaults.error("UserSettings could not be saved")
        }
    }

    /// Read MapKitSettings
    ///
    /// This function returns MapKitSettings from UserDefaults and returns back standard settings if MapKitSettings can't be fetched
    /// - Precondition:iOS
    /// - Returns: UserSettings
    @available(watchOS, unavailable)
    public func fetchMapKitSettings() -> MapKitSettings {
        var mapKitSettings = MapKitSettings(
            showsCompass: true,
            showsScale: true,
            showsBuildings: true,
            showsTraffic: true,
            isRotateEnabled: true,
            isPitchEnabled: true,
            isScrollEnabled: true,
            mapType: .standard,
            zoom: 500
        )

        if let settings = UserDefaults.standard.data(forKey: "MapKitSettings") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(MapKitSettings.self, from: settings) {
                mapKitSettings = decoded
            } else {
                Logger.userDefaults.error("MapKitSettings could not be fetched")
            }
        }

        return mapKitSettings
    }

    /// Save MapKitSettings
    ///
    /// Save MapKitSettings to UserDefaults
    /// - Precondition:iOS
    /// - Parameter mapKitSettings: Settings to save to UserDefaults
    @available(watchOS, unavailable)
    public func saveMapKitSettings(mapKitSettings: MapKitSettings) {
        self.mapSettings = mapKitSettings

        let encoder = JSONEncoder()
        let settings = mapKitSettings

        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "MapKitSettings")
        } else {
            Logger.userDefaults.error("MapKitSettings could not be fsaved")
        }
    }

    ///  Get  current timestamp
    ///
    ///  Get the current timestamp in dd-MM-yyyyy HH:mm:ss.SSS format
    ///  - Returns: Current timestamp
    public func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyyHHmmssSSS")
        let dateString = dateFormatter.string(from: NSDate() as Date)

        return dateString
    }
}
