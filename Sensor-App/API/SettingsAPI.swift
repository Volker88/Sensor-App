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


// MARK: - Settings for User Defaults (enum)
enum SettingsForUserDefaults {
    case GPSSpeedSetting
    case GPSAccuracySetting
    case frequencySetting
    case pressureSetting
    case altitudeHeightSetting
}


// MARK: - Class Definition
class SettingsAPI {
    
    // MARK: - Singleton Pattern
    static var shared : SettingsAPI = SettingsAPI()
    private init() {
    }
    
    
    // UserDefaults
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - GPS Settings
    public let GPSSpeedSettings = ["m/s", "km/h", "mph"]
    public let GPSAccuracyOptions = ["Best", "10 Meter", "100 Meter", "Kilometer", "3 Kilometer"]
    
    
    // MARK: - Altitude Settings
    public let altitudePressure = ["mbar", "bar", "atm", "Pa", "hPa", "kPa", "psi", "mmHG", "inHG"]
    public let altitudeHeight = ["mm", "cm", "m", "inch", "feet", "yard"]
    
    // MARK: - View BackgroundColor
    public let backgroundColor : [Color] = [Color("1first"), Color("2second"), Color("3third"), Color("4fourth"), Color("5fifth")]
    
    // MARK: - Methods
    
    ///
    ///  Save user settings for strings
    ///
    ///  Saves the user settings for:
    ///  * GPSSpeedSetting
    ///  * GPSAccuracyOption
    ///  * altitudePressure
    ///  * altitudeHeight
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns:
    ///
    ///  - Parameter input: String to be saved
    ///  - Parameter setting: Setting which should be saved
    ///
    public func saveUserDefaultsString(input: String, setting: SettingsForUserDefaults) {
        userDefaults.set(input, forKey: "\(setting)")
        print("Saved - \(input) for \(setting)")
    }
    
    
    // MARK: - Methods for Location
    ///
    ///  Fetch speed setting from user defaults
    ///
    ///  Fetches the speed setting from user defaults. If no setting is saved it will return *m/s* as default.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Speed setting
    ///
    public func fetchSpeedSetting() -> String { // Read Speed Settings from UserDefaults
        var GPSSpeedSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.GPSSpeedSetting)") {
            GPSSpeedSetting = i
        } else {
            GPSSpeedSetting = "m/s"
        }
        return GPSSpeedSetting
    }
    
    ///
    ///  Fetch GPS accuracy setting from user defaults
    ///
    ///  Fetches the GPS accuracy setting from user defaults. If no setting is saved it will return *Best* as default.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: GPS accuracy setting
    ///
    public func fetchGPSAccuracySetting() -> String { // Read GPS Accuracy Settings from UserDefaults
        var GPSAccuracySetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.GPSAccuracySetting)") {
            GPSAccuracySetting = i
        } else {
            GPSAccuracySetting = "Best"
        }
        return GPSAccuracySetting
    }
    
    
    // MARK: - Methods for Altitiude
    ///
    ///  Fetch Altitude Pressure setting from user defaults
    ///
    ///  Fetches the Altitude Pressure setting from user defaults. If no setting is saved it will return *kPa* as default.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: GPS accuracy setting
    ///
    public func fetchPressureSetting() -> String { // Read Pressure Setting from UserDefaults
        var pressureSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.pressureSetting)") {
            pressureSetting = i
        } else {
            pressureSetting = "kPa"
        }
        return pressureSetting
    }
    
    ///
    ///  Fetch Altitude Height setting from user defaults
    ///
    ///  Fetches the Altitude Height setting from user defaults. If no setting is saved it will return *m* as default.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Altitude Height setting
    ///
    public func fetchHeightSetting() -> String { // Read Height Setting from UserDefaults
        var heightSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.altitudeHeightSetting)") {
            heightSetting = i
        } else {
            heightSetting = "m"
        }
        return heightSetting
    }
    
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
    
    
    // MARK: - Methods for Refresh Rate
    
    ///
    ///  Saves the frequency changes to user defaults
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns:
    ///
    ///  - Parameter frequency: Float
    ///
    func saveFrequency(frequency: Float) { // Save Frequency to UserDefaults
        userDefaults.set(frequency, forKey: "\(SettingsForUserDefaults.frequencySetting)")
        print("Saved - \(frequency) for \(SettingsForUserDefaults.frequencySetting)")
    }
    
    
    ///
    ///  Fetch frequency setting from user defaults
    ///
    ///   Fetches the frequency from user defaults. If no setting is saved it will return *1.0* as default.
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns:
    ///
    func fetchFrequency() -> Float { // Read Frequency from UserDefaults
        var frequencySetting: Double = userDefaults.double(forKey: "\(SettingsForUserDefaults.frequencySetting)")
        
        if frequencySetting == 0.0 {
            frequencySetting = 1.0
        }
        return Float(frequencySetting)
    }
}
