//
//  ScreenshotUITests.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 01.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App


// MARK: - Class Definition
class ScreenshotUITests: XCTestCase {
    
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
    func testScreenshot() throws {
        // Start Application
        let app = XCUIApplication()
        app.launch()
        app.scrollViews.element.swipeDown()
        
        // Take Screenshot of Home View
        sleep(2)
        takeScreenshotOfCurrentView(name: "Home")
        
        // Switch to Location View
        app.buttons["Location"].tap()
        sleep(2)
        
        // Wait for Location Authorization and allow access
        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) -> Bool in
            let button = alert.buttons.element(boundBy: 0)
            if button.exists {
                button.tap()
                return true
            }
            return false
        }
        app.tap()
        
        // Show Speed Graph
        sleep(4)
        app.buttons["Toggle Speed Graph"].tap()
        
        // Take Screenshot of Location and go back to Home
        sleep(1)
        takeScreenshotOfCurrentView(name: "Location")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Reject App Store review request
        sleep(1)
        app.scrollViews.otherElements.buttons["Not Now"].tap()
        
        // Go to Acceleration View and take Screenshot
        app.buttons["Acceleration"].tap()
        
        // Show X-Axis Graph
        app.buttons["Toggle X-Axis Graph"].tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Acceleration")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Go to Settings View and take Screenshot
        app.buttons["Settings"].tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Settings")
        
        // Go Back to Main Menu
        app.navigationBars.buttons["Close Button"].tap()
    }
    
    
    // MARK: - Methods
    func takeScreenshotOfCurrentView(name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        let screenshot = XCTAttachment(uniformTypeIdentifier: "public.png", name: "\(String(getLanguageISO()))_AppStore-Screenshot-\(name)-\(UIDevice.current.name).png", payload: fullScreenshot.pngRepresentation, userInfo: nil)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
    
    func getLanguageISO() -> String {
      let locale = Locale.current.identifier
        return locale
    }
}
