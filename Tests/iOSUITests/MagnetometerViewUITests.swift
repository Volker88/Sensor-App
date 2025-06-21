//
//  MagnetometerViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class MagnetometerViewUITests: BaseTestCase {
    func testMagnetometerViewToolbarButtons() throws {
        // Go to Magnetometer View
        goToMagnetometerScreen()

        // Test CustomControlsView Buttons
        app.buttons[UIIdentifiers.CustomControlsView.expandButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.pauseButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()
    }

    func testMagnetometerViewGraphs() throws {
        // Go to Magnetometer View
        goToMagnetometerScreen()

        // Show all Graphs
        app.buttons[UIIdentifiers.MagnetometerView.zAxisRow].tap()
        app.buttons[UIIdentifiers.MagnetometerView.yAxisRow].tap()
        app.buttons[UIIdentifiers.MagnetometerView.xAxisRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.MagnetometerView.xAxisRow].tap()
        app.buttons[UIIdentifiers.MagnetometerView.yAxisRow].tap()
        app.buttons[UIIdentifiers.MagnetometerView.zAxisRow].tap()
    }

    func testMagnetometerViewSlider() throws {
        // Go to Magnetometer View
        goToMagnetometerScreen()

        // Swipe Up
        app.buttons[UIIdentifiers.MagnetometerView.xAxisRow].swipeUp()

        // Adjust Slider to 0% and then 100%
        app.sliders[UIIdentifiers.RefreshRateView.refreshRateSlider].adjust(toNormalizedSliderPosition: 0.0)
        app.sliders[UIIdentifiers.RefreshRateView.refreshRateSlider].adjust(toNormalizedSliderPosition: 1.0)

        let slider = UIIdentifiers.RefreshRateView.refreshRateSlider
        let updateFrequency = app.sliders[slider].value as! String  // swiftlint:disable:this force_cast
        let splitUpdateFrequency = updateFrequency.split(separator: " ", maxSplits: 1).map(String.init)
        XCTAssertEqual(splitUpdateFrequency[0], "50", "Update frequency should be 50 but is \(splitUpdateFrequency)")
    }

    func testMagnetometerViewShareSheet() throws {
        // Go to Magnetometer View
        goToMagnetometerScreen()
        app.buttons[UIIdentifiers.MagnetometerView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.MagnetometerList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    // MARK: - Methods
    func goToMagnetometerScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.magnetometerTab].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.magnetometerTab].tapWhenReady()
        }
    }
}
