//
//  CalculationTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 26.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import XCTest
@testable import Sensor_App
//@testable import Sensor_App_Dev


// MARK: - Class Definition
class CalculationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSpeedCalculation() {
        XCTAssertEqual(CalculationAPI.shared.calculateSpeed(ms: 10, to: "km/h"), 36, "10 m/s does not equal 36km/h")
        XCTAssertEqual(CalculationAPI.shared.calculateSpeed(ms: 10, to: "mph"), 22.36940, "10 m/s does not equal 22.36940mph")
    }

    func testPressureCalculation() {
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "mbar"), 1000, "100kPa does not equal 1000mbar")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "bar"), 1, "100kPa does not equal 1bar")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "atm"), 0.986923, "100kPa does not equal 0.986923atm")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "Pa"), 100000, "100kPa does not equal 100000Pa")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "hPa"), 1000, "100kPa does not equal 1000hPa")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "kPa"), 100, "100kPa does not equal 100kPa")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "psi"), 14.5038, "100kPa does not equal 14.5038psi")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "mmHG"), 750.062, "100kPa does not equal 750.062mmHG")
        XCTAssertEqual(CalculationAPI.shared.calculatePressure(pressure: 100, to: "inHG"), 29.53, "100kPa does not equal 29.53inHG")
    }
    
    func testHeightCalculation() {
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "mm"), 1000, "1m does not equal 1000mm")
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "cm"), 100, "1m does not equal 100cm")
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "m"), 1, "1m does not equal 1m")
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "inch"), 39.3701, "1m does not equal 39.3701inch")
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "feet"), 3.28084, "1m does not equal 3.28084feet")
        XCTAssertEqual(CalculationAPI.shared.calculateHeight(height: 1, to: "yard"), 1.09361, "1m does not equal 1.09361yard")
    }
    
}
