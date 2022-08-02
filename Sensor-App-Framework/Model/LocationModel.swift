//
//  LocationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

struct LocationModel: Hashable {
    let counter: Int // Counter
    var longitude: Double // Longitude in Degrees
    var latitude: Double // Latitude in Degrees
    var altitude: Double // Altitude measures in Meters
    var speed: Double // Speed in meter per second
    var course: Double // Direction the device is travelling in degrees relative to north
    var horizontalAccuracy: Double // Radius of uncertainity in Meters
    var verticalAccuracy: Double // Accuracy in Meters
    var timestamp: String // Timestamp of the measurement
    var GPSAccuracy: Double // GPS Desired Accuracy
}

extension LocationModel {
    func graphValue(for graph: GraphDetail) -> Double {
        switch graph {
            case .latitude: return latitude
            case .longitude: return longitude
            case .altitude: return altitude
            case .speed: return speed
            case .course: return course
            case .horizontalAccuracy: return horizontalAccuracy
            case .verticalAccuracy: return verticalAccuracy
            case .GPSAccuracy: return GPSAccuracy
            default: return 0
        }
    }
}
