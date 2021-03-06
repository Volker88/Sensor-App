//
//  CoreLocationViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

// MARK: - Import
import SwiftUI
import MapKit

// MARK: - Class Definition
class CoreLocationViewModel: ObservableObject {

    // MARK: - Initialize Classes
    let locationAPI = CoreLocationAPI()
    let settingsAPI = SettingsAPI()

    // MARK: - Define Constants / Variables
    @Published var coreLocationArray = [LocationModel]()

    // MARK: - Methods
    func startLocationUpdates() {
        #if targetEnvironment(simulator)
        // swiftlint:disable line_length
        for _ in 1...100 {
            coreLocationArray.append(LocationModel(counter: 1, longitude: -73.985255, latitude: 40.758449, altitude: 30, speed: 23.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
            coreLocationArray.append(LocationModel(counter: 1, longitude: -73.984729, latitude: 40.759083, altitude: 30, speed: 25.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
            coreLocationArray.append(LocationModel(counter: 1, longitude: -73.984021, latitude: 40.760123, altitude: 30, speed: 26.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))

        }
        coreLocationArray.removeLast()
        coreLocationArray.shuffle()
        coreLocationArray.append(LocationModel(counter: 1, longitude: -73.984021, latitude: 40.760123, altitude: 10, speed: 26.24, course: 265.08, horizontalAccuracy: 5.0, verticalAccuracy: 5.0, timestamp: "17-11-2019 10:44:13.136", GPSAccuracy: -1.0))
        // swiftlint:enable line_length
        #endif

        locationAPI.startUpdatingGPS()
        locationAPI.locationCompletionHandler = { [self] GPS in

            // Append LocationModel to coreLocationArray
            coreLocationArray.append(LocationModel(
                counter: coreLocationArray.count + 1,
                longitude: GPS.longitude,
                latitude: GPS.latitude,
                altitude: GPS.altitude,
                speed: GPS.speed,
                course: GPS.course,
                horizontalAccuracy: GPS.horizontalAccuracy,
                verticalAccuracy: GPS.verticalAccuracy,
                timestamp: GPS.timestamp,
                GPSAccuracy: GPS.GPSAccuracy
            ))
        }
    }

    func stopLocationUpdates() {
        locationAPI.stopUpdatingGPS()
    }

}
