//
//  Sensor_AppApp.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 19.07.20.
//

import Sensor_App_Framework
import SwiftData
import SwiftUI

@main
struct SensorAppApp: App {

    @State private var locationManager = LocationManager()
    @State private var motionManager = MotionManager()
    @State private var settingsManager = SettingsManager()
    @State private var calculationManager = CalculationManager()
    @State private var recordingManager = RecordingManager()

    let modelContainer: ModelContainer

    init() {
        var inMemory = false

        #if DEBUG
            if CommandLine.arguments.contains("enable-testing") {
                inMemory = true
            }
        #endif

        let swiftDataContainer = SwiftDataContainer(inMemory: inMemory)
        // The watch app cannot function without storage, so a nil container is genuinely fatal here.
        // Unwrap explicitly so the failure is attributed to the app, not buried in shared framework
        // code that widgets/extensions deliberately tolerate.
        guard let modelContainer = swiftDataContainer.modelContainer else {
            fatalError("The watch app requires a SwiftData model container, but none could be created.")
        }
        self.modelContainer = modelContainer
    }

    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environment(locationManager)
            .environment(motionManager)
            .environment(calculationManager)
            .environment(settingsManager)
            .environment(recordingManager)
            .modelContainer(modelContainer)
            .task { recordingManager.modelContext = modelContainer.mainContext }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
