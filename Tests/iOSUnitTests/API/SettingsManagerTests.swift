//
//  SettingsManagerTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 27.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation
import Sensor_App_Framework
import Testing

@testable import Sensor_App

@MainActor
final class SettingsManagerTests: BaseTestCase {

    // MARK: - Testing Methods
    @Test("Save and read frequency")
    func saveAndReadFrequency() throws {
        var settings = settingsManager.fetchUserSettings()
        settings.frequencySetting = 50
        settingsManager.saveUserSettings(userSettings: settings)

        let frequency = settingsManager.fetchUserSettings().frequencySetting

        #expect(frequency == 50)
    }

    @Test("Save and read speed setting")
    func speedSetting() throws {
        var settings = settingsManager.fetchUserSettings()
        settings.GPSSpeedSetting = "mph"
        settingsManager.saveUserSettings(userSettings: settings)

        let speed = settingsManager.fetchUserSettings().GPSSpeedSetting

        #expect(speed == "mph")
    }

    @Test("Save and read GPS accuracy setting")
    func GPSAccuracySetting() throws {
        var settings = settingsManager.fetchUserSettings()
        settings.GPSAccuracySetting = "10 Meter"
        settingsManager.saveUserSettings(userSettings: settings)

        let accuracy = settingsManager.fetchUserSettings().GPSAccuracySetting

        #expect(accuracy == "10 Meter")
    }

    @Test("Save and read pressure setting")
    func pressureSetting() throws {
        var settings = settingsManager.fetchUserSettings()
        settings.pressureSetting = "bar"
        settingsManager.saveUserSettings(userSettings: settings)

        let pressure = settingsManager.fetchUserSettings().pressureSetting

        #expect(pressure == "bar")
    }

    @Test("Save and read height setting")
    func heightSetting() throws {
        var settings = settingsManager.fetchUserSettings()
        settings.altitudeHeightSetting = "cm"
        settingsManager.saveUserSettings(userSettings: settings)

        let height = settingsManager.fetchUserSettings().altitudeHeightSetting

        #expect(height == "cm")
    }
}
