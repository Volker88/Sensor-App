//
//  LocationViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import XCTest

@MainActor
final class LocationViewUITests: BaseTestCase {

    func testLocationViewToolbarButtons() throws {
        // Go to Location View
        moveToView(UIIdentifiers.Sidebar.locationButton)

        // Test Toolbar Buttons
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()
        app.buttons[UIIdentifiers.Toolbar.pauseButton].tap()
        app.buttons[UIIdentifiers.Toolbar.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testLocationViewGraphs() throws {
        // Go to Location View
        moveToView(UIIdentifiers.Sidebar.locationButton)

        // Show all Graphs
        app.buttons[UIIdentifiers.LocationView.speedRow].tap()
        app.buttons[UIIdentifiers.LocationView.courseRow].tap()
        app.buttons[UIIdentifiers.LocationView.altitudeRow].tap()
        app.buttons[UIIdentifiers.LocationView.longitudeRow].tap()
        app.buttons[UIIdentifiers.LocationView.latitudeRow].tap()

        // Hide all Graphs
        app.buttons[UIIdentifiers.LocationView.latitudeRow].tap()
        app.buttons[UIIdentifiers.LocationView.longitudeRow].tap()
        app.buttons[UIIdentifiers.LocationView.altitudeRow].tap()
        app.buttons[UIIdentifiers.LocationView.courseRow].tap()
        app.buttons[UIIdentifiers.LocationView.speedRow].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testLocationViewShareSheet() throws {
        // Go to Location View
        moveToView(UIIdentifiers.Sidebar.locationButton)

        // Open / Close Share Sheet
        app.collectionViews.buttons[UIIdentifiers.LocationView.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
