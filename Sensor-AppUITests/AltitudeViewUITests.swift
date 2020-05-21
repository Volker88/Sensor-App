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
        func testAltitudeViewTabBarButtons() throws {
            // Start Application
            let app = XCUIApplication()
            app.launch()
            
            // Go to Location View
            app.buttons["Altitude"].tap()
            
            // Test TabBar Buttons
            app.buttons["Start Button"].tap()
            app.buttons["Pause Button"].tap()
            app.buttons["Delete Button"].tap()
            app.buttons["Settings Button"].tap()
            
            // Go Back to Main Menu
            sleep(1)
            app.navigationBars.buttons["Close Button"].tap()
            sleep(1)
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
        func testAltitudeViewGraphs() throws {
            // Start Application
            let app = XCUIApplication()
            app.launch()
            
            // Go to Location View
            app.buttons["Altitude"].tap()
            
            // Show all Graphs
            app.buttons["Toggle Altitude Graph"].tap()
            app.buttons["Toggle Pressure Graph"].tap()
            
            // Hide all Graphs
            app.buttons["Toggle Pressure Graph"].tap()
            app.buttons["Toggle Altitude Graph"].tap()
            
            // Go Back to Main Menu
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
        
    
        // MARK:  - Methods
    }
