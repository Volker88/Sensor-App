//
//  AppUpdatesTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 01.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation
import Sensor_App_Framework
import Testing

@testable import Sensor_App

final class AppUpdateTests: BaseTestCase {

    // MARK: - Testing Methods
    @Test("Test app for first time launch")
    func appUpdates() async throws {
        let appUpdates = AppUpdates()
        UserDefaults.standard.removeObject(forKey: "CurrentAppVersion")
        appUpdates.checkForUpdate()

        let userDefaultsForSpeedSetting = UserDefaults.standard.string(
            forKey: "\(SettingsForUserDefaults.GPSSpeedSetting)")

        #expect(userDefaultsForSpeedSetting == nil)
    }
}
