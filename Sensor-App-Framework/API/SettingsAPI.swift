//
//  SettingsModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 06.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation
import SwiftUI


// MARK: - Class Definition
class SettingsAPI {
     
    // MARK: - GPS Settings
    public let GPSSpeedSettings = [
        UnitSpeed.metersPerSecond.symbol,
        UnitSpeed.kilometersPerHour.symbol,
        UnitSpeed.milesPerHour.symbol
    ]
    
    public let GPSAccuracyOptions = ["Best", "10 Meter", "100 Meter", "Kilometer", "3 Kilometer"]
    
    
    // MARK: - Altitude Settings
    public let altitudePressure = [
        UnitPressure.millibars.symbol,
        UnitPressure.bars.symbol,
        UnitPressure.newtonsPerMetersSquared.symbol,
        UnitPressure.hectopascals.symbol,
        UnitPressure.kilopascals.symbol,
        UnitPressure.poundsForcePerSquareInch.symbol,
        UnitPressure.millimetersOfMercury.symbol,
        UnitPressure.inchesOfMercury.symbol
    ]
    
    public let altitudeHeight = [
        UnitLength.millimeters.symbol,
        UnitLength.centimeters.symbol,
        UnitLength.meters.symbol,
        UnitLength.inches.symbol,
        UnitLength.feet.symbol,
        UnitLength.yards.symbol
    ]
    
    
    // MARK: - View BackgroundColor
    public let backgroundColor : [Color] = [Color("1first"), Color("2second"), Color("3third"), Color("4fourth"), Color("5fifth")]
    
    
    // MARK: - UserDefaults
    ///
    ///  Call this function to clear all UserDefaults
    ///
    public func clearUserDefaults() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    /// Read UserSettings
    ///
    /// This function returns UserSettings from UserDefaults and returns back standard settings if UserDefaults can't be fetched
    ///
    /// - Returns: UserSettings
    ///
    public func fetchUserSettings() -> UserSettings {
        var userSettings = UserSettings(GPSSpeedSetting: "m/s", GPSAccuracySetting: "Best", frequencySetting: 1.0, pressureSetting: "kPa", altitudeHeightSetting: "m", graphMaxPoints: 150)
        
        if let settings = UserDefaults.standard.data(forKey: "UserSettings") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(UserSettings.self, from: settings) {
                userSettings = decoded
            }
        }
        print("Read Settings: \(userSettings)")
        return userSettings
    }
    
    /// Save UserSettings
    ///
    /// Save UserSettings to UserDefaults
    ///
    /// - Parameter userSettings: Settings to save to UserDefaults
    ///
    public func saveUserSettings(userSettings: UserSettings) {
        let encoder = JSONEncoder()
        let settings = userSettings
        
        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: "UserSettings")
        }
        print("Save Settings: \(settings)")
    }
    
    
    // MARK: - Methods
    ///
    ///  Get  current timestamp
    ///
    ///  Get the current timestamp in dd-MM-yyyyy HH:mm:ss.SSS format
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Current timestamp
    ///
    public func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
        let dateString = dateFormatter.string(from: NSDate() as Date)
        //print("Timestamp: " + dateString)
        return dateString
    } 
}
