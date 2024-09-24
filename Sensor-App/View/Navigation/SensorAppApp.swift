//
//  SensorAppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//

import SwiftUI
import OSLog

@main
struct SensorAppApp: App {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var update = AppUpdates()
    @StateObject var appState: AppState

    @State private var locationManager = LocationManager()
    @State private var motionManager = MotionManager()
    @State private var settingsManager = SettingsManager()
    @State private var calculationManager = CalculationManager()

    init() {
        let appState = AppState()
        _appState = StateObject(wrappedValue: appState)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(motionManager)
                .environment(calculationManager)
                .environment(settingsManager)
                .environment(locationManager)
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
                .sheet(isPresented: $update.showReleaseNotes) { ReleaseNotes() }
            // .sheet(isPresented: .constant(true)) { ReleaseNotes() }
        }
    }
}
