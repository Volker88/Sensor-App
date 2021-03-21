//
//  SettingsViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import XCTest
@testable import Sensor_App

// MARK: - Class Definition
class SettingsViewUITests: BaseTestCase {
    func testSettingsSelection() throws {
        // Go to Settings View
        if UIDevice.current.userInterfaceIdiom == .phone {
            moveToView(view: "Settings")
        } else {
            app.navigationBars.buttons.element(boundBy: 0).tap()
            app.buttons["Settings"].tap()
        }

        // Select Speed Setting
        let tablesQuery = app.tables
        tablesQuery.buttons["Speed Settings"].tap()
        tablesQuery.buttons["km/h"].tap()

        // Select GPS Accuracy Setting
        tablesQuery.buttons["GPS Accuracy Settings"].tap()
        tablesQuery.buttons["3 Kilometer"].tap()

        // Map Settings
        //tablesQuery.buttons["MapType Picker"].tap()
        //tablesQuery.buttons["Satellite"].tap()
        //tablesQuery.switches["Compass Toggle"].tap()
        //tablesQuery.switches["Scale Toggle"].tap()
        //tablesQuery.switches["Buildings Toggle"].tap()
        //tablesQuery.switches["Traffic Toggle"].tap()

        //tablesQuery.switches["Satellite"].swipeUp()

        //tablesQuery.switches["Rotate Toggle"].tap()
        //tablesQuery.switches["Scroll Toggle"].tap()
        tablesQuery.sliders["Zoom Slider"].adjust(toNormalizedSliderPosition: 0.1)
        tablesQuery.sliders["Zoom Slider"].adjust(toNormalizedSliderPosition: 0.9)
        tablesQuery.otherElements["Zoom Stepper"].tap()

        // Select Pressure Setting
        tablesQuery.buttons["Pressure Settings"].tap()
        tablesQuery.buttons["bar"].tap()

        // Select Height Setting
        tablesQuery.buttons["Height Settings"].tap()
        tablesQuery.buttons["ft"].tap()

        // Graph Settings
        tablesQuery.sliders["Max Points Slider"].adjust(toNormalizedSliderPosition: 0.1)
        tablesQuery.sliders["Max Points Slider"].adjust(toNormalizedSliderPosition: 0.9)

        // Save Settings
        tablesQuery.buttons["Save"].tap()
        tablesQuery.buttons["Discard"].tap()

        // Go Back to Main Menu
        app.buttons["Close"].tap()
    }
}
