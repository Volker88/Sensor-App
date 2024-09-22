//
//  LaunchPerformanceUITests.swift
//  Sensor-AppUITests
//
//  Created by Volker Schmitt on 26.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class LaunchPerformanceUITests: BaseTestCase {
    func testLaunchPerformance() throws {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
    }
}
