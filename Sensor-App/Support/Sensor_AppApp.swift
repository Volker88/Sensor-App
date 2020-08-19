//
//  Sensor_AppApp.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 19.07.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct / Class Definition
@main
struct Sensor_AppApp: App {
    @Environment(\.scenePhase) var scenePhase
    // MARK: - Body
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Sidebar()
                    ContentView()
                } else if UIDevice.current.userInterfaceIdiom == .phone {
                    ContentView()
                }
            }
            .customNavigationViewStyle()
            .onChange(of: scenePhase) { phase in
                switch phase {
                    case .active:
                        print("ScenePhase: Active")
                    case .inactive:
                        print("ScenePhase: Inactive")
                    case .background:
                        print("ScenePhase: Background")
                    @unknown default:
                        print("ScenePhase: Unknown")
                        #warning("Add Logging to the phases")
                }
            }
        }
    }
}
