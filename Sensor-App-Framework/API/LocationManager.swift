//
//  LocationManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreLocation
import SwiftUI

@MainActor
@Observable
class LocationManager {

    var location: LocationModel?
    var locationArray: [LocationModel] = []

    var updatesStarted: Bool = false

    private let settings = SettingsManager()
    private var locationManager = CLLocationManager()
    private var index = 1

    init() {
        locationManager.requestWhenInUseAuthorization()
    }

    func startLocationUpdates() {
        updatesStarted = true

        // MARK: - Handle authorizationStatus
        if locationManager.authorizationStatus == .notDetermined {
print("Not Determined")
        } else if locationManager.authorizationStatus == .denied {
            print("Denied")
        } else if locationManager.authorizationStatus == .restricted {
            print("Restricted")
        }

        Task {
            let updates = CLLocationUpdate.liveUpdates()

            for try await update in updates {
                if !self.updatesStarted { break }

                if let loc = update.location {
                    let latestLocation = LocationModel(
                        counter: index,
                        longitude: loc.coordinate.longitude,
                        latitude: loc.coordinate.latitude,
                        altitude: loc.altitude,
                        speed: loc.speed,
                        course: loc.course,
                        horizontalAccuracy: loc.horizontalAccuracy,
                        verticalAccuracy: loc.verticalAccuracy,
                        timestamp: Date().formatted(),
                        GPSAccuracy: locationManager.desiredAccuracy
                    )
                    location = latestLocation
                    locationArray.append(latestLocation)

                    index += 1
                }
            }
        }

    }

    func stopLocationUpdates() {
        updatesStarted = false
    }

    func resetLocationUpdates() {
        index = 1
        locationArray.removeAll()
    }

}
