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
    private var motionManager = CMMotionManager()
    private var magnetManager = CMMagnetometerData()
    private var altimeterManager = CMAltimeter()
    private var attitude = CMAttitude()
    

    // MARK: - Define Constants / Variables
    public var sensorUpdateInterval : Double = Double(SettingsAPI.shared.fetchUserSettings().frequencySetting)
    
    
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
    public func motionUpdateStart() {
        self.motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            self.motionManager.deviceMotionUpdateInterval = ( 1 / self.sensorUpdateInterval)
            
            
            // Acceleration
            let accelerationX = data.userAcceleration.x
            let accelerationY = data.userAcceleration.y
            let accelerationZ = data.userAcceleration.z
            
            print("Acceleration X: \(accelerationX)")
            print("Acceleration Y: \(accelerationY)")
            print("Acceleration Z: \(accelerationZ)")
            
            
            // Gravity
            let gravityX = data.gravity.x
            let gravityY = data.gravity.y
            let gravityZ = data.gravity.z
            
            print("Gravity X: \(gravityX)")
            print("Gravity Y: \(gravityY)")
            print("Gravity Z: \(gravityZ)")
            
            
            // Gyrometer
            let gyroX = data.rotationRate.x
            let gyroY = data.rotationRate.y
            let gyroZ = data.rotationRate.z
            
            print("Gyrometer X: \(gyroX)")
            print("Gyrometer Y: \(gyroZ)")
            print("Gyrometer Z: \(gyroX)")
            
            
            // Magnetometer
            let magnetometerCalibration = Int(data.magneticField.accuracy.rawValue)
            let magnetometerX = data.magneticField.field.x
            let magnetometerY = data.magneticField.field.y
            let magnetometerZ = data.magneticField.field.z
            
            print("Magnetometer Calib.: \(magnetometerCalibration)")
            print("Magnetometer X: \(magnetometerX)")
            print("Magnetometer Y: \(magnetometerY)")
            print("Magnetometer Z: \(magnetometerZ)")
            
            
            // Attitude
            let attitudeRoll = data.attitude.roll
            let attitudePitch = data.attitude.pitch
            let attitudeYaw = data.attitude.yaw
            let attitudeHeading = data.heading
            
            print("Roll: \(attitudeRoll)")
            print("Pitch: \(attitudePitch)")
            print("Yaw: \(attitudeYaw)")
            print("Heading: \(attitudeHeading) °")
            
            
            let motionModel = MotionModel(
                counter: 1,
                timestamp: SettingsAPI.shared.getTimestamp(),
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
            self.motionCompletionHandler?(motionModel)
            
            // Altimeter
            self.altimeterManager.startRelativeAltitudeUpdates(to: .main) { (altimeter, error) in
                guard let altimeter = altimeter, error == nil else {
                    return
                }
                let pressureValue = Double(truncating: altimeter.pressure) // pressure in kPa
                let relativeAltitudeValue = Double(truncating: altimeter.relativeAltitude) // change in m
                
                print("Pressure: \(pressureValue) kPa")
                print("Relative Altitude change: \(relativeAltitudeValue) m")
                
                let altitudeModel = AltitudeModel(
                    counter: 1,
                    timestamp: SettingsAPI.shared.getTimestamp(),
                    pressureValue: pressureValue,
                    relativeAltitudeValue: relativeAltitudeValue
                )

                // Push Model to ViewController
                self.altitudeCompletionHandler?(altitudeModel)
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
    }
}
