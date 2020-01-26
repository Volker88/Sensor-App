//
//  GraphArrayTransformation.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Class Definition
class GraphArrayTransformation: ObservableObject {
    
    // MARK: - Define Constants / Variables
    var array: [Double] = [0.0]
    var showGraph: GraphDetail = .latitude

    
    // MARK: - Methods
    func transformLocation(locationModel: [LocationModel]?, graph: GraphDetail) {
        if locationModel!.count != 0 {
            _ = locationModel!.map { value in
                
                let speed = CalculationAPI.shared.calculateSpeed(ms: value.speed, to: SettingsAPI.shared.fetchSpeedSetting())
                switch graph {
                    case .latitude: array.append(value.latitude)
                    case .longitude: array.append(value.longitude)
                    case .altitude: array.append(value.altitude)
                    case .speed: array.append(speed)
                    case .course: array.append(value.course)
                    case .horizontalAccuracy: array.append(value.horizontalAccuracy)
                    case .verticalAccuracy: array.append(value.verticalAccuracy)
                    case .GPSAccuracy: array.append(value.GPSAccuracy)
                    default: array.append(0)
                }
            }
        }
    }
    
    func transformMotion(motionModel: [MotionModel]?, graph: GraphDetail) {
        if motionModel!.count != 0 {
            _ = motionModel!.map { value in
                switch graph {
                    case .accelerationXAxis: array.append(value.accelerationXAxis)
                    case .accelerationYAxis: array.append(value.accelerationYAxis)
                    case .accelerationZAxis: array.append(value.accelerationZAxis)
                    case .gravityXAxis: array.append(value.gravityXAxis)
                    case .gravityYAxis: array.append(value.gravityYAxis)
                    case .gravityZAxis: array.append(value.gravityZAxis)
                    case .gyroXAxis: array.append(value.gyroXAxis)
                    case .gyroYAxis: array.append(value.gyroYAxis)
                    case .gyroZAxis: array.append(value.gyroZAxis)
                    case .magnetometerXAxis: array.append(value.magnetometerXAxis)
                    case .magnetometerYAxis: array.append(value.magnetometerYAxis)
                    case .magnetometerZAxis: array.append(value.magnetometerZAxis)
                    case .attitudeRoll: array.append(value.attitudeRoll * 180 / .pi)
                    case .attitudePitch: array.append(value.attitudePitch * 180 / .pi)
                    case .attitudeYaw: array.append(value.attitudeYaw * 180 / .pi)
                    case .attitudeHeading: array.append(value.attitudeHeading)
                    default: array.append(0)
                }
            }
        }
    }
    
    func transformAltitude(altitudeModel: [AltitudeModel]?, graph: GraphDetail) {
        if altitudeModel!.count != 0 {
            _ = altitudeModel!.map { value in
                
                let height = CalculationAPI.shared.calculateHeight(height: value.relativeAltitudeValue, to: SettingsAPI.shared.fetchHeightSetting())
                let pressure = CalculationAPI.shared.calculatePressure(pressure: value.pressureValue, to: SettingsAPI.shared.fetchPressureSetting())
                switch graph {
                    case .pressureValue: array.append(pressure)
                    case .relativeAltitudeValue: array.append(height)
                    default: array.append(0)
                }
            }
        }
    }
    
}

