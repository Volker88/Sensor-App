//
//  BaseTestCase.swift
//  Sensor-AppiOSUnitTests
//
//  Created by Volker Schmitt on 30.05.25.
//

import Foundation
import Sensor_App_Framework
import Testing

@testable import Sensor_App

@MainActor
class BaseTestCase {

    let calculationManager = CalculationManager()
    let settingsManager = SettingsManager()

    init() async throws {}

    deinit {}
}
