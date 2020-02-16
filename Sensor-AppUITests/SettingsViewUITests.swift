//
//  SettingsViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class SettingsViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Tests
    func testSettingsSelection() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Settings View
        app.scrollViews.otherElements.buttons["Settings"].tap()
        
        // Select Speed Setting
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Speed Settings"]/*[[".cells",".buttons[\"Speed Setting\"]",".buttons[\"Speed Settings\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["km/h"]/*[[".cells.buttons[\"km\/h\"]",".buttons[\"km\/h\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Select GPS Accuracy Setting
        tablesQuery.buttons["GPS Accuracy Settings"].tap()
        tablesQuery.buttons["3 Kilometer"].tap()
        
        // Select Pressure Setting
        tablesQuery.buttons["Pressure Settings"].tap()
        tablesQuery.buttons["bar"].tap()
        
        // Select Height Setting
        tablesQuery.buttons["Height Settings"].tap()
        tablesQuery.buttons["ft"].tap()
        
        // Save Settings
        let settingsNavigationBar = app.navigationBars["Settings"]
        settingsNavigationBar/*@START_MENU_TOKEN@*/.buttons["Save Settings"]/*[[".buttons[\"SaveButton\"]",".buttons[\"Save Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Go Back to Main Menu
        settingsNavigationBar/*@START_MENU_TOKEN@*/.buttons["Close Button"]/*[[".buttons[\"clear\"]",".buttons[\"Close Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
    
    
    // MARK:  - Methods
}
