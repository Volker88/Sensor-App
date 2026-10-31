//
//  WatchRecordingController.swift
//  Sensor-App-WatchApp
//
//  Created by Volker Schmitt on 24.10.26.
//

import Sensor_App_Framework

/// The single watch start/stop path for a recording, shared by `WatchRecordingView`
/// and the Record button in every sensor screen's `SensorControls`.
///
/// The recording holds its own claim on every sensor under a stable client ID, so
/// navigating between (or away from) sensor screens mid-recording never stops the
/// sensors: each screen only drops its own claim.
struct WatchRecordingController {

    private static let client = "WatchRecording"

    let recordingManager: RecordingManager
    let motionManager: MotionManager
    let locationManager: LocationManager
    let settingsManager: SettingsManager

    /// Clears the buffers, so the session only contains data captured after the tap,
    /// claims every sensor for the recording, then begins recording.
    func start() {
        motionManager.resetMotionUpdates()
        locationManager.resetLocationUpdates()

        motionManager.sensorUpdateInterval = settingsManager.fetchUserSettings().frequencySetting
        motionManager.startMotionUpdates(for: Self.client)
        motionManager.startAltitudeUpdates(for: Self.client)
        locationManager.startLocationUpdates(for: Self.client)

        recordingManager.startRecording()
    }

    /// Saves the session in the background, then clears the buffers and drops the recording's
    /// sensor claim. Sensors a visible screen still claims keep running.
    ///
    /// The sensor arrays are copied when the save starts, so samples arriving during the save
    /// aren't part of the session.
    /// - Returns: `true` if the session was saved.
    @discardableResult
    func stop() async -> Bool {
        let saved = await recordingManager.stopRecording(
            motionArray: motionManager.motionArray,
            altitudeArray: motionManager.altitudeArray,
            locationArray: locationManager.locationArray,
            source: "Apple Watch"
        )

        motionManager.resetMotionUpdates()
        locationManager.resetLocationUpdates()

        motionManager.releaseMotionUpdates(for: Self.client)
        motionManager.releaseAltitudeUpdates(for: Self.client)
        locationManager.releaseLocationUpdates(for: Self.client)
        return saved
    }
}
