//
//  ScreenshotUITests.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 01.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App


class ScreenshotUITests: XCTestCase {

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
    func testScreenshot() {
        
        // Start Application
        let app = XCUIApplication()
        app.launch()
        app.scrollViews.otherElements.buttons.element(boundBy: 0).swipeDown()

    
        // Take Screenshot of Home View
        sleep(2)
        takeScreenshotOfCurrentView(name: "Home")
        
        // Switch to Location View
        app.buttons.element(boundBy: 0).tap()
        sleep(2)
        
        // Wait for Location Authorization and allow access
        // English
        addUIInterruptionMonitor(withDescription: "Darf „Sensor-App“ auf deinen Standort zugreifen?") { (alert) -> Bool in
            let button = alert.buttons["Allow While Using App"]
            if button.exists {
                button.tap()
                return true
            }
            return false
        }
        
        // German
        addUIInterruptionMonitor(withDescription: "Allow “Sensor-App” to access your location?") { (alert) -> Bool in
            let button = alert.buttons["Beim Verwenden der App erlauben"]
            if button.exists {
                button.tap()
                return true
            }
            return false
        }
        app.tap()
        
        // Take Screenshot of Location and go back to Home
        sleep(4)
        takeScreenshotOfCurrentView(name: "Location")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Go to Acceleration View and take Screenshot
        app.buttons.element(boundBy: 1).tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Acceleration")
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Go to Settings View and take Screenshot
        app.buttons.element(boundBy: 7).tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Settings")
    }
    
    
    // MARK: - Methods
    func takeScreenshotOfCurrentView(name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        let screenshot = XCTAttachment(uniformTypeIdentifier: "public.png", name: "AppStore-Screenshot-\(name)-\(UIDevice.current.name).png", payload: fullScreenshot.pngRepresentation, userInfo: nil)
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }
}
