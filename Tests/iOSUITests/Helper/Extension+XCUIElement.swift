//
//  File.swift
//  Sensor-AppiOSUITests
//
//  Created by Volker Schmitt on 30.05.25.
//

import Foundation
import XCTest

extension XCUIElement {
    func tapWhenReady(timeout: TimeInterval = 30) {
        XCTAssertTrue(self.waitForExistence(timeout: timeout), "Element did not appear in time")
        self.tap()
    }
}
