//
//  AttitudeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class AttitudeViewUITests: BaseTestCase {
    func testAttitudeViewToolbarButtons() throws {
        // Go to Attitude View
        moveToView(view: "Attitude")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewGraphs() throws {
        // Go to Attitude View
        moveToView(view: "Attitude")

        // Show all Graphs
        app.buttons["Toggle Heading Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Roll Graph"].tap()

        // Hide all Graphs
        app.buttons["Toggle Roll Graph"].tap()
        app.buttons["Toggle Pitch Graph"].tap()
        app.buttons["Toggle Yaw Graph"].tap()
        app.buttons["Toggle Heading Graph"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewSlider() throws {
        // Go to Attitude View
        moveToView(view: "Attitude")

        // Swipe Up
        app.buttons["Toggle Roll Graph"].swipeUp()

        // Adjust Slider to 0% and then 100%
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 1.0)

        let updateFrequency = app.sliders["Frequency Slider"].value as! String // swiftlint:disable:this force_cast
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "10.0", "Update frequency should be 50 but is \(splitUpdateFrequency)")

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewShareSheet() throws {
        // Go to Attitude View
        moveToView(view: "Attitude")

        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
