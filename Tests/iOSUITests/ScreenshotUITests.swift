//
//  ScreenshotUITests.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 01.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import XCTest

@MainActor
class ScreenshotUITests: BaseTestCase {

    func testScreenshot() throws {
        launchApp()

        // Wait for Location Authorization and allow access
        addUIInterruptionMonitor(withDescription: "Location Dialog") { (alert) -> Bool in
            let button = alert.buttons.element(boundBy: 0)
            if button.exists {
                button.tap()
                return true
            }
            return false
        }

        // Take Screenshot of Home View
        takeScreenshotOfCurrentView(name: "0Home")

        // Switch to Location View
        app.collectionViews["Sidebar"].buttons["Location"].tap()

        // Show Speed Graph
        app.buttons["Toggle Latitude Graph"].tap()

        // Take Screenshot of Location and go back to Home
        takeScreenshotOfCurrentView(name: "1Location")
        backToHomeMenu()

        // Go to Acceleration View and take Screenshot
        app.collectionViews["Sidebar"].buttons["Acceleration"].tap()

        // Show X-Axis Graph
        app.buttons["Toggle X-Axis Graph"].tap()
        takeScreenshotOfCurrentView(name: "2Acceleration")

        // Go to Acceleration Log and take Screenshot
        app.buttons["Log"].tap()
        takeScreenshotOfCurrentView(name: "3Acceleration_Log")

        backToHomeMenu()
        backToHomeMenu()

        // Go to Settings View and take Screenshot
        app.collectionViews["Sidebar"].buttons["Settings"].tap()

        takeScreenshotOfCurrentView(name: "4Settings")
    }

    func takeScreenshotOfCurrentView(name: String, delay: UInt32 = 1) {
        sleep(delay)

        let fullScreenshot = XCUIScreen.main.screenshot()

        let screenshot = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "\(String(getLanguageISO()))_\(name)-\(UIDevice.current.model).png",
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
