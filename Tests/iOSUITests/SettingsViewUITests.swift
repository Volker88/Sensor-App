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
        moveToView(UIIdentifiers.Sidebar.settingsButton)

        // Select Speed Setting
        let collection = app.collectionViews[UIIdentifiers.SettingScreen.collectionView]
        collection.buttons[UIIdentifiers.SettingScreen.speedPicker].tap()
        app.buttons["km/h"].tap()

        // Select GPS Accuracy Setting
        collection.buttons[UIIdentifiers.SettingScreen.accuracyPicker].tap()
        app.buttons["3 Kilometer"].tap()

        collection.buttons[UIIdentifiers.SettingScreen.accuracyPicker].swipeUp()
        collection.buttons[UIIdentifiers.SettingScreen.pressurePicker].swipeUp()

        collection.steppers[UIIdentifiers.SettingScreen.zoomStepper].buttons.element(boundBy: 0).tap()
        collection.steppers[UIIdentifiers.SettingScreen.zoomStepper].buttons.element(boundBy: 1).tap()

        // Select Pressure Setting
        collection.buttons[UIIdentifiers.SettingScreen.pressurePicker].tap()
        app.buttons["bar"].tap()

        // Select Height Setting
        collection.buttons[UIIdentifiers.SettingScreen.altitudePicker].tap()
        app.buttons["ft"].tap()

        // Graph Settings
        collection.steppers[UIIdentifiers.SettingScreen.maxPointsStepper].buttons.element(boundBy: 0).tap()
        collection.steppers[UIIdentifiers.SettingScreen.maxPointsStepper].buttons.element(boundBy: 1).tap()

        // Save Settings
        collection.buttons[UIIdentifiers.SettingScreen.saveButton].tap()
        collection.buttons[UIIdentifiers.SettingScreen.discardButton].tap()

        // Go Back to Main Menu
        backToHomeMenu()
    }
}
