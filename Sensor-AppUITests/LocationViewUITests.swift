//
//  LocationViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import XCTest
@testable import Sensor_App

// MARK: - Class Definition
class LocationViewUITests: BaseTestCase {
    func testLocationViewToolbarButtons() throws {
        // Go to Location View
        moveToView(view: "Location")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["play"].tap()
        toolbar.buttons["pause"].tap()
        toolbar.buttons["trash"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testLocationViewGraphs() throws {
        // Go to Location View
        moveToView(view: "Location")

        // Show all Graphs
        app.buttons["Toggle Speed Graph"].tap()
        app.buttons["Toggle Direction Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Longitude Graph"].tap()
        app.buttons["Toggle Latitude Graph"].tap()

        // Hide all Graphs
        app.buttons["Toggle Latitude Graph"].tap()
        app.buttons["Toggle Longitude Graph"].tap()
        app.buttons["Toggle Altitude Graph"].tap()
        app.buttons["Toggle Direction Graph"].tap()
        app.buttons["Toggle Speed Graph"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testLocationViewShareSheet() throws {
        // Go to Location View
        moveToView(view: "Location")

        // Open / Close Share Sheet
        app.tables.buttons["Export"].tap()
        sleep(1)
        app.navigationBars["UIActivityContentView"].buttons["Close"].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
