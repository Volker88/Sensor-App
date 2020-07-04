//
//  AttitudeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class AttitudeViewUITests: XCTestCase {
    
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
    func testAttitudeViewTabBarButtons() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Attitude"].tap()
        
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
    
    func testAttitudeViewGraphs() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Attitude"].tap()
        
        // Show all Graphs
        app.buttons["Toggle Heading Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Roll Graph"].tap()
        
        // Hide all Graphs
        app.buttons["Toggle Roll Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Heading Graph"].tap()
        
        // Go Back to Main Menu
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testAttitudeViewSlider() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Attitude"].tap()
        
        // Swipe Up
        app.buttons["Toggle Roll Graph"].swipeUp()
        
        // Adjust Slider to 0% and then 100%
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 1.0)
        
        let updateFrequency = app.sliders["Frequency Slider"].value as! String
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "50", "Update frequency should be 50 but is \(splitUpdateFrequency)")
        
        // Go Back to Main Menu
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func testAttitudeViewShareSheet() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        
        // Go to Location View
        app.buttons["Attitude"].tap()
    
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
