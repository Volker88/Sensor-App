//
//  SettingsAPITests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 27.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class SettingsAPITests: XCTestCase {
    let settingsAPI = SettingsAPI()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveAndReadFrequency() throws {
        // Given
        var settings = settingsAPI.fetchUserSettings()
        settings.frequencySetting = 50
        settingsAPI.saveUserSettings(userSettings: settings)

        // When
        let frequency = settingsAPI.fetchUserSettings().frequencySetting

        // Then
        XCTAssertEqual(frequency, 50, "Frequency should be 50 but is \(frequency)")
    }

    func testSpeedSetting() throws {
        // Given
        var settings = settingsAPI.fetchUserSettings()
        settings.GPSSpeedSetting = "mph"
        settingsAPI.saveUserSettings(userSettings: settings)

        // When
        let speed = settingsAPI.fetchUserSettings().GPSSpeedSetting

        // Then
        XCTAssertEqual(speed, "mph", "Speed Setting should be mph but is \(speed)")
    }

    func testGPSAccuracySetting() throws {
        // Given
        var settings = settingsAPI.fetchUserSettings()
        settings.GPSAccuracySetting = "10 Meter"
        settingsAPI.saveUserSettings(userSettings: settings)

        // When
        let accuracy = settingsAPI.fetchUserSettings().GPSAccuracySetting

        // Then
        XCTAssertEqual(accuracy, "10 Meter", "GPS Accuracy Setting should be 10 Meter but is \(accuracy)")
    }

    func testPressureSetting() throws {
        // Given
        var settings = settingsAPI.fetchUserSettings()
        settings.pressureSetting = "bar"
        settingsAPI.saveUserSettings(userSettings: settings)

        // When
        let pressure = settingsAPI.fetchUserSettings().pressureSetting

        // Then
        XCTAssertEqual(pressure, "bar", "GPS Accuracy Setting should be 10 Meter but is \(pressure)")
    }

    func testHeightSetting() throws {
        // Given
        var settings = settingsAPI.fetchUserSettings()
        settings.altitudeHeightSetting = "cm"
        settingsAPI.saveUserSettings(userSettings: settings)

        // When
        let height = settingsAPI.fetchUserSettings().altitudeHeightSetting

        // Then
        XCTAssertEqual(height, "cm", "GPS Accuracy Setting should be cm but is \(height)")
    }
}
