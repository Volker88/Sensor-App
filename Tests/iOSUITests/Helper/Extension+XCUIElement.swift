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

    /// Scrolls the receiver (a scroll or collection view) up until `element` can be tapped.
    ///
    /// Uses slow swipes and re-checks after each one, so it neither depends on the screen size
    /// nor overshoots: on a tall screen the element may already be hittable and no swipe happens.
    func scrollTo(_ element: XCUIElement, maxSwipes: Int = 10) {
        var swipes = 0
        while !(element.exists && element.isHittable), swipes < maxSwipes {
            swipeUp(velocity: .slow)
            swipes += 1
        }
        XCTAssertTrue(element.isHittable, "Element \(element) is not hittable after \(swipes) swipes")
    }
}
