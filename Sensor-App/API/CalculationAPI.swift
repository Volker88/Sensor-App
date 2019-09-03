//
//  CalculationAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation


// MARK: - Class Definition
class CalculationAPI {
    
    // MARK: - Singleton Pattern
    static var shared : CalculationAPI = CalculationAPI()
    private init() {
    }
    
    
    func calculateSpeed(ms: Double, to: String) -> Double { // Calculcate Speed
        switch to {
        case SettingsAPI.shared.GPSspeedSettings[0]: return ms             // m/s
        case SettingsAPI.shared.GPSspeedSettings[1]: return ms * 3.6       // km/h
        case SettingsAPI.shared.GPSspeedSettings[2]: return ms * 2.23694   // mph
        default: return ms
        }
    }
    
    
    func calculatePressure(pressure: Double, to: String) -> Double { // Calculate Pressure Units (input kPa)
        switch to {
        case SettingsAPI.shared.altitudePressure[0]: return pressure * 10 // mbar
        case SettingsAPI.shared.altitudePressure[1]: return pressure * 0.01 // bar
        case SettingsAPI.shared.altitudePressure[2]: return pressure * 0.00986923// atm
        case SettingsAPI.shared.altitudePressure[3]: return pressure * 1000 // Pa
        case SettingsAPI.shared.altitudePressure[4]: return pressure * 10 // hPa
        case SettingsAPI.shared.altitudePressure[5]: return pressure // kPa
        case SettingsAPI.shared.altitudePressure[6]: return pressure * 0.145038 // psi
        case SettingsAPI.shared.altitudePressure[7]: return pressure * 7.50062 // mmHG
        case SettingsAPI.shared.altitudePressure[8]: return pressure * 0.2953 // inHG
        default: return pressure
        }
    }
    
    
    func calculateHeight(height: Double, to: String) -> Double { // Calculate Height Units (input m)
        switch to {
        case SettingsAPI.shared.altitudeHeight[0]: return height * 0.01 // mm
        case SettingsAPI.shared.altitudeHeight[1]: return height * 0.1 // cm
        case SettingsAPI.shared.altitudeHeight[2]: return height // m
        case SettingsAPI.shared.altitudeHeight[3]: return height * 39.3701// inch
        case SettingsAPI.shared.altitudeHeight[4]: return height * 3.28084// feet
        case SettingsAPI.shared.altitudeHeight[5]: return height * 1.09361// yard
        default: return height
        }
    }
    
    
    func convertAltitudeData(pressure: Double, height: Double) -> (convertedPressure: Double, convertedHeight: Double) {
        let altitudePressureSetting = SettingsAPI.shared.readPressureSetting()
        let altitudeHeightSetting = SettingsAPI.shared.readHeightSetting()
        
        let pressure = self.calculatePressure(pressure: pressure, to: altitudePressureSetting)
        let height = self.calculateHeight(height: height, to: altitudeHeightSetting)
        
        return (pressure, height)
    }
    
    
}
