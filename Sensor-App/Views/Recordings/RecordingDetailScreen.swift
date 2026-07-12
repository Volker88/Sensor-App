//
//  RecordingDetailScreen.swift
//  Sensor-App
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingDetailScreen: View {

    let session: SensorSession

    @Environment(RecordingManager.self) private var recordingManager
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        RecordingDetailView(session: session)
            .navigationTitle(session.name)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    ShareSheet(url: exportManager.getFile(exportText: buildCSV(), filename: session.name))
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.exportButton)
                }
            }
            .confirmationDialog("Delete Recording", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    recordingManager.delete(session)
                    dismiss()
                }
            } message: {
                Text("This will permanently delete the recording.")
            }
    }

    // MARK: - Methods
    private func buildCSV() -> String {
        var lines: [String] = []

        if let measurements = session.motionMeasurements, !measurements.isEmpty {
            lines.append("# Motion")
            lines.append(
                "Counter,Timestamp,Acc X,Acc Y,Acc Z,Gravity X,Gravity Y,Gravity Z,Gyro X,Gyro Y,Gyro Z,Mag Cal,Mag X,Mag Y,Mag Z,Roll,Pitch,Yaw,Heading"  // swiftlint:disable:this line_length
            )
            for measurement in measurements.sorted(by: { $0.counter < $1.counter }) {
                lines.append(
                    "\(measurement.counter),\(measurement.timestamp),\(measurement.accelerationXAxis),\(measurement.accelerationYAxis),\(measurement.accelerationZAxis),\(measurement.gravityXAxis),\(measurement.gravityYAxis),\(measurement.gravityZAxis),\(measurement.gyroXAxis),\(measurement.gyroYAxis),\(measurement.gyroZAxis),\(measurement.magnetometerCalibration),\(measurement.magnetometerXAxis),\(measurement.magnetometerYAxis),\(measurement.magnetometerZAxis),\(measurement.attitudeRoll),\(measurement.attitudePitch),\(measurement.attitudeYaw),\(measurement.attitudeHeading)"
                )
            }
        }

        if let measurements = session.altitudeMeasurements, !measurements.isEmpty {
            lines.append("# Altitude")
            lines.append("Counter,Timestamp,Pressure,Relative Altitude")
            for measurement in measurements.sorted(by: { $0.counter < $1.counter }) {
                lines.append(
                    "\(measurement.counter),\(measurement.timestamp),\(measurement.pressureValue),\(measurement.relativeAltitudeValue)"
                )
            }
        }

        if let measurements = session.locationMeasurements, !measurements.isEmpty {
            lines.append("# Location")
            lines.append(
                "Counter,Timestamp,Longitude,Latitude,Altitude,Speed,Course,H.Accuracy,V.Accuracy,GPS Accuracy")
            for measurement in measurements.sorted(by: { $0.counter < $1.counter }) {
                lines.append(
                    "\(measurement.counter),\(measurement.timestamp),\(measurement.longitude),\(measurement.latitude),\(measurement.altitude),\(measurement.speed),\(measurement.course),\(measurement.horizontalAccuracy),\(measurement.verticalAccuracy),\(measurement.GPSAccuracy)"
                )
            }
        }

        return lines.joined(separator: "\n")
    }
}

// MARK: - Preview
#Preview("RecordingDetailScreen - English", traits: .navEmbedded) {
    RecordingDetailScreen(session: SensorSession.mockSession())
}

#Preview("RecordingDetailScreen - German", traits: .navEmbedded) {
    RecordingDetailScreen(session: SensorSession.mockSession())
        .previewLocalization(.german)
}
