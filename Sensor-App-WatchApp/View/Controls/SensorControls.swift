//
//  SensorControls.swift
//  Sensor-App-WatchApp
//
//  Created by Volker Schmitt on 23.10.26.
//

import Sensor_App_Framework
import SwiftUI
import WatchKit

/// Bottom-toolbar Start/Pause toggle, Record/Stop toggle and Delete button for a watch
/// sensor screen. Screens still auto-start on appear; these controls let the user recover,
/// reset, or record a session without going through `WatchRecordingView`.
struct SensorControls: ToolbarContent {

    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(RecordingManager.self) private var recordingManager
    @Environment(SettingsManager.self) private var settingsManager

    let sensor: MonitoredSensor

    // MARK: - Body
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            controlButton(type: isRunning ? .pause : .start)
            Spacer()
            controlButton(type: .record)
            Spacer()
            controlButton(type: .delete)
        }
    }

    // MARK: - Properties
    private var isRunning: Bool {
        switch sensor {
            case .motion:
                return motionManager.isMotionRunning
            case .altitude:
                return motionManager.isAltitudeRunning
            case .location:
                return locationManager.isRunning
        }
    }

    /// Only Record (Stop) stays usable mid-recording: pausing or deleting would leave
    /// gaps in (or wipe) the session's data.
    private func isDisabled(_ type: SensorControlAction) -> Bool {
        type != .record && recordingManager.isRecording
    }

    private func isRecordActive(_ type: SensorControlAction) -> Bool {
        type == .record && recordingManager.isRecording
    }

    private func accessibilityHint(_ type: SensorControlAction) -> LocalizedStringKey {
        if isDisabled(type) {
            return LocalizedStringKey("Unavailable while recording")
        }
        return isRecordActive(type) ? LocalizedStringKey("Tap to stop recording") : type.accessibilityHint
    }

    private var recordingController: WatchRecordingController {
        WatchRecordingController(
            recordingManager: recordingManager,
            motionManager: motionManager,
            locationManager: locationManager,
            settingsManager: settingsManager
        )
    }

    // MARK: - Methods
    private func controlButton(type: SensorControlAction) -> some View {
        Button(role: type == .delete ? .destructive : nil) {
            perform(type)
        } label: {
            Label(type.localizedString, systemImage: isRecordActive(type) ? "stop.circle.fill" : type.systemImage)
                .labelStyle(.iconOnly)
        }
        .tint(isRecordActive(type) ? .red : nil)
        .disabled(isDisabled(type))
        .accessibilityLabel(Text(type.localizedString))
        .accessibilityHint(Text(accessibilityHint(type)))
        .accessibilityIdentifier(type.accessibilityIdentifier)
    }

    private func perform(_ type: SensorControlAction) {
        switch type {
            case .start:
                WKInterfaceDevice.current().play(.click)
                startUpdates()
            case .pause:
                WKInterfaceDevice.current().play(.click)
                pauseUpdates()
            case .delete:
                WKInterfaceDevice.current().play(.click)
                deleteValues()
            case .record:
                toggleRecording()
        }
    }

    private func startUpdates() {
        switch sensor {
            case .motion:
                motionManager.startMotionUpdates()
            case .altitude:
                motionManager.startAltitudeUpdates()
            case .location:
                locationManager.startLocationUpdates()
        }
    }

    private func pauseUpdates() {
        switch sensor {
            case .motion:
                motionManager.stopDeviceMotionUpdates()
            case .altitude:
                motionManager.stopAltitudeUpdates()
            case .location:
                locationManager.stopLocationUpdates()
        }
    }

    private func deleteValues() {
        switch sensor {
            case .motion:
                motionManager.resetDeviceMotionUpdates()
            case .altitude:
                motionManager.resetAltitudeUpdates()
            case .location:
                locationManager.resetLocationUpdates()
        }
    }

    private func toggleRecording() {
        if recordingManager.isRecording {
            WKInterfaceDevice.current().play(.stop)
            recordingController.stop()
        } else {
            WKInterfaceDevice.current().play(.start)
            recordingController.start()
        }
    }
}
