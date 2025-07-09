//
//  AccelerationViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class AccelerationViewUITests: BaseTestCase {
    func testAccelerationViewToolbarButtons() throws {
        // Go to Acceleration View
        goToAccelerationScreen()

        // Test CustomControlsView Buttons
        app.buttons[UIIdentifiers.CustomControlsView.expandButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.playButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.pauseButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAccelerationViewGraphs() throws {
        // Go to Acceleration View
        goToAccelerationScreen()

        // Show all Graphs
        app.buttons[UIIdentifiers.AccelerationView.zAxisRow].tap()
        app.buttons[UIIdentifiers.AccelerationView.yAxisRow].tap()
        app.buttons[UIIdentifiers.AccelerationView.xAxisRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.AccelerationView.xAxisRow].tap()
        app.buttons[UIIdentifiers.AccelerationView.yAxisRow].tap()
        app.buttons[UIIdentifiers.AccelerationView.zAxisRow].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAccelerationViewSlider() throws {
        // Go to Acceleration View
        goToAccelerationScreen()

        // Swipe Up
        app.buttons[UIIdentifiers.AccelerationView.xAxisRow].swipeUp()

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

    func testAccelerationViewShareSheet() throws {
        // Go to Acceleration View
        goToAccelerationScreen()
        app.buttons[UIIdentifiers.AccelerationView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.AccelerationList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }

    // MARK: - Methods
    func goToAccelerationScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.motionTab].tapWhenReady()
            app.buttons[UIIdentifiers.MotionScreen.accelerationButton].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.accelerationTab].tapWhenReady()
        }
    }
}
