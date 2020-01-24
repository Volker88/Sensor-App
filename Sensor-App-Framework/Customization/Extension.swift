//
//  Extension.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - Extension
extension Double {
    
    // MARK: - Round
    ///
    /// Round Doubles
    ///
    ///  Call this function to round Doubles to X decimal digits
    ///
    /// - Parameter places: Decimal digits
    ///
    /// - Returns: Rounded Double
    ///
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
