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
                        recordingManager.stopRecording(
                            motionArray: motionManager.motionArray,
                            altitudeArray: motionManager.altitudeArray,
                            locationArray: locationManager.locationArray,
                            source: "Apple Watch"
                        )
                        stopSensors()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                } else {
                    Image(systemName: "record.circle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    Button("Start Recording") {
                        motionManager.resetMotionUpdates()
                        locationManager.resetLocationUpdates()
                        recordingManager.startRecording()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationTitle("Record Session")
        .onAppear { startSensors() }
        .onDisappear { stopSensors() }
    }

    // MARK: - Methods
    private func startSensors() {
        let frequency = settingsManager.fetchUserSettings().frequencySetting
        motionManager.sensorUpdateInterval = frequency
        motionManager.startMotionUpdates()
        motionManager.startAltitudeUpdates()
        locationManager.startLocationUpdates()
    }

    private func stopSensors() {
        motionManager.stopMotionUpdates()
        motionManager.resetMotionUpdates()
        locationManager.stopLocationUpdates()
        locationManager.resetLocationUpdates()
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
