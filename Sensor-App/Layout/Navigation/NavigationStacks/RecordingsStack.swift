//
//  RecordingsStack.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftUI

/// Recordings Routes
enum RecordingsStack: Hashable {
    case detail(SensorSession)
    case motionMeasurements(SensorSession)
    case altitudeMeasurements(SensorSession)
    case locationMeasurements(SensorSession)
}

// MARK: - View Extension
extension RecordingsStack: View {
    var body: some View {
        switch self {
            case .detail(let session):
                RecordingDetailScreen(session: session)
            case .motionMeasurements(let session):
                RecordingMotionMeasurementsView(session: session)
            case .altitudeMeasurements(let session):
                RecordingAltitudeMeasurementsView(session: session)
            case .locationMeasurements(let session):
                RecordingLocationMeasurementsView(session: session)
        }
    }
}
