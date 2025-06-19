//
//  Extension-Double.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

extension Double {
    /// Round Doubles
    ///
    ///  Call this function to round Doubles to X decimal digits
    /// - Parameter places: Decimal digits
    /// - Returns: Rounded Double
    public func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }

    /// Localize Decimalnumber
    /// - Parameter maxDecimal: Int
    /// - Returns: String
    public func localizedDecimal(_ maxDecimal: Int = 20) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxDecimal
        let localized = formatter.string(from: NSNumber(value: self))

        return localized ?? ""
    }
}
