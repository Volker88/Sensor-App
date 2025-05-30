//
//  AttitudeViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class AttitudeViewUITests: BaseTestCase {
    func testAttitudeViewToolbarButtons() throws {
        // Go to Attitude View
        moveToView(UIIdentifiers.Sidebar.attitudeButton)

        // Test Toolbar Buttons
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()
        app.buttons[UIIdentifiers.Toolbar.pauseButton].tap()
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewGraphs() throws {
        // Go to Attitude View
        moveToView(UIIdentifiers.Sidebar.attitudeButton)

        // Show all Graphs
        app.buttons[UIIdentifiers.AttitudeView.headingRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.yawRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.pitchRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.rollRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.AttitudeView.rollRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.pitchRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.yawRow].tap()
        app.buttons[UIIdentifiers.AttitudeView.headingRow].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewSlider() throws {
        // Go to Attitude View
        moveToView(UIIdentifiers.Sidebar.attitudeButton)

        // Swipe Up
        app.buttons[UIIdentifiers.AttitudeView.rollRow].swipeUp()

        // Adjust Slider to 0% and then 100%
        app.sliders[UIIdentifiers.RefreshRateView.refreshRateSlider].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders[UIIdentifiers.RefreshRateView.refreshRateSlider].adjust(toNormalizedSliderPosition: 1.0)

        let slider = UIIdentifiers.RefreshRateView.refreshRateSlider
        let updateFrequency = app.sliders[slider].value as! String  // swiftlint:disable:this force_cast
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "50", "Update frequency should be 50 but is \(splitUpdateFrequency)")

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAttitudeViewShareSheet() throws {
        // Go to Attitude View
        moveToView(UIIdentifiers.Sidebar.attitudeButton)
        app.buttons[UIIdentifiers.AttitudeView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.AttitudeList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }
}
