//
//  CoreMotionViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Combine


// MARK: - Class Definition
class CoreMotionViewModel: ObservableObject {
    
    // MARK: - Initialize Classes
    let motionAPI = CoreMotionAPI()
    let settings = SettingsAPI()
    
    
    // MARK: - Define Constants / Variables
    @Published var coreMotionArray = [MotionModel]()
    @Published var altitudeArray = [AltitudeModel]()
    var sensorUpdateInterval : Double = 1 {
        didSet {
            motionAPI.sensorUpdateInterval = settings.fetchUserSettings().frequencySetting
        }
    }
    
    
    // MARK: - Methods
    func motionUpdateStart() {
        #if targetEnvironment(simulator)
        for _ in 1...100 {
            let random = Double.random(in: -0.1...0.1)
            coreMotionArray.append(MotionModel(counter: 1, timestamp: settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: 0.53212, accelerationZAxis: 1.60932, gravityXAxis: -0.80520, gravityYAxis: -0.01717, gravityZAxis: -0.59275, gyroXAxis: 0.00140, gyroYAxis: -0.00045, gyroZAxis: 0.00140, magnetometerCalibration: 2, magnetometerXAxis: -2.14823, magnetometerYAxis: 35.9243, magnetometerZAxis: -21.61115, attitudeRoll: -0.9362, attitudePitch: 0.0171, attitudeYaw: -1.1931, attitudeHeading: 338.8594))
            coreMotionArray.append(MotionModel(counter: 1, timestamp: settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: 0.15215, accelerationZAxis: 3.22326, gravityXAxis: -2.82921, gravityYAxis: -1.17210, gravityZAxis: -1.19282, gyroXAxis: 0.15153, gyroYAxis: -0.56028, gyroZAxis: 0.83620, magnetometerCalibration: 3, magnetometerXAxis: 2.14823, magnetometerYAxis: 20.9243, magnetometerZAxis: 30.61115, attitudeRoll: -2.9362, attitudePitch: -0.2732, attitudeYaw: 3.1823, attitudeHeading: 31.5372))
            coreMotionArray.append(MotionModel(counter: 1, timestamp: settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: 1.23743, accelerationZAxis: 3.94323, gravityXAxis: -0.34723, gravityYAxis: -0.75234, gravityZAxis: -0.23574, gyroXAxis: 1.84534, gyroYAxis: -0.42634, gyroZAxis: 1.92425, magnetometerCalibration: 1, magnetometerXAxis: 3.89325, magnetometerYAxis: -11.42145, magnetometerZAxis: 29.41264, attitudeRoll: -0.2346, attitudePitch: 0.3125, attitudeYaw: -1.9352, attitudeHeading: 338.8594))
        }
        coreMotionArray.shuffle()
        #endif
        
        motionAPI.motionUpdateStart()
        motionAPI.motionCompletionHandler = { data in
            
            // Append MotionModel to coreMotionArray
            self.coreMotionArray.append(MotionModel(
                counter: self.coreMotionArray.count + 1,
                timestamp: self.settings.getTimestamp(),
                accelerationXAxis: data.accelerationXAxis,
                accelerationYAxis: data.accelerationYAxis,
                accelerationZAxis: data.accelerationZAxis,
                gravityXAxis: data.gravityXAxis,
                gravityYAxis: data.gravityYAxis,
                gravityZAxis: data.gravityZAxis,
                gyroXAxis: data.gyroXAxis,
                gyroYAxis: data.gyroYAxis,
                gyroZAxis: data.gyroZAxis,
                magnetometerCalibration: data.magnetometerCalibration,
                magnetometerXAxis: data.magnetometerXAxis,
                magnetometerYAxis: data.magnetometerYAxis,
                magnetometerZAxis: data.magnetometerZAxis,
                attitudeRoll: data.attitudeRoll,
                attitudePitch: data.attitudePitch,
                attitudeYaw: data.attitudeYaw,
                attitudeHeading: data.attitudeHeading
            ))
        }
    }
    
    func altitudeUpdateStart() {
        #if targetEnvironment(simulator)
        for _ in 1...100 {
        altitudeArray.append(AltitudeModel(counter: 1, timestamp: settings.getTimestamp(), pressureValue: 99.61142, relativeAltitudeValue: 0.0))
        altitudeArray.append(AltitudeModel(counter: 1, timestamp: settings.getTimestamp(), pressureValue: 100.32622, relativeAltitudeValue: 0.183257))
        altitudeArray.append(AltitudeModel(counter: 1, timestamp: settings.getTimestamp(), pressureValue: 101.95223, relativeAltitudeValue: 0.780832))
        }
        altitudeArray.shuffle()
        #endif
        
        motionAPI.motionUpdateStart()
        motionAPI.altitudeCompletionHandler = { data in
            
            // Append AltitudeModel to altitudeArray
            self.altitudeArray.append(AltitudeModel(
                counter: self.altitudeArray.count + 1,
                timestamp: self.settings.getTimestamp(),
                pressureValue: data.pressureValue,
                relativeAltitudeValue: data.relativeAltitudeValue
            ))
        }
    }
    
    func stopMotionUpdates() {
        motionAPI.motionUpdateStop()
    }
}
