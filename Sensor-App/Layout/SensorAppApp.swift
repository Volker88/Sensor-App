//
//  SensorAppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//

import AppIntents
import OSLog
import Sensor_App_Framework
import SwiftUI

@main
struct SensorAppApp: App {

    @Environment(\.scenePhase) private var scenePhase

    @State private var appState: AppState
    @State private var update = AppUpdates()
    @State private var locationManager = LocationManager()
    @State private var motionManager = MotionManager()
    @State private var settingsManager = SettingsManager()
    @State private var calculationManager = CalculationManager()

    init() {
        let appStateManager = AppState()
        appState = appStateManager
        #if DEBUG
            if CommandLine.arguments.contains("disable-animations") {
                UIView.setAnimationsEnabled(false)
            }
        #endif

        // MARK: - Register App Dependency
        // AppDependencyManager.shared.add(dependency: appStateManager) // Original function call
        AppDependencyManager.shared.add(key: "AppState", dependency: appStateManager)
        CustomAppDependencyManager.shared.add(key: "AppState", dependency: appStateManager)
    }

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
                .onAppear(perform: update.checkForUpdate)
                .onAppear(perform: appState.updateShortcutParameter)
                .sheet(isPresented: $update.showReleaseNotes) { ReleaseNotesScreen() }
                .withNotificationView()
        }
    }
}
