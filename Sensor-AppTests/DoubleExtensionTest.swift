//
//  DoubleExtensionTest.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 19.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import XCTest
@testable import Sensor_App

class DoubleExtensionTest: XCTestCase {

    func testDoubleExtensionRoundUp() {
        //Given
        let number = 100.000005
        let decimalDigits = 5
        
        //When
        let rounded = number.rounded(toPlaces: decimalDigits)
        
        //Then
        XCTAssertEqual(rounded, 100.00001, "Rounded \(number) to \(rounded) does not equal 100.00001")
    }
    
    func testDoubleExtensionRoundDown() {
        //Given
        let number = 100.111114
        let decimalDigits = 5
        
        //When
        let rounded = number.rounded(toPlaces: decimalDigits)
        
        //Then
        XCTAssertEqual(rounded, 100.11111, "Rounded \(number) to \(rounded) does not equal 100.11111")
    }

}
