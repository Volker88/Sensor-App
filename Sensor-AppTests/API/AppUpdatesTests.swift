//
//  AppUpdatesTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 01.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class AppUpdatesTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Tests
    func testAppUpdates() throws {
        //Given
        let appUpdates = AppUpdates()
        UserDefaults.standard.removeObject(forKey: "upToDate")
        appUpdates.checkForUpdate()
        
        //When
        let upToDate = UserDefaults.standard.bool(forKey: "upToDate")
        let userDefaultsForSpeedSetting = UserDefaults.standard.string(forKey: "\(SettingsForUserDefaults.GPSSpeedSetting)")
        
        //Then
        XCTAssertTrue(upToDate, "App Update hasn't been updated")
        XCTAssertNil(userDefaultsForSpeedSetting, "UserDefaults are still present")
    }
    
    
    // MARK: - Methods
}
