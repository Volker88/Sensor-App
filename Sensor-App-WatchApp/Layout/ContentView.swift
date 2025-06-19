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
                Text("Location")
            }
            .accessibilityIdentifier(UIIdentifiers.ContentView.locationButton)

            NavigationLink(destination: AccelerationView()) {
                Text("Acceleration")
            }
            .accessibilityIdentifier(UIIdentifiers.ContentView.accelerationButton)

            NavigationLink(destination: GravityView()) {
                Text("Gravity")
            }
            NavigationLink(destination: GyroscopeView()) {
                Text("Gyroscope")
            }
            NavigationLink(destination: MagnetometerView()) {
                Text("Magnetometer")
            }
            NavigationLink(destination: AttitudeView()) {
                Text("Attitude")
            }
            NavigationLink(destination: AltitudeView()) {
                Text("Altitude")
            }
            NavigationLink(destination: SettingsView()) {
                Text("Settings")
            }
            .accessibilityIdentifier(UIIdentifiers.ContentView.settingsButton)
        }
        .accessibilityIdentifier(UIIdentifiers.ContentView.collectionView)
        .navigationTitle("Home")
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
