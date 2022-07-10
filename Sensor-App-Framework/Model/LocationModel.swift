//
//  LocationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation

struct LocationModel {
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
