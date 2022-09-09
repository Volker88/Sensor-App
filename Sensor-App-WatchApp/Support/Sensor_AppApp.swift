//
//  Sensor_AppApp.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 19.07.20.
//

import SwiftUI

@main
struct SensorAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
