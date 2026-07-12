//
//  Extension+Date.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Foundation

extension Date {
    /// Returns the date formatted as a string in the format "HH:mm:ss.SSS" using the en_US_POSIX locale.
    /// This is useful for displaying sensor timestamps in a consistent format.
    public var sensorTimestamp: String {
        formatted(
            .dateTime
                .hour(.twoDigits(amPM: .omitted))
                .minute()
                .second()
                .secondFraction(.fractional(3))
                .locale(Locale(identifier: "en_US_POSIX"))
        )
    }
}
