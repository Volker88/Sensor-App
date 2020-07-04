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
    func testLocationViewTabBarButtons() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Location"].tap()
        
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
    
    func testLocationViewGraphs() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Location"].tap()
        
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
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testLocationViewShareSheet() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Location"].tap()
    
        // Open / Close Share Sheet
        app/*@START_MENU_TOKEN@*/.buttons["Share Button"]/*[[".buttons[\"Share\"]",".buttons[\"Share Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(1)
        app/*@START_MENU_TOKEN@*/.navigationBars["UIActivityContentView"]/*[[".otherElements[\"ActivityListView\"].navigationBars[\"UIActivityContentView\"]",".navigationBars[\"UIActivityContentView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Close"].tap()
        
        // Go Back to Main Menu
        sleep(1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    
    // MARK:  - Methods
}
