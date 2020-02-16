//
//  SettingsAPITests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 27.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class SettingsAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // MARK: - Tests
    func testSaveAndReadFrequency() throws {
        //Given
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.frequencySetting = 50
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        //When
        let frequency = SettingsAPI.shared.fetchUserSettings().frequencySetting
        
        //Then
        XCTAssertEqual(frequency, 50, "Frequency should be 50 but is \(frequency)")
    }
    
    func testSpeedSetting() throws {
        //Given
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.GPSSpeedSetting = "mph"
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        //When
        let speed = SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting
        
        //Then
        XCTAssertEqual(speed, "mph", "Speed Setting should be mph but is \(speed)")
    }
    
    func testGPSAccuracySetting() throws {
        //Given
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.GPSAccuracySetting = "10 Meter"
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        //When
        let accuracy = SettingsAPI.shared.fetchUserSettings().GPSAccuracySetting
        
        //Then
        XCTAssertEqual(accuracy, "10 Meter", "GPS Accuracy Setting should be 10 Meter but is \(accuracy)")
    }
    
    func testPressureSetting() throws {
        //Given
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.pressureSetting = "bar"
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        //When
        let pressure = SettingsAPI.shared.fetchUserSettings().pressureSetting
        
        //Then
        XCTAssertEqual(pressure, "bar", "GPS Accuracy Setting should be 10 Meter but is \(pressure)")
    }
    
    func testHeightSetting() throws {
        //Given
        var settings = SettingsAPI.shared.fetchUserSettings()
        settings.altitudeHeightSetting = "cm"
        SettingsAPI.shared.saveUserSettings(userSettings: settings)
        
        //When
        let height = SettingsAPI.shared.fetchUserSettings().altitudeHeightSetting
        
        //Then
        XCTAssertEqual(height, "cm", "GPS Accuracy Setting should be cm but is \(height)")
    }

    
    // MARK: - Methods
}
