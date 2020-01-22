//
//  ArrayTransformation.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 22.01.20.
//  Copyright © 2020 Volker Schmitt. All rights reserved.
//


import SwiftUI

enum LocationEnum {
    case longitude
    case latitude
    case altitude
    case speed
    case course
    case horizontalAccuracy
    case verticalAccuracy
    case GPSAccuracy
}


class ArrayTransformation: ObservableObject {

    
    var array: [Double] = [0.0]
    
   
    func transform(model: [LocationModel]) {
        
        _ = model.map { index in
            self.array.append(index.course)
        }
        
    }
    
    
    
//    func transformLocationArray(output: LocationEnum) {
//        _ = array.map { value in
//            switch output {
//                case .longitude: transformedArray.append(value.longitude)
//                case .latitude: transformedArray.append(value.latitude)
//                case .altitude: transformedArray.append(value.altitude)
//                case .speed: transformedArray.append(value.speed)
//                case .course: transformedArray.append(value.course)
//                case .horizontalAccuracy: transformedArray.append(value.horizontalAccuracy)
//                case .verticalAccuracy: transformedArray.append(value.verticalAccuracy)
//                case .GPSAccuracy: transformedArray.append(value.GPSAccuracy)
//            }
//        }
//    }
}
