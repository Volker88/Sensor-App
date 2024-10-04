//
//  CalculationManagerTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import Testing
@testable import Sensor_App

@MainActor
final class CalculationManagerTests {

    let calculationManager = CalculationManager()

    init() async throws { }

    deinit { }

    // MARK: - Testing Methods
    @Test("Test conversion of speed")
    func testSpeedCalculation() async throws {
        let input = 10.0 // m/s

        let ms = calculationManager.calculateSpeed(ms: input, to: UnitSpeed.metersPerSecond.symbol)
        let kmh = calculationManager.calculateSpeed(ms: input, to: UnitSpeed.kilometersPerHour.symbol)
        let mph = calculationManager.calculateSpeed(ms: input, to: UnitSpeed.milesPerHour.symbol)

        #expect(ms == 10, "10 m/s should equal 10 m/s")
        #expect(kmh == 36, "10 m/s should equal 36 km/h")
        #expect(mph == 22.37, "10 m/s should equal 22.36940 mph")
    }

    @Test("Test conversion of pressure")
    func testPressureCalculation() async throws {
        let input = 100.0 // kPa

        let mbar = calculationManager.calculatePressure(pressure: input, to: UnitPressure.millibars.symbol)
        let bar = calculationManager.calculatePressure(pressure: input, to: UnitPressure.bars.symbol)
        let pa = calculationManager.calculatePressure(pressure: input, to: UnitPressure.newtonsPerMetersSquared.symbol)
        let hpa = calculationManager.calculatePressure(pressure: input, to: UnitPressure.hectopascals.symbol)
        let kpa = calculationManager.calculatePressure(pressure: input, to: UnitPressure.kilopascals.symbol)
        let psi = calculationManager.calculatePressure(
            pressure: input, to: UnitPressure.poundsForcePerSquareInch.symbol)
        let mmHG = calculationManager.calculatePressure(
            pressure: input, to: UnitPressure.millimetersOfMercury.symbol)
        let inHG = calculationManager.calculatePressure(pressure: input, to: UnitPressure.inchesOfMercury.symbol)

        #expect(mbar == 1000, "100kPa should equal 1000 mbar")
        #expect(bar == 1, "100kPa should equal 1 bar")
        #expect(pa == 100000, "100kPa should equal 100000 Pa")
        #expect(hpa == 1000, "100kPa should equal 1000 hPa")
        #expect(kpa == 100, "100kPa should equal 100 kPa")
        #expect(psi.rounded(toPlaces: 2) == 14.50, "100kPa should equal 14.5038 psi")
        #expect(mmHG.rounded(toPlaces: 2) == 750.06, "100kPa should equal 750.062 mmHG")
        #expect(inHG.rounded(toPlaces: 2) == 29.53, "100kPa should equal 29.53 inHG")
    }

    @Test("Test conversion of height")
    func testHeightCalculation() async throws {
        let input = 1.0 // m

        let milimeter = calculationManager.calculateHeight(height: input, to: UnitLength.millimeters.symbol)
        let centimeter = calculationManager.calculateHeight(height: input, to: UnitLength.centimeters.symbol)
        let meter = calculationManager.calculateHeight(height: input, to: UnitLength.meters.symbol)
        let inch = calculationManager.calculateHeight(height: input, to: UnitLength.inches.symbol)
        let feet = calculationManager.calculateHeight(height: input, to: UnitLength.feet.symbol)
        let yard = calculationManager.calculateHeight(height: input, to: UnitLength.yards.symbol)

        #expect(milimeter == 1000, "1m should equal 1000 mm")
        #expect(centimeter == 100, "1m should equal 100 cm")
        #expect(meter == 1, "1m should equal 1m")
        #expect(inch.rounded(toPlaces: 2) == 39.37, "1m should equal 39.3701 inch")
        #expect(feet.rounded(toPlaces: 2) == 3.28, "1m should equal 3.28084 feet")
        #expect(yard.rounded(toPlaces: 2) == 1.09, "1m should equal 1.09361 yard")
    }
}
