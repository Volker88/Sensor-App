//
//  ScreenshotUITests.swift
//  Sensor-AppwatchOSUITests
//
//  Created by Volker Schmitt on 04.10.2024.
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

        app.collectionViews["Navigation"].buttons["Location"].swipeDown()

        // Take Screenshot of Home View
        takeScreenshotOfCurrentView(name: "0Home")

        // Switch to Location View
        app.collectionViews["Navigation"].buttons["Location"].tap()

        // Take Screenshot of Location and go back to Home
        takeScreenshotOfCurrentView(name: "1Location")
        backToHomeMenu()

        // Go to Acceleration View and take Screenshot
        app.collectionViews["Navigation"].buttons["Acceleration"].tap()
        takeScreenshotOfCurrentView(name: "2Acceleration")

        backToHomeMenu()

        // Swipe up to Settings
        app.collectionViews["Navigation"].buttons.firstMatch.swipeUp()

        // Go to Settings View and take Screenshot
        app.collectionViews["Navigation"].buttons["Settings"].tap()

        takeScreenshotOfCurrentView(name: "4Settings")
    }

    func takeScreenshotOfCurrentView(name: String, delay: UInt32 = 1) {
        sleep(delay)

        let fullScreenshot = XCUIScreen.main.screenshot()

        let screenshot = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "\(String(getLanguageISO()))_\(name)-AppleWatch.png",
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
