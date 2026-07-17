//
//  SensorAppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//

import AppIntents
import OSLog
import Sensor_App_Framework
import SwiftData
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
    @State private var recordingManager = RecordingManager()
    @State private var metricKitManager = MetricKitManager()

    let modelContainer: ModelContainer

    init() {
        let appStateManager = AppState()
        appState = appStateManager

        var inMemory = false
        InitializeCloudKitSchema.initialize(false)

        #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                inMemory = true

                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
            }

            if CommandLine.arguments.contains("disable-animations") {
                #if !os(macOS)
                    UIView.setAnimationsEnabled(false)
                #endif
            }
        #endif

        let swiftDataContainer = SwiftDataContainer(inMemory: inMemory)
        // The main app cannot function without storage, so a nil container is genuinely fatal here.
        // Unwrap explicitly so the failure is attributed to the app, not buried in shared framework
        // code that widgets/extensions deliberately tolerate.
        guard let modelContainer = swiftDataContainer.modelContainer else {
            fatalError("The main app requires a SwiftData model container, but none could be created.")
        }
        self.modelContainer = modelContainer

        // MARK: - Register App Dependency
        AppDependencyManager.shared.add(dependency: appStateManager)  // Original function call
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .environment(locationManager)
                .environment(motionManager)
                .environment(calculationManager)
                .environment(settingsManager)
                .environment(recordingManager)
                .environment(metricKitManager)
                .modelContainer(modelContainer)
                .task { recordingManager.modelContext = modelContainer.mainContext }
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
