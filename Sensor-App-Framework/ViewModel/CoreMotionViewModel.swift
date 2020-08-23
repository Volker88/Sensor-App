//
//  CoreMotionViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Combine
import SwiftUI

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
        var counter = 1
        
        for _ in 1...100 {
            let random = Double.random(in: -0.1...0.1)
            let random2 = Double.random(in: -0.1...0.1)
            let random3 = Double.random(in: -0.1...0.1)
            let random4 = Double.random(in: -0.1...0.1)
            self.coreMotionArray.append(MotionModel(counter: counter, timestamp: self.settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: random2, accelerationZAxis: random3, gravityXAxis: random, gravityYAxis: random2, gravityZAxis: random3, gyroXAxis: random, gyroYAxis: random2, gyroZAxis: random3, magnetometerCalibration: 2, magnetometerXAxis: random, magnetometerYAxis: random2, magnetometerZAxis: random3, attitudeRoll: random, attitudePitch: random2, attitudeYaw: random3, attitudeHeading: random4))
            counter += 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
            
                let random = Double.random(in: -0.1...0.1)
                let random2 = Double.random(in: -0.1...0.1)
                let random3 = Double.random(in: -0.1...0.1)
                let random4 = Double.random(in: -0.1...0.1)
                self.coreMotionArray.append(MotionModel(counter: counter, timestamp: self.settings.getTimestamp(), accelerationXAxis: random, accelerationYAxis: random2, accelerationZAxis: random3, gravityXAxis: random, gravityYAxis: random2, gravityZAxis: random3, gyroXAxis: random, gyroYAxis: random2, gyroZAxis: random3, magnetometerCalibration: 2, magnetometerXAxis: random, magnetometerYAxis: random2, magnetometerZAxis: random3, attitudeRoll: random, attitudePitch: random2, attitudeYaw: random3, attitudeHeading: random4))
            counter += 1
        }
        
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
