//
//  RecordingController.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 24.10.26.
//

import Sensor_App_Framework
import SwiftUI

/// The single iOS start/stop path for a recording, shared by `CustomControlsView`
/// and `RecordingControlSection` so both entry points behave identically.
struct RecordingController {

    let recordingManager: RecordingManager
    let motionManager: MotionManager
    let locationManager: LocationManager
    let settingsManager: SettingsManager

    /// Restarts every sensor from empty buffers, so the session only contains data
    /// captured after the tap, then begins recording.
    func start() {
        // Stop first, so setting the update interval below doesn't restart running streams.
        motionManager.stopMotionUpdates()
        locationManager.stopLocationUpdates()
        motionManager.resetMotionUpdates()
        locationManager.resetLocationUpdates()

        motionManager.sensorUpdateInterval = settingsManager.fetchUserSettings().frequencySetting
        motionManager.startMotionUpdates()
        motionManager.startAltitudeUpdates()
        locationManager.startLocationUpdates()

        recordingManager.startRecording()
    }

    /// Stops the sensors, saves the session in the background, then clears the sensors.
    ///
    /// The sensor arrays are copied when the save starts, so the buffers stay on screen until the
    /// save has finished.
    /// - Returns: `true` if the session was saved.
    @discardableResult
    func stop() async -> Bool {
        motionManager.stopMotionUpdates()
        locationManager.stopLocationUpdates()

        let saved = await recordingManager.stopRecording(
            motionArray: motionManager.motionArray,
            altitudeArray: motionManager.altitudeArray,
            locationArray: locationManager.locationArray,
            source: UIDevice.current.userInterfaceIdiom == .pad ? "iPad" : "iPhone"
        )

        motionManager.resetMotionUpdates()
        locationManager.resetLocationUpdates()
        return saved
    }
}
