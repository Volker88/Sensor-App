    //
    //  CoreMotionModel.swift
    //  Sensor App
    //
    //  Created by Volker Schmitt on 23.05.19.
    //  Copyright © 2019 Volker Schmitt. All rights reserved.
    //
    
    // MARK: - Import
    import Foundation
    import CoreMotion
    
    
    // MARK: - Struct DataArray
    struct DataArray {
        let counter : Int
        let timestamp : String // Timestamp
        let accelerationXAxis : Double
        let accelerationYAxis : Double
        let accelerationZAxis : Double
        let gravityXAxis : Double
        let gravityYAxis : Double
        let gravityZAxis : Double
        let gyroXAxis : Double
        let gyroYAxis : Double
        let gyroZAxis : Double
        let magnetometerCalibration : Int
        let magnetometerXAxis : Double
        let magnetometerYAxis : Double
        let magnetometerZAxis : Double
        let attitudeRoll : Double
        let attitudePitch : Double
        let attitudeYaw : Double
        let attitudeHeading : Double
        let pressureValue : Double
        let relativeAltitudeValue : Double
    }
    
    
    // MARK: - Class Definition
    class CoreMotionModel {
        
        // MARK: - Initialize Classes
        let motionManager = CMMotionManager()
        let magnetManager = CMMagnetometerData()
        let altimeterManager = CMAltimeter()
        let attitude = CMAttitude()
        
        
        // MARK: - Variables / Constants
        // Sensor Update Interval
        var sensorUpdateInterval : Double = 1.0
        
        
        // Accelerometer
        var accelerationX = 0.0
        var accelerationY = 0.0
        var accelerationZ = 0.0
        
        
        // Gravity
        var gravityX = 0.0
        var gravityY = 0.0
        var gravityZ = 0.0
        
        
        // Gyrometer
        var gyroX = 0.0
        var gyroY = 0.0
        var gyroZ = 0.0
        
        
        // Magnetometer
        var magnetometerCalibration = 0
        var magnetometerX = 0.0
        var magnetometerY = 0.0
        var magnetometerZ = 0.0
        
        
        // Attitude
        var attitudeRoll = 0.0
        var attitudePitch = 0.0
        var attitudeYaw = 0.0
        var attitudeHeading = 0.0
        
        
        // Altimeter
        var pressureValue = 0.0
        var relativeAltitudeValue = 0.0
        
        
        // callback to be called after updating location
        var didUpdatedCoreMotion: (() -> ())?
        
        
        // MARK: - Methods
        func motionStartMethod() {
            
            self.motionManager.startDeviceMotionUpdates(using: .xTrueNorthZVertical, to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                self.motionManager.deviceMotionUpdateInterval = self.sensorUpdateInterval
                
                
                // Acceleration
                self.accelerationX = data.userAcceleration.x
                self.accelerationY = data.userAcceleration.y
                self.accelerationZ = data.userAcceleration.z
                
                print("Acceleration X: \(self.accelerationX)")
                print("Acceleration Y: \(self.accelerationY)")
                print("Acceleration Z: \(self.accelerationZ)")
                
                
                // Gravity
                self.gravityX = data.gravity.x
                self.gravityY = data.gravity.y
                self.gravityZ = data.gravity.z
                
                print("Gravity X: \(self.gravityX)")
                print("Gravity Y: \(self.gravityY)")
                print("Gravity Z: \(self.gravityZ)")
                
                
                // Gyrometer
                self.gyroX = data.rotationRate.x
                self.gyroY = data.rotationRate.y
                self.gyroZ = data.rotationRate.z
                
                print("Gyrometer X: \(self.gyroX)")
                print("Gyrometer Y: \(self.gyroZ)")
                print("Gyrometer Z: \(self.gyroX)")
                
                
                // Magnetometer
                self.magnetometerCalibration = Int(data.magneticField.accuracy.rawValue)
                self.magnetometerX = data.magneticField.field.x
                self.magnetometerY = data.magneticField.field.y
                self.magnetometerZ = data.magneticField.field.z
                
                print("Magnetometer Calib.: \(self.magnetometerCalibration)")
                print("Magnetometer X: \(self.magnetometerX)")
                print("Magnetometer Y: \(self.magnetometerY)")
                print("Magnetometer Z: \(self.magnetometerZ)")
                
                
                // Attitude
                self.attitudeRoll = data.attitude.roll
                self.attitudePitch = data.attitude.pitch
                self.attitudeYaw = data.attitude.yaw
                self.attitudeHeading = data.heading
                
                print("Roll: \(self.attitudeRoll)")
                print("Pitch: \(self.attitudePitch)")
                print("Yaw: \(self.attitudeYaw)")
                print("Heading: \(self.attitudeHeading) °")
                self.didUpdatedCoreMotion?() // Update Location
            }
            

            // Altimeter
            altimeterManager.startRelativeAltitudeUpdates(to: .main) { (data, error) in
                guard let data = data, error == nil else {
                    return
                }
                self.pressureValue = Double(truncating: data.pressure) // pressure in kPa
                self.relativeAltitudeValue = Double(truncating: data.relativeAltitude) // change in m
                
                print("Pressure: \(self.pressureValue / 100)")
                print("Relative Altitude change: \(self.relativeAltitudeValue)")
                self.didUpdatedCoreMotion?() // Update Location
            }
        }
        
        
        func motionStopMethod() {
            motionManager.stopDeviceMotionUpdates()
            altimeterManager.stopRelativeAltitudeUpdates()
        }
        
        
        func getTimestamp() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss.SSS"
            let dateString = dateFormatter.string(from: NSDate() as Date)
            print("Timestamp: " + dateString)
            return dateString
        }
    }
