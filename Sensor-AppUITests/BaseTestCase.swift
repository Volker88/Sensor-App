//
//  BaseTestCase.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 21.03.21.
//

import XCTest
@testable import Sensor_App

class BaseTestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        // Clear User Defaults
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func moveToView(view: String) {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tables["Sidebar"].cells[view].buttons[view].tap()
    }

    func backToHomeMenu() {
        sleep(1)
        app.navigationBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        app.tables["Sidebar"].buttons.element(boundBy: 0).tap()
    }
}
