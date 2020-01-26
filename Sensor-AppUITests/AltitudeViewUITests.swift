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

        override func setUp() {
            // Put setup code here. This method is called before the invocation of each test method in the class.

            // In UI tests it is usually best to stop immediately when a failure occurs.
            continueAfterFailure = false

            // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
            XCUIApplication().launch()

            // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        }

        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        
        // MARK: - Tests
        func testAltitudeViewTabBarButtons() {
            // Start Application
            let app = XCUIApplication()
            app.launch()
            
            // Go to Location View
            app.buttons["Altitude"].tap()
            sleep(1)
            
            // Test TabBar Buttons
            app.buttons["Start Button"].tap()
            sleep(1)
            app.buttons["Pause Button"].tap()
            sleep(1)
            app.buttons["Delete Button"].tap()
            sleep(1)
            app.buttons["Settings Button"].tap()
            sleep(1)
            
            // Go Back to Main Menu
            app.buttons["Close Button"].tap()
            sleep(1)
            app.navigationBars.buttons.element(boundBy: 0).tap()
            sleep(1)
        }
        
        func testAltitudeViewGraphs() {
            // Start Application
            let app = XCUIApplication()
            app.launch()
            
            // Go to Location View
            app.buttons["Altitude"].tap()
            sleep(1)
            
            // Show all Graphs
            app.buttons["Toggle Altitude Graph"].tap()
            app.buttons["Toggle Pressure Graph"].tap()
            sleep(1)
            
            // Hide all Graphs
            app.buttons["Toggle Pressure Graph"].tap()
            app.buttons["Toggle Altitude Graph"].tap()
            
            // Go Back to Main Menu
            app.navigationBars.buttons.element(boundBy: 0).tap()
            sleep(1)
        }
        
    
        // MARK:  - Methods
    }
