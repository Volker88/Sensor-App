//
//  SensorScreenModifier.swift
//  Sensor-App-WatchApp
//
//  Created by Volker Schmitt on 24.10.26.
//

import Sensor_App_Framework
import SwiftUI

/// The shared lifecycle of a watch sensor screen: claims the sensor's updates on
/// appear, releases them on disappear, and adds the `SensorControls` toolbar.
struct SensorScreenModifier: ViewModifier {

    @Environment(LocationManager.self) private var locationManager
    @Environment(MotionManager.self) private var motionManager
    @Environment(SettingsManager.self) private var settingsManager

    let sensor: MonitoredSensor

    // Unique per screen instance, so an outgoing screen's late onDisappear can't
    // release the claim of the incoming screen that just appeared.
    @State private var client = UUID().uuidString

    func body(content: Content) -> some View {
        content
            .toolbar { SensorControls(sensor: sensor) }
            .onAppear(perform: onAppear)
            .onDisappear(perform: onDisappear)
    }

    // MARK: - Methods
    private func onAppear() {
        switch sensor {
            case .motion:
                motionManager.sensorUpdateInterval = settingsManager.fetchUserSettings().frequencySetting
                motionManager.startMotionUpdates(for: client)
            case .altitude:
                motionManager.sensorUpdateInterval = settingsManager.fetchUserSettings().frequencySetting
                motionManager.startAltitudeUpdates(for: client)
            case .location:
                locationManager.startLocationUpdates(for: client)
        }
    }

    /// Only stops/resets once no other screen still needs the updates.
    private func onDisappear() {
        switch sensor {
            case .motion:
                motionManager.releaseMotionUpdates(for: client)
            case .altitude:
                motionManager.releaseAltitudeUpdates(for: client)
            case .location:
                locationManager.releaseLocationUpdates(for: client)
        }
    }
}

extension View {
    /// Starts and stops `sensor` with the screen's lifecycle and adds the sensor controls.
    func sensorScreen(_ sensor: MonitoredSensor) -> some View {
        modifier(SensorScreenModifier(sensor: sensor))
    }
}
