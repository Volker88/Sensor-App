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
    
    // MARK: - Body
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Sidebar()
                    HomeView()
                } else if UIDevice.current.userInterfaceIdiom == .phone {
                    HomeView()
                }
            }.customNavigationViewStyle()
        }
    }
}
