//
//  BaseTestCase.swift
//  Sensor-AppwatchOSUITests
//
//  Created by Volker Schmitt on 04.10.2024.
//

import XCTest
@testable import Sensor_App_Watch

@MainActor
class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Clear User Defaults
        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
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
            app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
