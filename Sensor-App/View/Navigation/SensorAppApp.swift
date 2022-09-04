//
//  SensorAppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//

import SwiftUI

@main
struct SensorAppApp: App {
    @Environment(\.scenePhase) var scenePhase

    @StateObject var update = AppUpdates()
    @StateObject var appState: AppState
    @StateObject var motionVM = CoreMotionViewModel()
    let settingsAPI = SettingsAPI()

    init() {
        let appState = AppState()
        _appState = StateObject(wrappedValue: appState)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(motionVM)
                .environmentObject(settingsAPI)
                .onChange(of: scenePhase) { phase in
                    switch phase {
                        case .active:
                            Log.shared.add(.scenePhase, .default, "ScenePhase: Active")
                        case .inactive:
                            Log.shared.add(.scenePhase, .default, "ScenePhase: Inactive")
                        case .background:
                            Log.shared.add(.scenePhase, .default, "ScenePhase: Background")
                        @unknown default:
                            Log.shared.add(.scenePhase, .error, "ScenePhase: Unknown")
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
