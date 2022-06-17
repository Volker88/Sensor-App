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

    // MARK: - Initialize Classes
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()

    // MARK: - Define Constants / Variables
    var array = [DataPoint]()
    var showGraph: GraphDetail = .latitude

    // MARK: - Methods
    func transformLocation(locationModel: [LocationModel]?, graph: GraphDetail) {
        if locationModel!.count != 0 {
            _ = locationModel!.map { value in

                let speed = calculationAPI.calculateSpeed(
                    ms: value.speed,
                    to: settings.fetchUserSettings().GPSSpeedSetting
                )
                switch graph {
                    case .latitude: addToArray(value.latitude)
                    case .longitude: addToArray(value.longitude)
                    case .altitude: addToArray(value.altitude)
                    case .speed: addToArray(speed)
                    case .course: addToArray(value.course)
                    case .horizontalAccuracy: addToArray(value.horizontalAccuracy)
                    case .verticalAccuracy: addToArray(value.verticalAccuracy)
                    case .GPSAccuracy: addToArray(value.GPSAccuracy)
                    default: addToArray(0)
                }
            }
        }
    }

    func addToArray(_ value: Double) {
        let dataPoint = DataPoint(index: array.count + 1, value: value)
        array.append(dataPoint)
    }

    func transformMotion(motionModel: [MotionModel]?, graph: GraphDetail) { // swiftlint:disable:this line_length cyclomatic_complexity
        if motionModel!.count != 0 {
            _ = motionModel!.map { value in
                switch graph {
                case .accelerationXAxis: addToArray(value.accelerationXAxis)
                    case .accelerationYAxis: addToArray(value.accelerationYAxis)
                    case .accelerationZAxis: addToArray(value.accelerationZAxis)
                    case .gravityXAxis: addToArray(value.gravityXAxis)
                    case .gravityYAxis: addToArray(value.gravityYAxis)
                    case .gravityZAxis: addToArray(value.gravityZAxis)
                    case .gyroXAxis: addToArray(value.gyroXAxis)
                    case .gyroYAxis: addToArray(value.gyroYAxis)
                    case .gyroZAxis: addToArray(value.gyroZAxis)
                    case .magnetometerXAxis: addToArray(value.magnetometerXAxis)
                    case .magnetometerYAxis: addToArray(value.magnetometerYAxis)
                    case .magnetometerZAxis: addToArray(value.magnetometerZAxis)
                    case .attitudeRoll: addToArray(value.attitudeRoll * 180 / .pi)
                    case .attitudePitch: addToArray(value.attitudePitch * 180 / .pi)
                    case .attitudeYaw: addToArray(value.attitudeYaw * 180 / .pi)
                    case .attitudeHeading: addToArray(value.attitudeHeading)
                    default: addToArray(0)
                }
            }
        }
    }

    func transformAltitude(altitudeModel: [AltitudeModel]?, graph: GraphDetail) {
        if altitudeModel!.count != 0 {
            _ = altitudeModel!.map { value in

                let height = calculationAPI.calculateHeight(
                    height: value.relativeAltitudeValue,
                    to: settings.fetchUserSettings().altitudeHeightSetting
                )
                let pressure = calculationAPI.calculatePressure(
                    pressure: value.pressureValue,
                    to: settings.fetchUserSettings().altitudeHeightSetting
                )
                switch graph {
                    case .pressureValue: addToArray(pressure)
                    case .relativeAltitudeValue: addToArray(height)
                    default: addToArray(0)
                }
            }
        }
    }

}

struct DataPoint: Identifiable {
    let id = UUID()
    let index: Int
    let value: Double
}
