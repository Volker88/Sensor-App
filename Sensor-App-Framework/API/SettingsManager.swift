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

@Observable
public class SettingsManager {

    public var currentAppIconIndex = 0
    public var userSettings = UserSettings(
        showReleaseNotes: true,
        GPSSpeedSetting: "m/s",
        GPSAccuracySetting: "Best",
        frequencySetting: 1.0,
        pressureSetting: "kPa",
        altitudeHeightSetting: "m",
        graphMaxPoints: 150,
        locationAccuracySetting: UnitLength.meters.symbol
    )

    public var speedSetting = 0
    public var accuracySetting = 0
    public var pressureSetting = 0
    public var heightSetting = 0
    public var locationAccuracySetting = 0

    public let appIcons: [AppIcons] = [
        AppIcons(iconName: "AppIcon-V1", accessibilityName: "Satellite"),
        AppIcons(iconName: "AppIcon-V2", accessibilityName: "Sensor Wave"),
        AppIcons(iconName: "AppIcon-V3", accessibilityName: "Piezoelectric Sensor")
    ]

    public init() {
        userSettings = fetchUserSettings()
    }

    public func fetchCurrentAppIcon() {
        #if os(iOS)
            guard let defaultIcon = Bundle.main.object(forInfoDictionaryKey: "PRIMARY_APP_ICON") as? String else {
                return
            }

            if let currentIcon = UIApplication.shared.alternateIconName {
                // Find the index in your AppIcons array
                if let index = appIcons.firstIndex(where: { $0.iconName == currentIcon }) {
                    self.currentAppIconIndex = index
                } else {
                    // Fallback to default if not found
                    self.currentAppIconIndex = 0
                }
            } else {
                // Default app icon (nil means the primary icon)
                if let index = appIcons.firstIndex(where: { $0.iconName == defaultIcon }) {
                    self.currentAppIconIndex = index
                } else {
                    self.currentAppIconIndex = 0
                }
            }
        #endif
    }

    public func changeIcon(value: Int) {
        #if os(iOS)
            guard let defaultIcon = Bundle.main.object(forInfoDictionaryKey: "PRIMARY_APP_ICON") as? String else {
                return
            }
            guard value >= 0 && value < appIcons.count else {
                return
            }

            let targetName = appIcons[value].iconName

            // If it's already the current icon, just update the index and bail.
            if UIApplication.shared.alternateIconName == targetName {
                self.currentAppIconIndex = value
                return
            }

            Task { @MainActor in
                do {
                    if targetName == defaultIcon {
                        // Reset to primary icon
                        try await UIApplication.shared.setAlternateIconName(nil)
                        Logger.appIcon.info("Reset to primary icon")
                    } else {
                        try await UIApplication.shared.setAlternateIconName(targetName)
                        Logger.appIcon.info("Set alternate icon to: \(targetName)")
                    }

                    self.currentAppIconIndex = value
                } catch {
                    Logger.appIcon.error("Error setting alternate icon: \(error.localizedDescription)")
                }
            }
        #endif
    }

    public func saveSettings() {
        userSettings.GPSSpeedSetting = GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = altitudeHeight[heightSetting]
        userSettings.locationAccuracySetting = altitudeHeight[locationAccuracySetting]

        saveUserSettings(userSettings: userSettings)
    }

    public func discardChanges() {
        speedSetting = GPSSpeedSettings.firstIndex(of: userSettings.GPSSpeedSetting) ?? 0
        accuracySetting = GPSAccuracyOptions.firstIndex(of: userSettings.GPSAccuracySetting) ?? 0
        pressureSetting = altitudePressure.firstIndex(of: userSettings.pressureSetting) ?? 0
        heightSetting = altitudeHeight.firstIndex(of: userSettings.altitudeHeightSetting) ?? 0
        locationAccuracySetting = altitudeHeight.firstIndex(of: userSettings.locationAccuracySetting) ?? 0

        userSettings = fetchUserSettings()
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
            graphMaxPoints: 150,
            locationAccuracySetting: UnitLength.meters.symbol
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
                    graphMaxPoints: 150,
                    locationAccuracySetting: UnitLength.meters.symbol
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

    public func getTimestamp() -> String {
        Date().sensorTimestamp
    }
}

public struct AppIcons {
    public let iconName: String
    public let accessibilityName: LocalizedStringResource
}
