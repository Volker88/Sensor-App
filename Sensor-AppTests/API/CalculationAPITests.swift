//
//  CalculationAPITests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import XCTest
@testable import Sensor_App

// MARK: - Class Definition
class CalculationAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests
    let calculationAPI = CalculationAPI()
    func testSpeedCalculationAPI() throws {
        // Given
        let input = 10.0 // m/s

        // When
        let ms = calculationAPI.calculateSpeed(ms: input, to: UnitSpeed.metersPerSecond.symbol)
        let kmh = calculationAPI.calculateSpeed(ms: input, to: UnitSpeed.kilometersPerHour.symbol)
        let mph = calculationAPI.calculateSpeed(ms: input, to: UnitSpeed.milesPerHour.symbol)

        // Then
        XCTAssertEqual(ms, 10, accuracy: 0.01, "10 m/s does not equal 10 m/s")
        XCTAssertEqual(kmh, 36, accuracy: 0.01, "10 m/s does not equal 36 km/h")
        XCTAssertEqual(mph, 22.36940, accuracy: 0.01, "10 m/s does not equal 22.36940 mph")
    }

    func testSpeedCalculationAPIPerformance() throws {
        measure {
            _ = calculationAPI.calculateSpeed(ms: 10, to: "m/s")
            _ = calculationAPI.calculateSpeed(ms: 10, to: "km/h")
            _ = calculationAPI.calculateSpeed(ms: 10, to: "mph")
        }
    }

    func testPressureCalculationAPI() throws {
        // Given
        let input = 100.0 // kPa

        // When
        let mbar = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.millibars.symbol)
        let bar = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.bars.symbol)
        let pa = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.newtonsPerMetersSquared.symbol)
        let hpa = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.hectopascals.symbol)
        let kpa = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.kilopascals.symbol)
        let psi = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.poundsForcePerSquareInch.symbol)
        let mmHG = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.millimetersOfMercury.symbol)
        let inHG = calculationAPI.calculatePressure(pressure: input, to: UnitPressure.inchesOfMercury.symbol)

        // Then
        XCTAssertEqual(mbar, 1000, accuracy: 0.01, "100kPa does not equal 1000 mbar")
        XCTAssertEqual(bar, 1, accuracy: 0.01, "100kPa does not equal 1 bar")
        XCTAssertEqual(pa, 100000, accuracy: 0.01, "100kPa does not equal 100000 Pa")
        XCTAssertEqual(hpa, 1000, accuracy: 0.01, "100kPa does not equal 1000 hPa")
        XCTAssertEqual(kpa, 100, accuracy: 0.01, "100kPa does not equal 100 kPa")
        XCTAssertEqual(psi, 14.5038, accuracy: 0.01, "100kPa does not equal 14.5038 psi")
        XCTAssertEqual(mmHG, 750.062, accuracy: 0.01, "100kPa does not equal 750.062 mmHG")
        XCTAssertEqual(inHG, 29.53, accuracy: 0.01, "100kPa does not equal 29.53 inHG")
    }

    func testHeightCalculationAPI() throws {
        // Given
        let input = 1.0 // m

        // When
        let milimeter = calculationAPI.calculateHeight(height: input, to: UnitLength.millimeters.symbol)
        let centimeter = calculationAPI.calculateHeight(height: input, to: UnitLength.centimeters.symbol)
        let meter = calculationAPI.calculateHeight(height: input, to: UnitLength.meters.symbol)
        let inch = calculationAPI.calculateHeight(height: input, to: UnitLength.inches.symbol)
        let feet = calculationAPI.calculateHeight(height: input, to: UnitLength.feet.symbol)
        let yard = calculationAPI.calculateHeight(height: input, to: UnitLength.yards.symbol)

        // Then
        XCTAssertEqual(milimeter, 1000, accuracy: 0.01, "1m does not equal 1000 mm")
        XCTAssertEqual(centimeter, 100, accuracy: 0.01, "1m does not equal 100 cm")
        XCTAssertEqual(meter, 1, accuracy: 0.01, "1m does not equal 1m")
        XCTAssertEqual(inch, 39.3701, accuracy: 0.01, "1m does not equal 39.3701 inch")
        XCTAssertEqual(feet, 3.28084, accuracy: 0.01, "1m does not equal 3.28084 feet")
        XCTAssertEqual(yard, 1.09361, accuracy: 0.01, "1m does not equal 1.09361 yard")
    }

    // MARK: - Methods
}
