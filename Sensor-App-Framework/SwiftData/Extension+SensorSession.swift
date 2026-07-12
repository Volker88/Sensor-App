//
//  Extension+SensorSession.swift
//  Sensor-App-Framework
//
//  Created by Volker Schmitt on 11.07.26.
//

import SwiftData
import SwiftUI

extension SensorSession {

    public var duration: TimeInterval? { endedAt.map { $0.timeIntervalSince(startedAt) } }

    public var isCompleted: Bool { endedAt != nil }

    @MainActor
    public static func mockSession() -> SensorSession {
        let motionManager = MotionManager()
        let locationManager = LocationManager()
        locationManager.mockData(preview: true)

        let motionMeasurements = motionManager.motionArray.map { MotionMeasurement(from: $0) }
        let altitudeMeasurements = motionManager.altitudeArray.map { AltitudeMeasurement(from: $0) }
        let locationMeasurements = locationManager.locationArray.map { LocationMeasurement(from: $0) }

        return SensorSession(
            name: "Preview Session",
            startedAt: .now,
            createdAt: .now,
            source: "iPhone",
            motionMeasurements: motionMeasurements,
            altitudeMeasurements: altitudeMeasurements,
            locationMeasurements: locationMeasurements
        )
    }
}
