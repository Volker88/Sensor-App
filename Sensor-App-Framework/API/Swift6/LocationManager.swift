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

    private let settings = SettingsAPI()
    private var locationManager = CLLocationManager()
    private var index = 1

    func startLocationUpdates() {
        updatesStarted = true

        // MARK: - Handle authorizationStatus
        if locationManager.authorizationStatus == .notDetermined {

        } else if locationManager.authorizationStatus == .denied {

        } else if locationManager.authorizationStatus == .restricted {

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
