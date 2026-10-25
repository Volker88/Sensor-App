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
    /// Disables the iOS idle timer while a recording is running, so auto-lock can't suspend the app.
    public var keepScreenOnWhileRecording: Bool

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
        locationAccuracySetting: String = UnitLength.meters.symbol,
        keepScreenOnWhileRecording: Bool = true
    ) {
        self.showReleaseNotes = showReleaseNotes
        self.GPSSpeedSetting = GPSSpeedSetting
        self.GPSAccuracySetting = GPSAccuracySetting
        self.frequencySetting = frequencySetting
        self.pressureSetting = pressureSetting
        self.altitudeHeightSetting = altitudeHeightSetting
        self.graphMaxPoints = graphMaxPoints
        self.locationAccuracySetting = locationAccuracySetting
        self.keepScreenOnWhileRecording = keepScreenOnWhileRecording
    }

    private enum CodingKeys: String, CodingKey {
        case showReleaseNotes
        case GPSSpeedSetting
        case GPSAccuracySetting
        case frequencySetting
        case pressureSetting
        case altitudeHeightSetting
        case graphMaxPoints
        case locationAccuracySetting
        case keepScreenOnWhileRecording
    }

    /// Settings saved by older versions lack the newer keys. Decoding them with `decodeIfPresent`
    /// keeps the rest of the user's settings instead of failing and falling back to all defaults.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        showReleaseNotes = try container.decode(Bool.self, forKey: .showReleaseNotes)
        GPSSpeedSetting = try container.decode(String.self, forKey: .GPSSpeedSetting)
        GPSAccuracySetting = try container.decode(String.self, forKey: .GPSAccuracySetting)
        frequencySetting = try container.decode(Double.self, forKey: .frequencySetting)
        pressureSetting = try container.decode(String.self, forKey: .pressureSetting)
        altitudeHeightSetting = try container.decode(String.self, forKey: .altitudeHeightSetting)
        graphMaxPoints = try container.decode(Double.self, forKey: .graphMaxPoints)
        locationAccuracySetting =
            try container.decodeIfPresent(String.self, forKey: .locationAccuracySetting)
            ?? UnitLength.meters.symbol
        keepScreenOnWhileRecording =
            try container.decodeIfPresent(Bool.self, forKey: .keepScreenOnWhileRecording) ?? true
    }
}
