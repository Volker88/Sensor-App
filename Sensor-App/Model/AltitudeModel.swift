//
//  AltitudeModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


import Foundation


class AltitudeModel {
    var pressureValue : Double
    var relativeAltitudeValue : Double
    
    
    init(_pressure: Double, _altitude: Double) {

        pressureValue = _pressure
        relativeAltitudeValue = _altitude
    }
}


struct AltitudeModelArray {
    let counter : Int
    let timestamp : String // Timestamp
    let pressureValue : Double
    let relativeAltitudeValue : Double
}
