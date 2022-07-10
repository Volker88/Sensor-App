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

    @ObservedObject var update = AppUpdates()
    @StateObject var appState: AppState

    init() {
        let appState = AppState()
        _appState = StateObject(wrappedValue: appState)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
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
