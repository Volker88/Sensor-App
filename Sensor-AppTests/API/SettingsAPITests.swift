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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    // MARK: - Tests
    func testSaveAndReadFrequency() {
        //Given
        SettingsAPI.shared.saveFrequency(frequency: 50)
        
        //When
        let frequency = SettingsAPI.shared.fetchFrequency()
        
        //Then
        XCTAssertEqual(frequency, 50, "Frequency should be 50 but is \(frequency)")
    }
    
    func testSpeedSetting() {
        //Given
        SettingsAPI.shared.saveUserDefaultsString(input: "mph", setting: .GPSSpeedSetting)
        
        //When
        let speed = SettingsAPI.shared.fetchSpeedSetting()
        
        //Then
        XCTAssertEqual(speed, "mph", "Speed Setting should be mph but is \(speed)")
    }
    
    func testGPSAccuracySetting() {
        //Given
        SettingsAPI.shared.saveUserDefaultsString(input: "10 Meter", setting: .GPSAccuracySetting)
        
        //When
        let accuracy = SettingsAPI.shared.fetchGPSAccuracySetting()
        
        //Then
        XCTAssertEqual(accuracy, "10 Meter", "GPS Accuracy Setting should be 10 Meter but is \(accuracy)")
    }
    
    func testPressureSetting() {
        //Given
        SettingsAPI.shared.saveUserDefaultsString(input: "bar", setting: .pressureSetting)
        
        //When
        let pressure = SettingsAPI.shared.fetchPressureSetting()
        
        //Then
        XCTAssertEqual(pressure, "bar", "GPS Accuracy Setting should be 10 Meter but is \(pressure)")
    }
    
    func testHeightSetting() {
        //Given
        SettingsAPI.shared.saveUserDefaultsString(input: "cm", setting: .altitudeHeightSetting)
        
        //When
        let height = SettingsAPI.shared.fetchHeightSetting()
        
        //Then
        XCTAssertEqual(height, "cm", "GPS Accuracy Setting should be cm but is \(height)")
    }

    
    // MARK: - Methods
}
