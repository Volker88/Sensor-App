//
//  CoreMotionAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import CoreMotion
import OSLog

class CoreMotionAPI {
    let settings = SettingsManager()
    private var motionManager = CMMotionManager()
    private var magnetManager = CMMagnetometerData()
    private var altimeterManager = CMAltimeter()
    private var attitude = CMAttitude()

    public var sensorUpdateInterval: Double

    init() {
        sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    ///  Completion Handler to receive MotionModel
    ///  - Returns: CoreMotion
    public var motionCompletionHandler: ((MotionModel) -> Void)?

    ///  Completion Handler to receive AltitudeModel
    ///  - Returns: AltitudeModel
    public var altitudeCompletionHandler: ((AltitudeModel) -> Void)?

    ///  Start Motion Sensor updates
    public func motionUpdateStart() { // swiftlint:disable:this function_body_length
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { [self] (data, error) in
            guard let data = data, error == nil else {
                Logger.coreMotion.error("\(String(describing: error))")
                return
            }
            Logger.coreMotion.debug("Start Motion Updates")

            motionManager.deviceMotionUpdateInterval = ( 1 / sensorUpdateInterval)

            // Acceleration
            let accelerationX = data.userAcceleration.x
            let accelerationY = data.userAcceleration.y
            let accelerationZ = data.userAcceleration.z

            // Gravity
            let gravityX = data.gravity.x
            let gravityY = data.gravity.y
            let gravityZ = data.gravity.z

            // Gyrometer
            let gyroX = data.rotationRate.x
            let gyroY = data.rotationRate.y
            let gyroZ = data.rotationRate.z

            // Magnetometer
            let magnetometerCalibration = Int(data.magneticField.accuracy.rawValue)
            let magnetometerX = data.magneticField.field.x
            let magnetometerY = data.magneticField.field.y
            let magnetometerZ = data.magneticField.field.z

            // Attitude
            let attitudeRoll = data.attitude.roll
            let attitudePitch = data.attitude.pitch
            let attitudeYaw = data.attitude.yaw
            let attitudeHeading = data.heading

            let motionModel = MotionModel(
                counter: 1,
                timestamp: settings.getTimestamp(),
                accelerationXAxis: accelerationX,
                accelerationYAxis: accelerationY,
                accelerationZAxis: accelerationZ,
                gravityXAxis: gravityX,
                gravityYAxis: gravityY,
                gravityZAxis: gravityZ,
                gyroXAxis: gyroX,
                gyroYAxis: gyroY,
                gyroZAxis: gyroZ,
                magnetometerCalibration: magnetometerCalibration,
                magnetometerXAxis: magnetometerX,
                magnetometerYAxis: magnetometerY,
                magnetometerZAxis: magnetometerZ,
                attitudeRoll: attitudeRoll,
                attitudePitch: attitudePitch,
                attitudeYaw: attitudeYaw,
                attitudeHeading: attitudeHeading
            )

            // Push Model to ViewController
            motionCompletionHandler?(motionModel)

            // Altimeter
            altimeterManager.startRelativeAltitudeUpdates(to: .main) { [self] (altimeter, error) in
                guard let altimeter = altimeter, error == nil else {
                    Logger.coreMotion.error("\(String(describing: error))")
                    return
                }
                let pressureValue = Double(truncating: altimeter.pressure) // pressure in kPa
                let relativeAltitudeValue = Double(truncating: altimeter.relativeAltitude) // change in m

                let altitudeModel = AltitudeModel(
                    counter: 1,
                    timestamp: settings.getTimestamp(),
                    pressureValue: pressureValue,
                    relativeAltitudeValue: relativeAltitudeValue
                )

                // Push Model to ViewController
                altitudeCompletionHandler?(altitudeModel)
            }
        }
    }

    ///  Stop Motion Sensor updates
    public func motionUpdateStop() {
        motionManager.stopDeviceMotionUpdates()
        altimeterManager.stopRelativeAltitudeUpdates()

        Logger.coreMotion.debug("Stop Motion Updates")
    }
}
