//
//  Sensor_AppApp.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 19.07.20.
//

import Sensor_App_Framework
import SwiftUI

@main
struct SensorAppApp: App {

    @State private var locationManager = LocationManager()
    @State private var motionManager = MotionManager()
    @State private var settingsManager = SettingsManager()
    @State private var calculationManager = CalculationManager()

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
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
