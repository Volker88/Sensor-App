//
//  SettingsViewUITests.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest

class SettingsViewUITests: BaseTestCase {
    func testSettingsSelection() throws {
        // Go to Settings View
        goToSettingsScreen()

        // Select Speed Setting
        let collection = app.collectionViews[UIIdentifiers.SettingScreen.collectionView]
        XCTAssertTrue(collection.waitForExistence(timeout: 10))
        let speedPicker = collection.buttons[UIIdentifiers.SettingScreen.speedPicker]
        collection.scrollTo(speedPicker)
        speedPicker.tap()
        app.buttons["km/h"].tapWhenReady()

        // Select GPS Accuracy Setting
        let accuracyPicker = collection.buttons[UIIdentifiers.SettingScreen.accuracyPicker]
        collection.scrollTo(accuracyPicker)
        accuracyPicker.tap()
        app.buttons["3 Kilometer"].tapWhenReady()

        // Select Pressure Setting
        let pressurePicker = collection.buttons[UIIdentifiers.SettingScreen.pressurePicker]
        collection.scrollTo(pressurePicker)
        pressurePicker.tap()
        app.buttons["bar"].tapWhenReady()

        // Select Height Setting
        let altitudePicker = collection.buttons[UIIdentifiers.SettingScreen.altitudePicker]
        collection.scrollTo(altitudePicker)
        altitudePicker.tap()
        app.buttons["ft"].tapWhenReady()

        // Graph Settings
        let maxPointsStepper = collection.steppers[UIIdentifiers.SettingScreen.maxPointsStepper]
        collection.scrollTo(maxPointsStepper)
        maxPointsStepper.buttons.element(boundBy: 0).tap()
        maxPointsStepper.buttons.element(boundBy: 1).tap()

        // Save Settings
        app.buttons[UIIdentifiers.SettingScreen.saveButton].tap()
        app.buttons[UIIdentifiers.SettingScreen.discardButton].tap()
    }

    // MARK: - Methods
    func goToSettingsScreen() {
        if isIPhone() {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.settingsTab].tapWhenReady()
        } else {
            app.descendants(matching: .any)[UIIdentifiers.ContentView.settingsTab].tapWhenReady()
        }
    }
}
