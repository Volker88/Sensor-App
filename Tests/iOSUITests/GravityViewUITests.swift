//
//  GravityViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class GravityViewUITests: BaseTestCase {
    func testGravityViewToolbarButtons() throws {
        // Go to Gravity View
        goToGravityScreen()

        // Test CustomControlsView Buttons
        app.buttons[UIIdentifiers.CustomControlsView.expandButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.pauseButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testGravityViewGraphs() throws {
        // Go to Gravity View
        goToGravityScreen()

        // Show all Graphs
        app.buttons[UIIdentifiers.GravityView.zAxisRow].tap()
        app.buttons[UIIdentifiers.GravityView.yAxisRow].tap()
        app.buttons[UIIdentifiers.GravityView.xAxisRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.GravityView.xAxisRow].tap()
        app.buttons[UIIdentifiers.GravityView.yAxisRow].tap()
        app.buttons[UIIdentifiers.GravityView.zAxisRow].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testGravityViewSlider() throws {
        // Go to Gravity View
        goToGravityScreen()

        // Swipe Up
        app.buttons[UIIdentifiers.GravityView.xAxisRow].swipeUp()

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

    func testGravityViewShareSheet() throws {
        // Go to Gravity View
        goToGravityScreen()
        app.buttons[UIIdentifiers.GravityView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.GravityList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }

    // MARK: - Methods
    func goToGravityScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.motionTab].tapWhenReady()
            app.buttons[UIIdentifiers.MotionScreen.gravityButton].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.gravityTab].tapWhenReady()
        }
    }
}
