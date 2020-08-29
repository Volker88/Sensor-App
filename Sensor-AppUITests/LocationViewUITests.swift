//
//  LocationViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class LocationViewUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    // MARK: - Tests
    func testLocationViewToolbarButtons() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
    
        // Go to Location View
        moveToView(app: app, view: "Location")
        
        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    func testLocationViewGraphs() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        moveToView(app: app, view: "Location")
        
        // Show all Graphs
        app.buttons["Toggle Speed Graph"].tap()
        app.buttons["Toggle Direction Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Longitude Graph"].tap()
        app.buttons["Toggle Latitude Graph"].tap()
        
        // Hide all Graphs
        app.buttons["Toggle Latitude Graph"].tap()
        app.buttons["Toggle Longitude Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Direction Graph"].tap()
        app.buttons["Toggle Speed Graph"].tap()
        
        // Go Back to Main Menu
        backToHomeMenu(app: app)
    }
    
    func testLocationViewShareSheet() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        moveToView(app: app, view: "Location")
    
        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        
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
        app.tables.cells["Home"].buttons["Home"].tap()
    }
}
