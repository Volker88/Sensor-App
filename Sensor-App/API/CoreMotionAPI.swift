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
    var motionManager : CMMotionManager
    var magnetManager : CMMagnetometerData
    var altimeterManager : CMAltimeter
    var attitude : CMAttitude
    
    
    // MARK: - Singleton pattern
    static var shared : CoreMotionAPI = CoreMotionAPI()
    private init() {
        motionManager = CMMotionManager()
        magnetManager = CMMagnetometerData()
        altimeterManager = CMAltimeter()
        attitude = CMAttitude()
    }
    
    
    // MARK: - Variables / Constants
    // Sensor Update Interval
    var sensorUpdateInterval : Double = 1.0
    
    var pressureValue = 0.0
    var relativeAltitudeValue = 0.0

    
    // Closure to push MotionModel to Viewcontroller
    var motionCompletionHandler: ((MotionModel) -> Void)?
    var altitudeCompletionHandler: ((AltitudeModel) -> ())?
    
    
    // MARK: - Methods
    func motionStartMethod() {
        
        self.motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { (data, error) in
            guard let data = data, error == nil else {
                return
            }
            
            self.motionManager.deviceMotionUpdateInterval = self.sensorUpdateInterval
            
            
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
            
            
            let motionModel = MotionModel(_accelerationX: accelerationX, _accelerationY: accelerationY, _accelerationZ: accelerationZ, _gravityX: gravityX, _gravityY: gravityY, _gravityZ: gravityZ, _gyroX: gyroX, _gyroY: gyroY, _gyroZ: gyroZ, _magCalobration: magnetometerCalibration, _magX: magnetometerX, _magY: magnetometerY, _magZ: magnetometerZ, _roll: attitudeRoll, _pitch: attitudePitch, _yaw: attitudeYaw, _heading: attitudeHeading)
            
            self.motionCompletionHandler?(motionModel) // Update Location
            
            
            // Altimeter
            self.altimeterManager.startRelativeAltitudeUpdates(to: .main) { (altimeter, error) in
                guard let altimeter = altimeter, error == nil else {
                    return
                }
                let pressureValue = Double(truncating: altimeter.pressure) // pressure in kPa
                let relativeAltitudeValue = Double(truncating: altimeter.relativeAltitude) // change in m
                
                print("Pressure: \(pressureValue / 100)")
                print("Relative Altitude change: \(relativeAltitudeValue)")
            
                let altitudeModel = AltitudeModel(_pressure: pressureValue, _altitude: relativeAltitudeValue)
                
                self.altitudeCompletionHandler?(altitudeModel) // Update Location
            }
        }
    }
    
    
    func motionStopMethod() {
        motionManager.stopDeviceMotionUpdates()
        altimeterManager.stopRelativeAltitudeUpdates()
    }
}
