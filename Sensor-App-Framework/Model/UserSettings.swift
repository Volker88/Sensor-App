//
//  UserSettings.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 16.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation
import SwiftUI

public struct UserSettings: @preconcurrency Codable {
    public var showReleaseNotes: Bool
    public var GPSSpeedSetting: String
    public var GPSAccuracySetting: String
    public var frequencySetting: Double
    public var pressureSetting: String
    public var altitudeHeightSetting: String
    public var graphMaxPoints: Double

    public func graphMaxPointsInt() -> Int {
        Int(graphMaxPoints)
    }
}
