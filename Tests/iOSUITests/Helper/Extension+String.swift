//
//  Extension+String.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.08.25.
//

import Foundation

extension String {

    /// Convert String into Double
    ///
    /// Converts a ``String`` into ``Double``, considering currency symbol and decimal spearator depending on users locale
    ///
    /// - Returns: ``Double``
    public func convertToDouble() -> Double {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.usesGroupingSeparator = true

        // Remove currency symbols and unnecessary whitespace
        let cleanedString = self.trimmingCharacters(in: .whitespacesAndNewlines)

        if let number = formatter.number(from: cleanedString) {
            return number.doubleValue
        } else {
            return 0.0
        }
    }
}
