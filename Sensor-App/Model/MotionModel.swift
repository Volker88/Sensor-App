//
//  MotionModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation


class MotionModel {
    var accelerationXAxis : Double
    var accelerationYAxis : Double
    var accelerationZAxis : Double
    var gravityXAxis : Double
    var gravityYAxis : Double
    var gravityZAxis : Double
    var gyroXAxis : Double
    var gyroYAxis : Double
    var gyroZAxis : Double
    var magnetometerCalibration : Int
    var magnetometerXAxis : Double
    var magnetometerYAxis : Double
    var magnetometerZAxis : Double
    var attitudeRoll : Double
    var attitudePitch : Double
    var attitudeYaw : Double
    var attitudeHeading : Double
    
    
    init(_accelerationX: Double, _accelerationY: Double, _accelerationZ: Double, _gravityX: Double, _gravityY: Double, _gravityZ: Double, _gyroX: Double, _gyroY: Double, _gyroZ: Double, _magCalobration: Int, _magX: Double, _magY: Double, _magZ: Double, _roll: Double, _pitch: Double, _yaw: Double, _heading: Double) {
        accelerationXAxis = _accelerationX
        accelerationYAxis = _accelerationY
        accelerationZAxis = _accelerationZ
        gravityXAxis = _gravityX
        gravityYAxis = _gravityY
        gravityZAxis = _gravityZ
        gyroXAxis = _gyroX
        gyroYAxis = _gyroY
        gyroZAxis = _gyroZ
        magnetometerCalibration = _magCalobration
        magnetometerXAxis = _magX
        magnetometerYAxis = _magY
        magnetometerZAxis = _magZ
        attitudeRoll = _roll
        attitudePitch = _pitch
        attitudeYaw = _yaw
        attitudeHeading = _heading
    }
}


struct MotionModelArray {
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
}
