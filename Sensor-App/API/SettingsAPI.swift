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
       
    
    func calculateSpeed(ms: Double, to: String) -> Double { // Calculcate Speed
        switch to {
        case GPSspeedSettings[0]: return ms             // m/s
        case GPSspeedSettings[1]: return ms * 3.6       // km/h
        case GPSspeedSettings[2]: return ms * 2.23694   // mph
        default: return ms
        }
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
    
    
    func calculatePressure(pressure: Double, to: String) -> Double { // Calculate Pressure Units (input kPa)
        switch to {
        case altitudePressure[0]: return pressure * 10 // mbar
        case altitudePressure[1]: return pressure * 0.01 // bar
        case altitudePressure[2]: return pressure * 0.00986923// atm
        case altitudePressure[3]: return pressure * 1000 // Pa
        case altitudePressure[4]: return pressure * 10 // hPa
        case altitudePressure[5]: return pressure // kPa
        case altitudePressure[6]: return pressure * 0.145038 // psi
        case altitudePressure[7]: return pressure * 7.50062 // mmHG
        case altitudePressure[8]: return pressure * 0.2953 // inHG
        default: return pressure
        }
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
    

    func calculateHeight(height: Double, to: String) -> Double { // Calculate Height Units (input m)
        switch to {
        case altitudeHeight[0]: return height * 0.01 // mm
        case altitudeHeight[1]: return height * 0.1 // cm
        case altitudeHeight[2]: return height // m
        case altitudeHeight[3]: return height * 39.3701// inch
        case altitudeHeight[4]: return height * 3.28084// feet
        case altitudeHeight[5]: return height * 1.09361// yard
        default: return height
        }
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
