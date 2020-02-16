//
//  UserSettings.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 16.02.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - UserSettings Struct
struct UserSettings: Codable {
    var GPSSpeedSetting: String
    var GPSAccuracySetting: String
    var frequencySetting: Double
    var pressureSetting: String
    var altitudeHeightSetting: String
}
