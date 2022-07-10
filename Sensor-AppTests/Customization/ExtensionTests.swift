//
//  ExtensionTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class ExtensionTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoubleExtensionRoundUp() throws {
        // Given
        let number = 100.000005
        let decimalDigits = 5

        // When
        let rounded = number.rounded(toPlaces: decimalDigits)

        // Then
        XCTAssertEqual(rounded, 100.00001, "Rounded \(number) to \(rounded) does not equal 100.00001")
    }

    func testDoubleExtensionRoundDown() throws {
        // Given
        let number = 100.111114
        let decimalDigits = 5

        // When
        let rounded = number.rounded(toPlaces: decimalDigits)

        // Then
        XCTAssertEqual(rounded, 100.11111, "Rounded \(number) to \(rounded) does not equal 100.11111")
    }
}
