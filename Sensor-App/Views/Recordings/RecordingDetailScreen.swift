//
//  RecordingDetailScreen.swift
//  Sensor-App
//

import OSLog
import Sensor_App_Framework
import SwiftData
import SwiftUI

struct RecordingDetailScreen: View {

    let session: SensorSession

    @Environment(\.showNotification) private var showNotification
    @Environment(RecordingManager.self) private var recordingManager
    @Environment(SettingsManager.self) private var settingsManager
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    /// The CSV export, prepared in the background once the samples are loaded.
    @State private var exportURL: URL?

    private let exportManager = ExportManager()

    // MARK: - Body
    var body: some View {
        RecordingDetailView(session: session)
            // A title binding adds the system "Rename" action to the title menu. Writes go through
            // RecordingManager, which trims and rejects empty names; the getter then re-reads the
            // stored name, so a rejected edit falls back to the previous title.
            .navigationTitle(
                Binding(
                    get: { session.name },
                    set: { recordingManager.rename(session, to: $0) }
                )
            )
            .toolbarRole(.editor)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    if let exportURL {
                        ShareSheet(url: exportURL)
                            .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.exportButton)
                    } else {
                        ProgressView()
                    }
                }
            }
            .confirmationDialog("Delete Recording", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    // Leave right away; the list already hides the session while the delete
                    // finishes in the background.
                    dismiss()
                    Task {
                        if !(await recordingManager.delete(session)) {
                            showNotification("Recording Could Not Be Deleted")
                        }
                    }
                }
            } message: {
                Text("This will permanently delete the recording.")
            }
            // Rebuilt when the session is renamed, so the file name follows the title.
            .task(id: session.name) {
                exportURL = await makeExport()
            }
    }

    // MARK: - Methods
    /// Writes the session's samples to a CSV file and returns its URL, or `nil` if loading failed.
    private func makeExport() async -> URL? {
        do {
            let motion = try await session.loadMotionSamples()
            let altitude = try await session.loadAltitudeSamples()
            let location = try await session.loadLocationSamples()

            // Motion is by far the largest part and needs no unit settings, so it's formatted off the
            // main thread. Altitude and location convert units from the current settings.
            var lines = await Self.motionCSVLines(motion)
            lines += altitudeCSVLines(altitude)
            lines += locationCSVLines(location)

            return exportManager.getFile(exportText: lines.joined(separator: "\n"), filename: session.name)
        } catch {
            Logger.recording.error("Preparing the export failed: \(error)")
            return nil
        }
    }

    @concurrent
    nonisolated private static func motionCSVLines(_ samples: [MotionModel]) async -> [String] {
        guard !samples.isEmpty else { return [] }
        let degrees = 180 / Double.pi
        var lines = [
            "# Motion",
            "Counter,Timestamp,Acc X,Acc Y,Acc Z,Gravity X,Gravity Y,Gravity Z,Gyro X,Gyro Y,Gyro Z,Mag Cal,Mag X,Mag Y,Mag Z,Roll (°),Pitch (°),Yaw (°),Heading (°)"  // swiftlint:disable:this line_length
        ]
        lines.reserveCapacity(samples.count + 2)
        for sample in samples {
            lines.append(
                "\(sample.counter),\(sample.timestamp),\(sample.accelerationXAxis),\(sample.accelerationYAxis),\(sample.accelerationZAxis),\(sample.gravityXAxis),\(sample.gravityYAxis),\(sample.gravityZAxis),\(sample.gyroXAxis),\(sample.gyroYAxis),\(sample.gyroZAxis),\(sample.magnetometerCalibration),\(sample.magnetometerXAxis),\(sample.magnetometerYAxis),\(sample.magnetometerZAxis),\(sample.attitudeRoll * degrees),\(sample.attitudePitch * degrees),\(sample.attitudeYaw * degrees),\(sample.attitudeHeading)"
            )
        }
        return lines
    }

    private func altitudeCSVLines(_ samples: [AltitudeModel]) -> [String] {
        guard !samples.isEmpty else { return [] }
        let settings = settingsManager.fetchUserSettings()
        var lines = [
            "# Altitude",
            "Counter,Timestamp,Pressure (\(settings.pressureSetting)),Rel. Altitude (\(settings.altitudeHeightSetting))"
        ]
        for sample in samples {
            lines.append(
                "\(sample.counter),\(sample.timestamp),\(sample.calculatedPressure),\(sample.calculatedAltitude)"
            )
        }
        return lines
    }

    private func locationCSVLines(_ samples: [LocationModel]) -> [String] {
        guard !samples.isEmpty else { return [] }
        let settings = settingsManager.fetchUserSettings()
        var lines = [
            "# Location",
            "Counter,Timestamp,Longitude,Latitude,Altitude (\(settings.altitudeHeightSetting)),Speed (\(settings.GPSSpeedSetting)),Course (°),H.Accuracy (m),V.Accuracy (m),GPS Accuracy"
        ]
        for sample in samples {
            lines.append(
                "\(sample.counter),\(sample.timestamp),\(sample.longitude),\(sample.latitude),\(sample.calculatedAltitude),\(sample.calculatedSpeed),\(sample.course),\(sample.horizontalAccuracy),\(sample.verticalAccuracy),\(sample.GPSAccuracy)"
            )
        }
        return lines
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
