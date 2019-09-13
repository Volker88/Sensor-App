//
//  LocationModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation


// MARK: - Class Definition
class LocationModel {
    
    // MARK: - Define Constants / Variables
    var longitude : Double // Longitude in Degrees
    var latitude : Double // Latitude in Degrees
    var altitude : Double // Altitude measures in Meters
    var speed : Double // Speed in meter per second
    var course : Double // Direction the device is travelling in degrees relative to north
    var horizontalAccuracy : Double // Radius of uncertainity in Meters
    var verticalAccuracy : Double // Accuracy in Meters
    var timestamp : Date // Timestamp of the measurement
    var GPSAccuracy : Double // GPS Desired Accuracy
    
    
    // MARK: - Initializer
    init(_longitude: Double, _latitude: Double, _altitude: Double, _speed: Double, _course: Double, _haccuracy: Double, _vaccuracy: Double, _GPSAccuray: Double, _timestamp: Date) {
        self.longitude = _longitude
        self.latitude = _latitude
        self.altitude = _altitude
        self.speed = _speed
        self.course = _course
        self.horizontalAccuracy = _haccuracy
        self.verticalAccuracy = _vaccuracy
        self.GPSAccuracy = _GPSAccuray
        self.timestamp = _timestamp
    }
}

