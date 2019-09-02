//
//  MotionModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation


class MotionModel {
    var accelerationXAxis : Double?
    var accelerationYAxis : Double?
    var accelerationZAxis : Double?
    var gravityXAxis : Double?
    var gravityYAxis : Double?
    var gravityZAxis : Double?
    var gyroXAxis : Double?
    var gyroYAxis : Double?
    var gyroZAxis : Double?
    var magnetometerCalibration : Int?
    var magnetometerXAxis : Double?
    var magnetometerYAxis : Double?
    var magnetometerZAxis : Double?
    var attitudeRoll : Double?
    var attitudePitch : Double?
    var attitudeYaw : Double?
    var attitudeHeading : Double?
    var pressureValue : Double?
    var relativeAltitudeValue : Double?
    
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
    
    init(_pressure: Double, _altitude: Double) {
        pressureValue = _pressure
        relativeAltitudeValue = _altitude
    }
    
}
