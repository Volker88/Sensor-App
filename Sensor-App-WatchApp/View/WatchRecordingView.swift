//
//  WatchRecordingView.swift
//  Sensor-App-WatchApp
//

import Sensor_App_Framework
import SwiftUI

struct WatchRecordingView: View {

    @Environment(RecordingManager.self) private var recordingManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(LocationManager.self) private var locationManager
    @Environment(SettingsManager.self) private var settingsManager

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if recordingManager.isRecording {
                    Label("Recording…", systemImage: "record.circle.fill")
                        .foregroundStyle(.red)
                        .font(.headline)

                    VStack(spacing: 4) {
                        Text("\(motionManager.motionArray.count) motion")
                            .font(.caption)
                        Text("\(motionManager.altitudeArray.count) altitude")
                            .font(.caption)
                        Text("\(locationManager.locationArray.count) location")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)

                    Button("Stop Recording") {
                        recordingController.stop()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Image(systemName: "record.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Button("Start Recording") {
                        recordingController.start()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle("Record Session")
    }

    // MARK: - Properties
    /// Owns the sensors for the length of a recording, so this screen needs no
    /// lifecycle of its own and leaving it mid-recording doesn't stop anything.
    private var recordingController: WatchRecordingController {
        WatchRecordingController(
            recordingManager: recordingManager,
            motionManager: motionManager,
            locationManager: locationManager,
            settingsManager: settingsManager
        )
    }
}

// MARK: - Preview
#Preview("WatchRecordingView") {
    WatchRecordingView()
        //        .environment(RecordingManager())
        .environment(MotionManager())
        .environment(LocationManager())
        .environment(SettingsManager())
}
