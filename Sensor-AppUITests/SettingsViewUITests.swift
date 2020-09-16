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
        moveToView(app: app, view: "Settings")
        
        // Select Speed Setting
        let tablesQuery = app.tables
        tablesQuery.buttons["Speed Settings"].tap()
        tablesQuery.buttons["km/h"].tap()
        
        // Select GPS Accuracy Setting
        tablesQuery.buttons["GPS Accuracy Settings"].tap()
        tablesQuery.buttons["3 Kilometer"].tap()
        
        // Map Settings
        tablesQuery.buttons["MapType Picker"].tap()
        tablesQuery.buttons["Satellite"].tap()
        //tablesQuery.switches["Compass Toggle"].tap()
        //tablesQuery.switches["Scale Toggle"].tap()
        //tablesQuery.switches["Buildings Toggle"].tap()
        //tablesQuery.switches["Traffic Toggle"].tap()
        
        //tablesQuery.switches["Satellite"].swipeUp()
        
        //tablesQuery.switches["Rotate Toggle"].tap()
        //tablesQuery.switches["Scroll Toggle"].tap()
        tablesQuery.sliders["Zoom Slider"].adjust(toNormalizedSliderPosition: 0.1)
        tablesQuery.sliders["Zoom Slider"].adjust(toNormalizedSliderPosition: 0.9)
        tablesQuery.otherElements["Zoom Stepper"].tap()
        
        // Select Pressure Setting
        tablesQuery.buttons["Pressure Settings"].tap()
        tablesQuery.buttons["bar"].tap()
        
        // Select Height Setting
        tablesQuery.buttons["Height Settings"].tap()
        tablesQuery.buttons["ft"].tap()
        
        // Graph Settings
        tablesQuery.sliders["Max Points Slider"].adjust(toNormalizedSliderPosition: 0.1)
        tablesQuery.sliders["Max Points Slider"].adjust(toNormalizedSliderPosition: 0.9)
        
        // Save Settings
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons.element(boundBy: 0).tap()
        toolbar.buttons.element(boundBy: 1).tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    
    // MARK:  - Methods
    func moveToView(app: XCUIApplication, view: String) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tables.cells[view].buttons[view].tap()
    }
    
    func backToHomeMenu(app: XCUIApplication) {
        sleep(1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        app.tables.buttons.element(boundBy: 0)
    }
}
