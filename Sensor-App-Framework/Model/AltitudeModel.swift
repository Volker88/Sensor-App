//
//  AltitudeModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 03.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

struct AltitudeModel: Hashable {
    let counter: Int
    let timestamp: String
    let pressureValue: Double
    let relativeAltitudeValue: Double
}
