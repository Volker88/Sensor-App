//
//  SettingsViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

@testable import Sensor_App

class SettingsViewUITests: BaseTestCase {
    func testSettingsSelection() throws {
        // Go to Settings View
        moveToView(view: "Settings")

        // Select Speed Setting
        let tablesQuery = app.collectionViews
        tablesQuery.buttons["Speed Settings"].tap()
        tablesQuery.buttons["km/h"].tap()

        // Select GPS Accuracy Setting
        tablesQuery.buttons["GPS Accuracy Settings"].tap()
        tablesQuery.buttons["3 Kilometer"].tap()

        // Map Settings
        // tablesQuery.buttons["MapType Picker"].tap()
        // tablesQuery.buttons["Satellite"].tap()
        // tablesQuery.switches["Compass Toggle"].tap()
        // tablesQuery.switches["Scale Toggle"].tap()
        // tablesQuery.switches["Buildings Toggle"].tap()
        // tablesQuery.switches["Traffic Toggle"].tap()

        // tablesQuery.switches["Satellite"].swipeUp()

        // tablesQuery.switches["Rotate Toggle"].tap()
        // tablesQuery.switches["Scroll Toggle"].tap()

        tablesQuery.staticTexts["Map"].swipeUp()
        tablesQuery.staticTexts["Map"].swipeUp()

        tablesQuery.steppers["Zoom Stepper"].buttons["Zoom Stepper-Increment"].tap()
        tablesQuery.steppers["Zoom Stepper"].buttons["Zoom Stepper-Decrement"].tap()

        // Select Pressure Setting
        tablesQuery.buttons["Pressure Settings"].tap()
        tablesQuery.buttons["bar"].tap()

        // Select Height Setting
        tablesQuery.buttons["Height Settings"].tap()
        tablesQuery.buttons["ft"].tap()

        // Graph Settings
        tablesQuery.steppers["Max Points Stepper"].buttons["Max Points Stepper-Increment"].tap()
        tablesQuery.steppers["Max Points Stepper"].buttons["Max Points Stepper-Decrement"].tap()

        // Save Settings
        tablesQuery.buttons["Save"].tap()
        tablesQuery.buttons["Discard"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
