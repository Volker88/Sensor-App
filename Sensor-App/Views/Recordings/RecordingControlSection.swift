//
//  RecordingControlSection.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.10.26.
//

import Sensor_App_Framework
import SwiftUI

/// Top section of `RecordingsScreen`: a Start Recording button when idle, and live
/// sample counters (mirroring `WatchRecordingView`) plus Stop Recording while active.
struct RecordingControlSection: View {

    @Environment(\.showNotification) private var showNotification
    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(RecordingManager.self) private var recordingManager
    @Environment(SettingsManager.self) private var settingsManager

    // MARK: - Body
    var body: some View {
        Section {
            if recordingManager.isRecording {
                LabeledContent {
                    // Live elapsed time; SwiftUI schedules the updates, no timer needed.
                    Text(
                        .currentDate,
                        format: .stopwatch(startingAt: recordingManager.startedAt, maxPrecision: .seconds(1))
                    )
                    .monospacedDigit()
                    .accessibilityAddTraits(.updatesFrequently)
                } label: {
                    Label("Recording…", systemImage: "record.circle.fill")
                        .foregroundStyle(.red)
                }
                .font(.headline)

                VStack(alignment: .leading) {
                    Text("\(motionManager.motionArray.count) motion")
                    Text("\(motionManager.altitudeArray.count) altitude")
                    Text("\(locationManager.locationArray.count) location")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.updatesFrequently)

                // Mirrors the condition `ContentView` uses to disable the idle timer.
                if settingsManager.userSettings.keepScreenOnWhileRecording {
                    Label("Screen Stays On", systemImage: "sun.max")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.screenStaysOnLabel)
                }

                Button(role: .destructive, action: stopRecording) {
                    Label("Stop Recording", systemImage: "stop.circle.fill")
                        .foregroundStyle(.red)
                }
                .accessibilityHint(Text("Tap to stop recording"))
                .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.stopRecordingButton)
            } else if recordingManager.isSaving {
                // The new session appears in the list below once the save has finished.
                Label {
                    Text("Saving…")
                } icon: {
                    ProgressView()
                }
                .foregroundStyle(.secondary)
                .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.savingLabel)
            } else {
                Button(action: startRecording) {
                    Label("Start Recording", systemImage: "record.circle")
                }
                .accessibilityHint(Text("Tap to start recording"))
                .accessibilityIdentifier(UIIdentifiers.RecordingsScreen.startRecordingButton)
            }
        }
    }

    // MARK: - Methods
    /// No sensor screen is visible on this tab (switching tabs stops the sensors), so
    /// the controller starts all of them here.
    private func startRecording() {
        recordingController.start()
        showNotification("Recording Started")
    }

    /// Nothing on this tab displays the sensors, and sensor screens restart their own
    /// updates on appear, so stopping them after saving is safe.
    private func stopRecording() {
        Task {
            let saved = await recordingController.stop()
            showNotification(saved ? "Recording Saved" : "Recording Could Not Be Saved")
        }
    }

    private var recordingController: RecordingController {
        RecordingController(
            recordingManager: recordingManager,
            motionManager: motionManager,
            locationManager: locationManager,
            settingsManager: settingsManager
        )
    }
}

// MARK: - Preview
#Preview("RecordingControlSection - English", traits: .navEmbedded) {
    List {
        RecordingControlSection()
    }
}

#Preview("RecordingControlSection - German", traits: .navEmbedded) {
    List {
        RecordingControlSection()
    }
    .previewLocalization(.german)
}
