//
//  AccelerationViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

@testable import Sensor_App

class AccelerationViewUITests: BaseTestCase {
    func testAccelerationViewToolbarButtons() throws {
        // Go to Acceleration View
        moveToView(view: "Acceleration")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["Play"].tap()
        toolbar.buttons["Pause"].tap()
        toolbar.buttons["Delete"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAccelerationViewGraphs() throws {
        // Go to Acceleration View
        moveToView(view: "Acceleration")

        // Show all Graphs
        app.buttons["Toggle Z-Axis Graph"].tap()
        app.buttons["Toggle Y-Axis Graph"].tap()
        app.buttons["Toggle X-Axis Graph"].tap()

        // Hide all Graphs
        app.buttons["Toggle X-Axis Graph"].tap()
        app.buttons["Toggle Y-Axis Graph"].tap()
        app.buttons["Toggle Z-Axis Graph"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAccelerationViewSlider() throws {
        // Go to Acceleration View
        moveToView(view: "Acceleration")

        // Swipe Up
        app.buttons["Toggle X-Axis Graph"].swipeUp()

        // Adjust Slider to 0% and then 100%
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders["Frequency Slider"].adjust(toNormalizedSliderPosition: 1.0)

        let updateFrequency = app.sliders["Frequency Slider"].value as! String  // swiftlint:disable:this force_cast
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "50", "Update frequency should be 50 but is \(splitUpdateFrequency)")

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAccelerationViewShareSheet() throws {
        // Go to Acceleration View
        moveToView(view: "Acceleration")
        app.buttons["Log"].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons["ExportButton"].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }
}
