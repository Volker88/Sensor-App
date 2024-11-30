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

    init() async throws {}

    deinit {}

    // MARK: - Testing Methods
    @Test(
        "Test double extension to round",
        arguments: [
            (input: 100.005, result: 100.01),
            //            (input: 100.0045, result: 100.01),
            (input: 100.0040, result: 100.00),
            (input: 100.0044, result: 100.00)
        ])
    func doubleExtensionRound(input: Double, result: Double) throws {
        let calculation = input.rounded(toPlaces: 2)

        #expect(calculation == result)
    }
}
