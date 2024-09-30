//
//  LocationViewUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class LocationViewUITests: BaseTestCase {
    func testLocationViewToolbarButtons() throws {
        // Go to Location View
        moveToView(view: "Location")

        // Test Toolbar Buttons
        let toolbar = app.toolbars["Toolbar"]
        toolbar.buttons["Play"].tap()
        toolbar.buttons["Pause"].tap()
        toolbar.buttons["Delete"].tap()

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
        app.collectionViews.buttons["ExportButton"].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
