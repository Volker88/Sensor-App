//
//  GPSModel.swift
//  Sensor App
//
//  Created by Volker Schmitt on 05.05.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import Foundation
import CoreLocation


// MARK: - Class Definition
class GPSModel: CLLocationManager, CLLocationManagerDelegate {
    
    // MARK: - Initialize Classes
    let settings = SettingsModel() // Load Settings from SettingsModel()
    let locationManager = CLLocationManager()
    
    
    // MARK: - Declaring Global GPS Variables
    var longitude : Double = 0.0 // Longitude in Degrees
    var latitude : Double = 0.0 // Latitude in Degrees
    var altitude : Double = 0.0 // Altitude measures in Meters
    var speed : Double = 0.0 // Speed in meter per second
    var course : Double = 0.0 // Direction the device is travelling in degrees relative to north
    var horizontalAccuracy : Double = 0.0 // Radius of uncertainity in Meters
    var verticalAccuracy : Double = 0.0 // Accuracy in Meters
    var timestamp : Date = Date() // Timestamp of the measurement
    var GPSAccuracy : Double = 0.0 // GPS Desired Accuracy
    
    
    // callback to be called after updating location
    var didUpdatedLocation: (() -> ())?
    
    
    // MARK: - locationManager Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] // Last object from location Array
        
        // Updating Global Variables
        longitude = location.coordinate.longitude
        latitude = location.coordinate.latitude
        altitude = location.altitude
        speed = location.speed
        course = location.course
        horizontalAccuracy = location.horizontalAccuracy
        verticalAccuracy = location.verticalAccuracy
        timestamp = location.timestamp
        GPSAccuracy = locationManager.desiredAccuracy
        didUpdatedLocation?() // Update Location
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    // MARK: - Start / Stop GPS Method
    func startGPS(_desiredAccuracy: String) { // Start getting GPS Coordinated
        // Define Accuracy based on selection - SettingsModel.GPSAccuracy
        switch _desiredAccuracy {
        case "Best": locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case "10 Meter": locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        case "100 Meter": locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        case "Kilometer": locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        case "3 Kilometer": locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        default: locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Asks for permission to access GPS
        locationManager.startUpdatingLocation() // Start Updating Location
        //locationManager.requestLocation() // Request Location once
    }
    
    
    func stopGPS() {
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
    }
}
