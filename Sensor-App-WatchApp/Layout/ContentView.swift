//
//  ContentView.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 20.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct ContentView: View {

    @State private var showSettings = false

    // MARK: - Body
    var body: some View {
        List {
            NavigationLink(destination: LocationView()) {
                Text("Location", comment: "ContentView - Location (watchOS)")
                    .accessibilityIdentifier("Location")
            }
            NavigationLink(destination: AccelerationView()) {
                Text("Acceleration", comment: "ContentView - Acceleration (watchOS)")
                    .accessibilityIdentifier("Acceleration")
            }
            NavigationLink(destination: GravityView()) {
                Text("Gravity", comment: "ContentView - Gravity (watchOS)")
            }
            NavigationLink(destination: GyroscopeView()) {
                Text("Gyroscope", comment: "ContentView - Gyroscope (watchOS)")
            }
            NavigationLink(destination: MagnetometerView()) {
                Text("Magnetometer", comment: "ContentView - Magnetometer (watchOS)")
            }
            NavigationLink(destination: AttitudeView()) {
                Text("Attitude", comment: "ContentView - Attitude (watchOS)")
            }
            NavigationLink(destination: AltitudeView()) {
                Text("Altitude", comment: "ContentView - Altitude (watchOS)")
            }
            NavigationLink(destination: SettingsView()) {
                Text("Settings", comment: "ContentView - Settings (watchOS)")
                    .accessibilityIdentifier("Settings")
            }
        }
        .accessibilityIdentifier("Navigation")
        .navigationTitle(Text("Home", comment: "NavigationBar Title - Home screen"))
        .listStyle(CarouselListStyle())
    }
}

// MARK: - Preview
#Preview("ContentView - English") {
    ContentView()
}

#Preview("ContentView - German") {
    ContentView()
        .previewLocalization(.german)
}
