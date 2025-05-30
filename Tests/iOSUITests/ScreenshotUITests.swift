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

    override func setUp() async throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing", "enable-screenshot-testing", "disable-animations"]
        app.launch()

        // Clear User Defaults
        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        #if os(iOS)
            if isIPad() {
                XCUIDevice.shared.orientation = .landscapeLeft
            } else if isIPhone() {
                XCUIDevice.shared.orientation = .portrait
            }
        #endif

    }

    func testScreenshot() throws {

        // Wait for Motion Authorization and allow access
        addUIInterruptionMonitor(withDescription: "Motion Dialog") { (alert) -> Bool in
            let button = alert.buttons.element(boundBy: 0)
            if button.exists {
                button.tap()
                return true
            }
            return false
        }

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
        let collection = app.collectionViews[UIIdentifiers.Sidebar.collectionView]
        collection.buttons[UIIdentifiers.Sidebar.locationButton].tap()

        // Show Speed Graph
        app.buttons[UIIdentifiers.LocationView.speedRow].tap()

        // Take Screenshot of Location and go back to Home
        takeScreenshotOfCurrentView(name: "1Location")
        backToHomeMenu()

        // Go to Acceleration View and take Screenshot
        collection.buttons[UIIdentifiers.Sidebar.accelerationButton].tap()

        // Show X-Axis Graph
        app.buttons[UIIdentifiers.AccelerationView.xAxisRow].tap()
        takeScreenshotOfCurrentView(name: "2Acceleration")

        // Go to Acceleration Log and take Screenshot
        app.buttons[UIIdentifiers.AccelerationView.logButton].tap()
        takeScreenshotOfCurrentView(name: "3Acceleration_Log")

        backToHomeMenu()
        backToHomeMenu()

        // Go to Settings View and take Screenshot
        collection.buttons[UIIdentifiers.Sidebar.settingsButton].tap()

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
