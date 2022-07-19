//
//  SettingsViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 15.05.21.
//

import SwiftUI

class SettingsViewModel: ObservableObject {

    @Published var currentAppIconIndex = 0
    @Published var userSettings: UserSettings
    @Published var mapSettings: MapKitSettings

    @Published var speedSetting = 0
    @Published var accuracySetting = 0
    @Published var pressureSetting = 0
    @Published var heightSetting = 0

    let settingsAPI = SettingsAPI()

    var iconNames: [String] = [ "AppIcon-V3", "AppIcon-V1", "AppIcon-V2"]

    init() {
        if let currentIcon = UIApplication.shared.alternateIconName {
            self.currentAppIconIndex = iconNames.firstIndex(of: currentIcon) ?? 0
        }
        userSettings = settingsAPI.fetchUserSettings()
        mapSettings = settingsAPI.fetchMapKitSettings()
    }

    func changeIcon(value: Int) {
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
    }

    func saveSettings() {
        userSettings.GPSSpeedSetting = settingsAPI.GPSSpeedSettings[speedSetting]
        userSettings.GPSAccuracySetting = settingsAPI.GPSAccuracyOptions[accuracySetting]
        userSettings.pressureSetting = settingsAPI.altitudePressure[pressureSetting]
        userSettings.altitudeHeightSetting = settingsAPI.altitudeHeight[heightSetting]

        settingsAPI.saveUserSettings(userSettings: userSettings)
        settingsAPI.saveMapKitSettings(mapKitSettings: mapSettings)
    }

    func discardChanges() {
        // swiftlint:disable line_length
        speedSetting = settingsAPI.GPSSpeedSettings.firstIndex(of: settingsAPI.fetchUserSettings().GPSSpeedSetting)!
        accuracySetting = settingsAPI.GPSAccuracyOptions.firstIndex(of: settingsAPI.fetchUserSettings().GPSAccuracySetting)!
        pressureSetting = settingsAPI.altitudePressure.firstIndex(of: settingsAPI.fetchUserSettings().pressureSetting)!
        heightSetting = settingsAPI.altitudeHeight.firstIndex(of: settingsAPI.fetchUserSettings().altitudeHeightSetting)!
        // swiftlint:enable line_length

        mapSettings = settingsAPI.fetchMapKitSettings()
        userSettings = settingsAPI.fetchUserSettings()
    }
}
