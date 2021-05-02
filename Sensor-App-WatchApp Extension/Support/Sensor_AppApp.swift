//
//  Sensor_AppApp.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 19.07.20.
//

import SwiftUI

@main
struct Sensor_AppApp: App { // swiftlint:disable:this type_name
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
