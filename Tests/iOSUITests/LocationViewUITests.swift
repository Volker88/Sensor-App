//
//  LocationViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import XCTest

class LocationViewUITests: BaseTestCase {
    func testLocationViewToolbarButtons() throws {
        // Go to Location View
        goToLocationScreen()

        // Test CustomControlsView Buttons

        app.buttons[UIIdentifiers.CustomControlsView.expandButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.playButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.pauseButton].tap()
        app.buttons[UIIdentifiers.CustomControlsView.deleteButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    func testLocationViewGraphs() throws {
        // Go to Location View
        goToLocationScreen()

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
        goToLocationScreen()

        // Open / Close Share Sheet
        app.collectionViews.buttons[UIIdentifiers.LocationView.exportButton].tap()
        sleep(1)
        dismissShareSheet()

        // Go Back to Main Menu
        backToHomeMenu()
    }

    // MARK: - Methods
    func goToLocationScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.positionTab].tapWhenReady()
            app.buttons[UIIdentifiers.PositionScreen.locationButton].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.locationTab].tapWhenReady()
        }
    }
}
