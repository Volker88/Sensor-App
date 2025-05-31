//
//  BaseTestCase.swift
//  Sensor-AppwatchOSUITests
//
//  Created by Volker Schmitt on 04.10.2024.
//

import XCTest

@MainActor
class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUp() async throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()

        // Clear User Defaults
        // swiftlint:disable:next force_unwrapping
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }

    override func tearDown() async throws {
    }

    func backToHomeMenu() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
}
