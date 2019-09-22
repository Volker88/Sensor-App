//
//  CalculationAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - Class Definition
class CalculationAPI {
    
    // MARK: - Singleton Pattern
    static var shared : CalculationAPI = CalculationAPI()
    private init() {
    }
    
    
    // MARK: - Methods
    ///
    ///  Converts speed from GPS sensor into desired unit
    ///
    ///  Possible inputs for Parameter **to**
    ///  - km/h
    ///  - mph
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Speed in selected unit
    ///
    ///  - Parameter ms: input in m/s
    ///  - Parameter to: targfet unit
    ///
    func calculateSpeed(ms: Double, to: String) -> Double { // Calculcate Speed
        switch to {
        case SettingsAPI.shared.GPSSpeedSettings[0]: return ms             // m/s
        case SettingsAPI.shared.GPSSpeedSettings[1]: return ms * 3.6       // km/h
        case SettingsAPI.shared.GPSSpeedSettings[2]: return ms * 2.23694   // mph
        default: return ms
        }
    }
    
    ///
    ///  Converts pressure from motion sensor into desired unit
    ///
    ///  Possible inputs for parameter **to**
    ///  * mbar
    ///  * bar
    ///  * atm
    ///  * Pa
    ///  * hPa
    ///  * psi
    ///  * mmHG
    ///  * inHG
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Pressure in selected unit
    ///
    ///  - Parameter pressure: input in kPa
    ///  - Parameter to: target unit
    ///
    private func calculatePressure(pressure: Double, to: String) -> Double { // Calculate Pressure Units (input kPa)
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
    
    ///
    ///  Converts height into selected unit
    ///
    ///  Possible inputs for Parameter **to**
    ///  - mm
    ///  - cm
    ///  - inch
    ///  - feed
    ///  - yard
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: Pressure in selected unit
    ///
    ///  - Parameter height: input in m
    ///  - Parameter to: target unit
    ///
    private func calculateHeight(height: Double, to: String) -> Double { // Calculate Height Units (input m)
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
    
    ///
    ///  Converts Pressure and Altitude Height into selected units
    ///
    ///  Input is taken from Motion sensor. Output unit is taken from user Settings
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: (**pressure, height**) in selected units
    ///
    ///  - Parameter pressure: input in kPa
    ///  - Parameter height: input in m
    ///
    func convertAltitudeData(pressure: Double, height: Double) -> (convertedPressure: Double, convertedHeight: Double) {
        let altitudePressureSetting = SettingsAPI.shared.fetchPressureSetting()
        let altitudeHeightSetting = SettingsAPI.shared.fetchHeightSetting()
        
        let pressure = self.calculatePressure(pressure: pressure, to: altitudePressureSetting)
        let height = self.calculateHeight(height: height, to: altitudeHeightSetting)
        
        return (pressure, height)
    }
}
