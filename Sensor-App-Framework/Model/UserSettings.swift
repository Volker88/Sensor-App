//
//  UserSettings.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 16.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation
import SwiftUI

public struct UserSettings: Codable {
    public var showReleaseNotes: Bool
    public var GPSSpeedSetting: String
    public var GPSAccuracySetting: String
    public var frequencySetting: Double
    public var pressureSetting: String
    public var altitudeHeightSetting: String
    public var graphMaxPoints: Double
    public var locationAccuracySetting: String

    public func graphMaxPointsInt() -> Int {
        Int(graphMaxPoints)
    }

    public init(
        showReleaseNotes: Bool,
        GPSSpeedSetting: String,
        GPSAccuracySetting: String,
        frequencySetting: Double,
        pressureSetting: String,
        altitudeHeightSetting: String,
        graphMaxPoints: Double,
        locationAccuracySetting: String = UnitLength.meters.symbol
    ) {
        self.showReleaseNotes = showReleaseNotes
        self.GPSSpeedSetting = GPSSpeedSetting
        self.GPSAccuracySetting = GPSAccuracySetting
        self.frequencySetting = frequencySetting
        self.pressureSetting = pressureSetting
        self.altitudeHeightSetting = altitudeHeightSetting
        self.graphMaxPoints = graphMaxPoints
        self.locationAccuracySetting = locationAccuracySetting
    }
}
