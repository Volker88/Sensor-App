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
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()

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

        backToHomeMenu()
    }

    func testAltitudeViewShareSheet() throws {
        // Go to Altitude View
        moveToView(view: "Altitude")

        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()

        backToHomeMenu()
    }
}
