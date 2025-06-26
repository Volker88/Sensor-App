//
//  CalculationManagerTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import Sensor_App_Framework
import Testing

@testable import Sensor_App

@MainActor
final class CalculationManagerTests: BaseTestCase {

    // MARK: - Testing Methods
    @Test(
        "Test conversion of speed",
        arguments: [
            (unit: UnitSpeed.metersPerSecond.symbol, result: 10.0),
            (unit: UnitSpeed.kilometersPerHour.symbol, result: 36.0),
            (unit: UnitSpeed.milesPerHour.symbol, result: 22.37),
            (unit: UnitSpeed.knots.symbol, result: 19.44)
        ])
    func testSpeedCalculation(unit: String, result: Double) async throws {
        let input = 10.0  // m/s
        let calculation = calculationManager.calculateSpeed(ms: input, to: unit).rounded(toPlaces: 2)

        #expect(calculation == result, "\(input) m/s should equal \(result) \(unit)")
    }

    @Test(
        "Test conversion of pressure",
        arguments: [
            (unit: UnitPressure.millibars.symbol, result: 1000.0),
            (unit: UnitPressure.bars.symbol, result: 1.0),
            (unit: UnitPressure.newtonsPerMetersSquared.symbol, result: 100000.0),
            (unit: UnitPressure.hectopascals.symbol, result: 1000.0),
            (unit: UnitPressure.kilopascals.symbol, result: 100.0),
            (unit: UnitPressure.poundsForcePerSquareInch.symbol, result: 14.50),
            (unit: UnitPressure.millimetersOfMercury.symbol, result: 750.06),
            (unit: UnitPressure.inchesOfMercury.symbol, result: 29.53)
        ])
    func testPressureCalculation(unit: String, result: Double) async throws {
        let input = 100.0  // kPa
        let calculation = calculationManager.calculatePressure(pressure: input, to: unit).rounded(toPlaces: 2)

        #expect(calculation == result, "\(input) kPa should equal \(result) \(unit)")
    }

    @Test(
        "Test conversion of height",
        arguments: [
            (unit: UnitLength.millimeters.symbol, result: 1000.0),
            (unit: UnitLength.centimeters.symbol, result: 100.0),
            (unit: UnitLength.meters.symbol, result: 1.0),
            (unit: UnitLength.inches.symbol, result: 39.37),
            (unit: UnitLength.feet.symbol, result: 3.28),
            (unit: UnitLength.yards.symbol, result: 1.09)
        ])
    func testHeightCalculation(unit: String, result: Double) async throws {
        let input = 1.0  // m
        let calculation = calculationManager.calculateHeight(height: input, to: unit).rounded(toPlaces: 2)

        #expect(calculation == result, "\(input) kPa should equal \(result) \(unit)")
    }
}
