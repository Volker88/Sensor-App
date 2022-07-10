//
//  UserSettings.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 16.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//

import Foundation

struct UserSettings: Codable {
    var showReleaseNotes: Bool
    var GPSSpeedSetting: String
    var GPSAccuracySetting: String
    var frequencySetting: Double
    var pressureSetting: String
    var altitudeHeightSetting: String
    var graphMaxPoints: Int
}
