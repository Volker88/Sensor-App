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
    public func calculateSpeed(ms: Double, to: String) -> Double { // Calculcate Speed
        
        // TODO: Calculation using Foundation
        switch to {
        case SettingsAPI.shared.GPSSpeedSettings[0]: return ms.rounded(toPlaces: 5) // m/s
        case SettingsAPI.shared.GPSSpeedSettings[1]: return (ms * 3.6).rounded(toPlaces: 5) // km/h
        case SettingsAPI.shared.GPSSpeedSettings[2]: return (ms * 2.23694).rounded(toPlaces: 5) // mph
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
    public func calculatePressure(pressure: Double, to: String) -> Double { // Calculate Pressure Units (input kPa)
        
        // TODO: Calculation using Foundation
        switch to {
        case SettingsAPI.shared.altitudePressure[0]: return (pressure * 10).rounded(toPlaces: 10) // mbar
        case SettingsAPI.shared.altitudePressure[1]: return (pressure * 0.01).rounded(toPlaces: 10) // bar
        case SettingsAPI.shared.altitudePressure[2]: return (pressure * 0.00986923).rounded(toPlaces: 10) // atm
        case SettingsAPI.shared.altitudePressure[3]: return (pressure * 1000).rounded(toPlaces: 10) // Pa
        case SettingsAPI.shared.altitudePressure[4]: return (pressure * 10).rounded(toPlaces: 10) // hPa
        case SettingsAPI.shared.altitudePressure[5]: return pressure.rounded(toPlaces: 10) // kPa
        case SettingsAPI.shared.altitudePressure[6]: return (pressure * 0.145038).rounded(toPlaces: 10) // psi
        case SettingsAPI.shared.altitudePressure[7]: return (pressure * 7.50062).rounded(toPlaces: 10) // mmHG
        case SettingsAPI.shared.altitudePressure[8]: return (pressure * 0.2953).rounded(toPlaces: 10) // inHG
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
    public func calculateHeight(height: Double, to: String) -> Double { // Calculate Height Units (input m)
        
        // TODO: Calculation using Foundation
        switch to {
        case SettingsAPI.shared.altitudeHeight[0]: return (height * 1000).rounded(toPlaces: 5) // mm
        case SettingsAPI.shared.altitudeHeight[1]: return (height * 100).rounded(toPlaces: 5) // cm
        case SettingsAPI.shared.altitudeHeight[2]: return (height).rounded(toPlaces: 5) // m
        case SettingsAPI.shared.altitudeHeight[3]: return (height * 39.3701).rounded(toPlaces: 5) // inch
        case SettingsAPI.shared.altitudeHeight[4]: return (height * 3.28084).rounded(toPlaces: 5) // feet
        case SettingsAPI.shared.altitudeHeight[5]: return (height * 1.09361).rounded(toPlaces: 5) // yard
        default: return height
        }
    }
}
