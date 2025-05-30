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
        moveToView(UIIdentifiers.Sidebar.altitudeButton)

        // Test Toolbar Buttons
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()
        app.buttons[UIIdentifiers.Toolbar.pauseButton].tap()
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAltitudeViewGraphs() throws {
        // Go to Altitude View
        moveToView(UIIdentifiers.Sidebar.altitudeButton)

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
        moveToView(UIIdentifiers.Sidebar.altitudeButton)
        app.buttons[UIIdentifiers.AltitudeView.logButton].tap()

        // Open / Close Share Sheet
        app.navigationBars.buttons[UIIdentifiers.AltitudeList.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
        backToHomeMenu()
    }
}
