//
//  Extension.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 11.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

// MARK: - Double
extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
