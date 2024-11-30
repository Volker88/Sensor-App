//
//  SensorAppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//

import OSLog
import SwiftUI

@main
struct SensorAppApp: App {

    @Environment(\.scenePhase) private var scenePhase

    @State private var appState = AppState()
    @State private var update = AppUpdates()
    @State private var locationManager = LocationManager()
    @State private var motionManager = MotionManager()
    @State private var settingsManager = SettingsManager()
    @State private var calculationManager = CalculationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(locationManager)
                .environment(motionManager)
                .environment(calculationManager)
                .environment(settingsManager)
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                        case .active:
                            Logger.scenePhase.debug("ScenePhase: Active")
                        case .inactive:
                            Logger.scenePhase.debug("ScenePhase: Inactive")
                        case .background:
                            Logger.scenePhase.debug("ScenePhase: Background")
                        @unknown default:
                            Logger.scenePhase.debug("ScenePhase: Unknown")
                    }
                }
                .onAppear {
                    update.checkForUpdate()
                }
                .sheet(isPresented: $update.showReleaseNotes) { ReleaseNotesScreen() }
                .withNotificationView()
        }
    }
}
