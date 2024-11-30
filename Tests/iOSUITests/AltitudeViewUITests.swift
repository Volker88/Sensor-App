//
//  AltitudeViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

@testable import Sensor_App

class AltitudeViewUITests: BaseTestCase {
    func testAltitudeViewToolbarButtons() throws {
        // Go to Altitude View
        moveToView(view: "Altitude")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["Play"].tap()
        toolbar.buttons["Pause"].tap()
        toolbar.buttons["Delete"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAltitudeViewGraphs() throws {
        // Go to Altitude View
        moveToView(view: "Altitude")

        // Show all Graphs
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Pressure Graph"].tap()

        // Hide all Graphs
        app.buttons["Toggle Pressure Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testAltitudeViewShareSheet() throws {
        // Go to Altitude View
        moveToView(view: "Altitude")
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
