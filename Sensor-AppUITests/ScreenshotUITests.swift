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
class ScreenshotUITests: BaseTestCase {
    func testScreenshot() throws {
        // Take Screenshot of Home View
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Home")

        // Switch to Location View
        app.tables["Sidebar"].buttons.element(boundBy: 1).tap()
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
        backToHomeMenu()

        // Reject App Store review request
        //        sleep(1)
        //        let button = app.scrollViews.otherElements.buttons["Not Now"]
        //        if button.exists {
        //            button.tap()
        //        }

        // Go to Acceleration View and take Screenshot
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(2)
        app.tables["Sidebar"].buttons.element(boundBy: 2).tap()

        // Show X-Axis Graph
        app.buttons["Toggle X-Axis Graph"].tap()
        sleep(2)
        takeScreenshotOfCurrentView(name: "Acceleration")
        backToHomeMenu()

        // Go to Settings View and take Screenshot
        sleep(1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)

        if UIDevice.current.userInterfaceIdiom == .phone {
            app.tables["Sidebar"].buttons.element(boundBy: 8).tap()
        } else {
            app.buttons["Settings"].tap()
        }

        sleep(2)
        takeScreenshotOfCurrentView(name: "Settings")

        // Go Back to Main Menu
        //app.navigationBars.buttons.element(boundBy: 0).tap()
    }

    // MARK: - Methods
    func takeScreenshotOfCurrentView(name: String) {
        let fullScreenshot = XCUIScreen.main.screenshot()

        let screenshot = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "\(String(getLanguageISO()))_AppStore-Screenshot-\(name)-\(UIDevice.current.name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil
        )
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func getLanguageISO() -> String {
        let locale = Locale.current.identifier
        return locale
    }
}
