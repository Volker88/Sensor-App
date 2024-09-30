//
//  ExtensionTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation
import Testing
@testable import Sensor_App

@MainActor
final class ExtensionTests {

    init() async throws { }

    deinit { }

    // MARK: - Testing Methods
    @Test("Test double extension to round up")
    func doubleExtensionRoundUp() throws {
        let number = 100.000005
        let decimalDigits = 5

        let rounded = number.rounded(toPlaces: decimalDigits)

        #expect(rounded == 100.00001)
    }

    @Test("Test double extension to round down")
    func doubleExtensionRoundDown() throws {
        let number = 100.111114
        let decimalDigits = 5

        let rounded = number.rounded(toPlaces: decimalDigits)

        #expect(rounded == 100.11111)
    }
}
