//
//  SettingsModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 06.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation


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
    let userDefaults = UserDefaults.standard
    
    
    // MARK: - GPS Settings
    let GPSspeedSettings = ["m/s", "km/h", "mph"]
    let GPSAccuracyOptions = ["Best", "10 Meter", "100 Meter", "Kilometer", "3 Kilometer"]
    
    
    // MARK: - Altitude Settings
    let altitudePressure = ["mbar", "bar", "atm", "Pa", "hPa", "kPa", "psi", "mmHG", "inHG"]
    let altitudeHeight = ["mm", "cm", "m", "inch", "feet", "yard"]
    
    
    // MARK: - Methods
    func saveUserDefaultsString(input: String, setting: SettingsForUserDefaults) {
        userDefaults.set(input, forKey: "\(setting)")
        print("Saved - \(input) for \(setting)")
    }
    
    
    // MARK: - Methods for Location
    func readSpeedSetting() -> String { // Read Speed Settings from UserDefaults
        var GPSSpeedSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.GPSSpeedSetting)") {
            GPSSpeedSetting = i
        } else {
            GPSSpeedSetting = "m/s"
        }
        return GPSSpeedSetting
    }
       

    func readGPSAccuracySetting() -> String { // Read GPS Accuracy Settings from UserDefaults
        var GPSAccuracySetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.GPSAccuracySetting)") {
            GPSAccuracySetting = i
        } else {
            GPSAccuracySetting = "Best"
        }
        return GPSAccuracySetting
    }
    
    
    // MARK: - Methods for Altitiude
    func readPressureSetting() -> String { // Read Pressure Setting from UserDefaults
        var pressureSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.pressureSetting)") {
            pressureSetting = i
        } else {
            pressureSetting = "kPa"
        }
        return pressureSetting
    }
    
    
    func readHeightSetting() -> String { // Read Height Setting from UserDefaults
        var heightSetting = ""
        if let i = userDefaults.string(forKey: "\(SettingsForUserDefaults.altitudeHeightSetting)") {
            heightSetting = i
        } else {
            heightSetting = "m"
        }
        return heightSetting
    }
    

    func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
        let dateString = dateFormatter.string(from: NSDate() as Date)
        print("Timestamp: " + dateString)
        return dateString
    }
    

    // MARK: - Methods for Refresh Rate
    func saveFrequency(frequency: Float) { // Save Frequency to UserDefaults
        userDefaults.set(frequency, forKey: "\(SettingsForUserDefaults.frequencySetting)")
        print("Saved - \(frequency) for \(SettingsForUserDefaults.frequencySetting)")
    }
    
    
    func readFrequency() -> Float { // Read Frequency from UserDefaults
        var frequencySetting: Double = userDefaults.double(forKey: "\(SettingsForUserDefaults.frequencySetting)")
        
        if frequencySetting == 0.0 {
            frequencySetting = 1.0
        }
        return Float(frequencySetting)
    }
}
