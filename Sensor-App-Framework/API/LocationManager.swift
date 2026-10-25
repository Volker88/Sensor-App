//
//  LocationManager.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 24.09.2024.
//

import CoreLocation
import OSLog
import SwiftUI

@Observable
public class LocationManager {

    public var location: LocationModel?
    public var locationArray: [LocationModel] = []
    public var locationChart: [LocationModel] = []
    public var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }

    /// `true` while live location updates are actually being consumed (authorization
    /// granted). Drives start/pause toggles.
    public private(set) var isRunning: Bool = false

    private let settings = SettingsManager()
    private var locationManager = CLLocationManager()
    private var index = 1
    private var updatesTask: Task<Void, Never>?

    // Views that currently want location updates — see MotionManager's matching comment.
    private var clients: Set<String> = []

    public init() {
        requestWhenInUseAuthorization()
        mockData()
    }

    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func startLocationUpdates() {
        // MARK: - Handle authorizationStatus
        guard locationManager.authorizationStatus == .authorizedWhenInUse else {
            Logger.coreLocation.debug("Location data authorization not granted.")
            return
        }

        // Cancel any previous loop: it only checks for cancellation when the next update
        // arrives, so a quick stop → start would otherwise leave two loops appending.
        updatesTask?.cancel()
        isRunning = true

        updatesTask = Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()

                for try await update in updates {
                    if Task.isCancelled { break }

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
                            timestamp: Date().sensorTimestamp,
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
            } catch {
                Logger.coreLocation.error("Location updates failed: \(error)")
            }
        }

    }

    public func stopLocationUpdates() {
        isRunning = false
        updatesTask?.cancel()
        updatesTask = nil
    }

    /// Starts location updates on behalf of `client` (typically a screen).
    /// Pair with `releaseLocationUpdates(for:)`; registering the same client twice is harmless.
    public func startLocationUpdates(for client: String) {
        clients.insert(client)
        startLocationUpdates()
    }

    /// Drops `client`'s claim; updates are stopped and reset once no client needs them.
    public func releaseLocationUpdates(for client: String) {
        clients.remove(client)
        guard clients.isEmpty else { return }

        stopLocationUpdates()
        resetLocationUpdates()
    }

    public func resetLocationUpdates() {
        location = nil
        index = 1
        locationArray.removeAll()
        locationChart.removeAll()
    }

    // MARK: - Statistics
    public func statistics(for detail: GraphDetail) -> AxisStatistics? {
        locationArray.map { $0.graphValue(for: detail) }.statistics
    }

    public func mockData(preview: Bool = false) {
        #if DEBUG && targetEnvironment(simulator)
            if CommandLine.arguments.contains("enable-testing") || preview {
                for _ in 1...1000 {
                    let location = LocationModel(
                        counter: index,
                        longitude: getDouble(min: -122.109102, max: -122),
                        latitude: getDouble(min: 37.234606, max: 37.434606),
                        altitude: getDouble(min: 10, max: 20),
                        speed: getDouble(min: 90, max: 110),
                        course: getDouble(min: 269, max: 271),
                        horizontalAccuracy: getDouble(min: 0, max: 10),
                        verticalAccuracy: getDouble(min: 0, max: 10),
                        timestamp: Date().sensorTimestamp,
                        GPSAccuracy: -1
                    )

                    locationArray.append(location)
                    locationChart.append(location)
                    self.location = location
                    index += 1
                }

                func getDouble(min: Double = -1, max: Double = 1) -> Double {
                    Double.random(in: min...max)
                }
            }
        #endif
    }
}
