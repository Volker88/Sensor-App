//
//  BaseTestCase.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 21.03.21.
//

import XCTest

@testable import Sensor_App

@MainActor
class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Clear User Defaults
        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        MainActor.assumeIsolated {
            if isIPad() {
                XCUIDevice.shared.orientation = .landscapeLeft
            } else if isIPhone() {
                XCUIDevice.shared.orientation = .portrait
            }
        }

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func launchApp() {
        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func moveToView(view: String) {
        launchApp()
        app.collectionViews["Sidebar"].buttons[view].tap()
    }

    func backToHomeMenu() {
        if isIPhone() {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }

    func dismissShareSheet() {
        if isIPhone() {
            app.navigationBars["UIActivityContentView"].buttons["Close"].tap()
        } else {
            app.otherElements["PopoverDismissRegion"].tap()
        }
    }
}
