//
//  AltitudeViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class AltitudeViewUITests: BaseTestCase {
    func testAltitudeViewToolbarButtons() throws {
        // Go to Altitude View
        goToAltitudeScreen()

        // Test CustomControlsView Buttons
        app.buttons[UIIdentifiers.CustomControlsView.expandButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.pauseButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAltitudeViewGraphs() throws {
        // Go to Altitude View
        goToAltitudeScreen()

        // Show all Graphs
        app.buttons[UIIdentifiers.AltitudeView.altitudeRow].tap()
        app.buttons[UIIdentifiers.AltitudeView.pressureRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.AltitudeView.pressureRow].tap()
        app.buttons[UIIdentifiers.AltitudeView.altitudeRow].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAltitudeViewShareSheet() throws {
        // Go to Altitude View
        goToAltitudeScreen()
        app.buttons[UIIdentifiers.AltitudeView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.AltitudeList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }

    // MARK: - Methods
    func goToAltitudeScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.positionTab].tapWhenReady()
            app.buttons[UIIdentifiers.PositionScreen.altitudeButton].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.altitudeTab].tapWhenReady()
        }
    }
}
