//
//  AxisStatistics.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 09.07.26.
//  Copyright © 2026 Volker Schmitt. All rights reserved.
//

import Foundation

public struct AxisStatistics: Sendable {
    public let min: Double
    public let max: Double
    public let average: Double
}

extension Collection where Element == Double {
    public var statistics: AxisStatistics? {
        guard !isEmpty else { return nil }
        var minVal = Double.infinity
        var maxVal = -Double.infinity
        var sum = 0.0
        for value in self {
            if value < minVal { minVal = value }
            if value > maxVal { maxVal = value }
            sum += value
        }
        return AxisStatistics(min: minVal, max: maxVal, average: sum / Double(count))
    }
}
