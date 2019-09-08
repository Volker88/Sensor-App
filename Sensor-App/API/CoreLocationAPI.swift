//
//  CoreLocationAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import Foundation
import CoreLocation


// MARK: - Class Definition
class CoreLocationAPI: CLLocationManager, CLLocationManagerDelegate {
    
    // MARK: - Initialize Classes
    private var locationManager : CLLocationManager
    
    
    // MARK: - Singleton pattern
    static var shared : CoreLocationAPI = CoreLocationAPI()
    private override init() {
        locationManager = CLLocationManager()
    }
    
    
    // MARK: - Declaring Global GPS Variables
    private var longitude : Double = 0.0 // Longitude in Degrees
    private var latitude : Double = 0.0 // Latitude in Degrees
    private var altitude : Double = 0.0 // Altitude measures in Meters
    private var speed : Double = 0.0 // Speed in meter per second
    private var course : Double = 0.0 // Direction the device is travelling in degrees relative to north
    private var horizontalAccuracy : Double = 0.0 // Radius of uncertainity in Meters
    private var verticalAccuracy : Double = 0.0 // Accuracy in Meters
    private var timestamp : Date = Date() // Timestamp of the measurement
    private var GPSAccuracy : Double = 0.0 // GPS Desired Accuracy
    
    
    // Closure to push LocationModel to Viewcontroller
    var locationCompletionHandler: ((LocationModel) -> Void)?
    
    
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
        GPSAccuracy = locationManager.desiredAccuracy
        timestamp = location.timestamp

        
        let locationModel = LocationModel(_longitude: longitude, _latitude: latitude, _altitude: altitude, _speed: speed, _course: course, _haccuracy: horizontalAccuracy, _vaccuracy: verticalAccuracy, _GPSAccuray: GPSAccuracy, _timestamp: timestamp)
        
        locationCompletionHandler?(locationModel) // Update Location
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    // MARK: - Start / Stop GPS Method
    func startGPS() { // Start getting GPS Coordinates
        // Define Accuracy based on selection - SettingsModel.GPSAccuracy
        let desiredAccuracy = SettingsAPI.shared.readGPSAccuracySetting()
        switch desiredAccuracy {
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
    }
    
    
    func stopGPS() {
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
    }
}



