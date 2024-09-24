//
//  CoreLocationAPI.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 02.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import CoreLocation
import OSLog

@available(*, deprecated, message: "Remove for Swift 6")
class CoreLocationAPI2: CLLocationManager, CLLocationManagerDelegate {
    private let settings = SettingsManager()
    private var locationManager = CLLocationManager()

    ///  Completion Handler to receive LocationModel Object
    ///
    ///  - Returns: LocationModel Object
    public var locationCompletionHandler: ((LocationModel) -> Void)?

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1] // Last object from location Array

        // GPS Information
        let longitude = location.coordinate.longitude // Longitude in Degrees
        let latitude = location.coordinate.latitude // Latitude in Degrees
        let altitude = location.altitude // Altitude measures in Meters
        let speed = location.speed // Speed in meter per second
        let course = location.course // Direction the device is travelling in degrees relative to north
        let horizontalAccuracy = location.horizontalAccuracy // Radius of uncertainity in Meters
        let verticalAccuracy = location.verticalAccuracy // Accuracy in Meters
        let GPSAccuracy = locationManager.desiredAccuracy // GPS Desired Accuracy
        // let timestamp = location.timestamp // Timestamp of the measurement

        // Creating LocationModel
        let locationModel = LocationModel(
            counter: 1,
            longitude: longitude,
            latitude: latitude,
            altitude: altitude,
            speed: speed,
            course: course,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            timestamp: settings.getTimestamp(),
            GPSAccuracy: GPSAccuracy
        )

        locationCompletionHandler?(locationModel) // Update Location
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Logger.coreLocation.error("\(error)")
    }

    ///  Start GPS updates
    ///
    ///   Starting GPS updates based on selected accuracy
    public func startUpdatingGPS() { // Start getting GPS Coordinates
        // Define Accuracy based on selection - SettingsModel.GPSAccuracy
        let desiredAccuracy = settings.fetchUserSettings().GPSAccuracySetting
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

        Logger.coreLocation.debug("Start Location Updates")
    }

    ///  Stop GPS updates
    public func stopUpdatingGPS() {
        locationManager.delegate = self
        locationManager.stopUpdatingLocation()
        Logger.coreLocation.debug("Stop Location Updates")
    }
}
