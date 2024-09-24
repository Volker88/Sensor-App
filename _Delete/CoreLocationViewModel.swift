//
//  CoreLocationViewModel.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 06.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Foundation
import MapKit

@available(*, deprecated, message: "Remove for Swift 6")
class CoreLocationViewModel2: ObservableObject {
    @Published var coreLocationArray = [LocationModel]()

    let locationAPI = CoreLocationAPI2()
    let settingsAPI = SettingsManager()

    init() {
        startLocationUpdates()
    }

    func startLocationUpdates() {
// #if targetEnvironment(simulator)
//        mockData()
// #endif
//
//        DispatchQueue.global(qos: .userInteractive).async { [self] in
//            locationAPI.startUpdatingGPS()
//            locationAPI.locationCompletionHandler = { [self] GPS in
//
//                // Append LocationModel to coreLocationArray
//                DispatchQueue.main.async { [self] in
//                    coreLocationArray.append(
//                        LocationModel(
//                            counter: coreLocationArray.count + 1,
//                            longitude: GPS.longitude,
//                            latitude: GPS.latitude,
//                            altitude: GPS.altitude,
//                            speed: GPS.speed,
//                            course: GPS.course,
//                            horizontalAccuracy: GPS.horizontalAccuracy,
//                            verticalAccuracy: GPS.verticalAccuracy,
//                            timestamp: GPS.timestamp,
//                            GPSAccuracy: GPS.GPSAccuracy
//                        )
//                    )
//                }
//            }
//        }
    }

    func stopLocationUpdates() {
        locationAPI.stopUpdatingGPS()
    }

    func mockData() {
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
    }
}
