//
//  LocationManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreLocation
import OSLog
import SwiftUI

@MainActor
@Observable
public class LocationManager {

    public var location: LocationModel?
    public var locationArray: [LocationModel] = []
    public var locationChart: [LocationModel] = []
    public var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }

    public var updatesStarted: Bool = false

    private let settings = SettingsManager()
    private var locationManager = CLLocationManager()
    private var index = 1

    public init() {
        requestWhenInUseAuthorization()
        mockData()
    }

    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func startLocationUpdates() {
        updatesStarted = true

        // MARK: - Handle authorizationStatus
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            Logger.coreLocation.debug("Location data authorization not granted.")
            return
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
                    locationChart.append(latestLocation)

                    index += 1

                    if self.locationChart.count > self.settings.fetchUserSettings().graphMaxPointsInt() {
                        self.locationChart.removeFirst()
                    }

                }
            }
        }

    }

    public func stopLocationUpdates() {
        updatesStarted = false
    }

    public func resetLocationUpdates() {
        index = 1
        locationArray.removeAll()
        locationChart.removeAll()
    }

    public func mockData() {
        #if DEBUG && targetEnvironment(simulator)
            if CommandLine.arguments.contains("enable-testing") {
                for index in 1...1000 {
                    let location = LocationModel(
                        counter: index,
                        longitude: getDouble(min: -122.109102, max: -122),
                        latitude: getDouble(min: 37.234606, max: 37.434606),
                        altitude: getDouble(min: 10, max: 20),
                        speed: getDouble(min: 90, max: 110),
                        course: getDouble(min: 269, max: 271),
                        horizontalAccuracy: getDouble(min: 0, max: 10),
                        verticalAccuracy: getDouble(min: 0, max: 10),
                        timestamp: Date().formatted(),
                        GPSAccuracy: -1
                    )

                    locationArray.append(location)
                    locationChart.append(location)
                    self.location = location
                }

                func getDouble(min: Double = -1, max: Double = 1) -> Double {
                    Double.random(in: min...max)
                }
            }
        #endif
    }
}
