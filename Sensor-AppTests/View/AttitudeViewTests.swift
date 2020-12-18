//
//  AttitudeViewTests.swift
//  Sensor-AppTests
//
//  Created by Volker Schmitt on 01.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import XCTest
@testable import Sensor_App

// MARK: - Class Definition
class AttitudeViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests
    #if targetEnvironment(simulator)
    func testAttitudeViewDebugArray() throws {
        //Given
        let sut = AttitudeView()

        //When
        sut.onAppear()
        let count = sut.motionVM.coreMotionArray.count

        //Then
        XCTAssertEqual(count, 300, "There are \(count) items in MotionArray whereas only 300 should be there")
    }

    func testAttitudeViewEmptyArray() throws {
        //Given
        let sut = AttitudeView()

        //When
        sut.onAppear()
        sut.onDisappear()
        let count = sut.motionVM.coreMotionArray.count

        //Then
        XCTAssertEqual(count, 0, "There are \(count) items in MotionArray whereas only 300 should be there")
    }
    #endif

    // MARK: - Methods
}
