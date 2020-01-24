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
    ///  - Parameter ms: Input in **m/s**
    ///  - Parameter to: Target unit
    ///
    public func calculateSpeed(ms: Double, to: String) -> Double { // Calculcate Speed
        var targetUnit : UnitSpeed = .metersPerSecond
        
        switch to {
            case SettingsAPI.shared.GPSSpeedSettings[0]: targetUnit = .metersPerSecond
            case SettingsAPI.shared.GPSSpeedSettings[1]: targetUnit = .kilometersPerHour
            case SettingsAPI.shared.GPSSpeedSettings[2]: targetUnit = .milesPerHour
            default: targetUnit = .metersPerSecond
        }
        let meterPerSecond = Measurement(value: ms, unit: UnitSpeed.metersPerSecond)
        let output = meterPerSecond.converted(to: targetUnit)
        
        return output.value.rounded(toPlaces: 2)
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
    ///  - Parameter pressure: Input in **kPa**
    ///  - Parameter to: Target unit
    ///
    public func calculatePressure(pressure: Double, to: String) -> Double { // Calculate Pressure Units (input kPa)
        var targetUnit : UnitPressure = .kilopascals
        
        switch to {
            case SettingsAPI.shared.altitudePressure[0]: targetUnit = .millibars // mbar
            case SettingsAPI.shared.altitudePressure[1]: targetUnit = .bars // bar
            case SettingsAPI.shared.altitudePressure[2]: targetUnit = .newtonsPerMetersSquared // Pa
            case SettingsAPI.shared.altitudePressure[3]: targetUnit = .hectopascals // hPa
            case SettingsAPI.shared.altitudePressure[4]: targetUnit = .kilopascals // kPa
            case SettingsAPI.shared.altitudePressure[5]: targetUnit = .poundsForcePerSquareInch // psi
            case SettingsAPI.shared.altitudePressure[6]: targetUnit = .millimetersOfMercury // mmHG
            case SettingsAPI.shared.altitudePressure[7]: targetUnit = .inchesOfMercury // inHG
            default: targetUnit = .kilopascals
        }
        
        let kiloPascal = Measurement(value: pressure, unit: UnitPressure.kilopascals)
        let output = kiloPascal.converted(to: targetUnit)
        
        return output.value.rounded(toPlaces: 5)
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
    ///  - Parameter height: Input in **m**
    ///  - Parameter to: Target unit
    ///
    public func calculateHeight(height: Double, to: String) -> Double { // Calculate Height Units (input m)
        var targetUnit : UnitLength = .meters
        
        switch to {
            case SettingsAPI.shared.altitudeHeight[0]: targetUnit = .millimeters // mm
            case SettingsAPI.shared.altitudeHeight[1]: targetUnit = .centimeters // cm
            case SettingsAPI.shared.altitudeHeight[2]: targetUnit = .meters // m
            case SettingsAPI.shared.altitudeHeight[3]: targetUnit = .inches // inch
            case SettingsAPI.shared.altitudeHeight[4]: targetUnit = .feet // feet
            case SettingsAPI.shared.altitudeHeight[5]: targetUnit = .yards // yards
            default: targetUnit = .meters
        }
        
        let meters = Measurement(value: height, unit: UnitLength.meters)
        let output = meters.converted(to: targetUnit)
        
        return output.value.rounded(toPlaces: 5)
    }
}
