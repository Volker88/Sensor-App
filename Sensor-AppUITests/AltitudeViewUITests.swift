//
//  AltitudeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class AltitudeViewUITests: XCTestCase {
    
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
    func testAltitudeViewToolbarButtons() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Altitude View
        moveToView(app: app, view: "Altitude")
        
        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()
        
        backToHomeMenu(app: app)
    }
    
    func testAltitudeViewGraphs() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Altitude View
        moveToView(app: app, view: "Altitude")
        
        // Show all Graphs
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Pressure Graph"].tap()
        
        // Hide all Graphs
        app.buttons["Toggle Pressure Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()
        
        backToHomeMenu(app: app)
    }
    
    func testAltitudeViewShareSheet() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Altitude View
        moveToView(app: app, view: "Altitude")
        
        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        
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
        app.tables.cells["Home"].buttons["Home"].tap()
    }
}
