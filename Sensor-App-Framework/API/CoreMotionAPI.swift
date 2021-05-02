//
//  CoreMotionAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation
import CoreMotion

// MARK: - Class Definition
class CoreMotionAPI {

    // MARK: - Initialize Classes
    let settings = SettingsAPI()

    // MARK: - Initialize Classes
    private var motionManager = CMMotionManager()
    private var magnetManager = CMMagnetometerData()
    private var altimeterManager = CMAltimeter()
    private var attitude = CMAttitude()

    // MARK: - Define Constants / Variables
    public var sensorUpdateInterval: Double

    // MARK: - Initializer
    init() {
        sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
    }

    // MARK: - Closure to push MotionModel to ViewModel
    ///
    ///  Completion Handler to receive MotionModel
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: CoreMotion
    ///
    public var motionCompletionHandler: ((MotionModel) -> Void)?

    ///
    ///  Completion Handler to receive AltitudeModel
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns: AltitudeModel
    ///
    public var altitudeCompletionHandler: ((AltitudeModel) -> Void)?

    // MARK: - Methods
    ///
    ///  Start Motion Sensor updates
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns:
    ///
    public func motionUpdateStart() { // swiftlint:disable:this function_body_length
        motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { [self] (data, error) in
            guard let data = data, error == nil else {
                Log.shared.add(.coreMotion, .error, "\(String(describing: error))")
                return
            }
            Log.shared.add(.coreMotion, .default, "Start Motion Updates")

            motionManager.deviceMotionUpdateInterval = ( 1 / sensorUpdateInterval)

            // Acceleration
            let accelerationX = data.userAcceleration.x
            let accelerationY = data.userAcceleration.y
            let accelerationZ = data.userAcceleration.z

            Log.shared.print("Acceleration X: \(accelerationX)")
            Log.shared.print("Acceleration Y: \(accelerationY)")
            Log.shared.print("Acceleration Z: \(accelerationZ)")

            // Gravity
            let gravityX = data.gravity.x
            let gravityY = data.gravity.y
            let gravityZ = data.gravity.z

            Log.shared.print("Gravity X: \(gravityX)")
            Log.shared.print("Gravity Y: \(gravityY)")
            Log.shared.print("Gravity Z: \(gravityZ)")

            // Gyrometer
            let gyroX = data.rotationRate.x
            let gyroY = data.rotationRate.y
            let gyroZ = data.rotationRate.z

            Log.shared.print("Gyrometer X: \(gyroX)")
            Log.shared.print("Gyrometer Y: \(gyroZ)")
            Log.shared.print("Gyrometer Z: \(gyroX)")

            // Magnetometer
            let magnetometerCalibration = Int(data.magneticField.accuracy.rawValue)
            let magnetometerX = data.magneticField.field.x
            let magnetometerY = data.magneticField.field.y
            let magnetometerZ = data.magneticField.field.z

            Log.shared.print("Magnetometer Calib.: \(magnetometerCalibration)")
            Log.shared.print("Magnetometer X: \(magnetometerX)")
            Log.shared.print("Magnetometer Y: \(magnetometerY)")
            Log.shared.print("Magnetometer Z: \(magnetometerZ)")

            // Attitude
            let attitudeRoll = data.attitude.roll
            let attitudePitch = data.attitude.pitch
            let attitudeYaw = data.attitude.yaw
            let attitudeHeading = data.heading

            Log.shared.print("Roll: \(attitudeRoll)")
            Log.shared.print("Pitch: \(attitudePitch)")
            Log.shared.print("Yaw: \(attitudeYaw)")
            Log.shared.print("Heading: \(attitudeHeading) °")

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
            altimeterManager.startRelativeAltitudeUpdates(to: .main) { (altimeter, error) in
                guard let altimeter = altimeter, error == nil else {
                    Log.shared.add(.coreMotion, .error, "\(String(describing: error))")
                    return
                }
                let pressureValue = Double(truncating: altimeter.pressure) // pressure in kPa
                let relativeAltitudeValue = Double(truncating: altimeter.relativeAltitude) // change in m

                Log.shared.print("Pressure: \(pressureValue) kPa")
                Log.shared.print("Relative Altitude change: \(relativeAltitudeValue) m")

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

    ///
    ///  Stop Motion Sensor updates
    ///
    ///  - Note:
    ///  - Remark:
    ///
    ///  - Returns:
    ///
    public func motionUpdateStop() {
        motionManager.stopDeviceMotionUpdates()
        altimeterManager.stopRelativeAltitudeUpdates()
        Log.shared.add(.coreMotion, .default, "Stop Motion Updates")
    }
}
