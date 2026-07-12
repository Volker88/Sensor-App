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
            NavigationLink(destination: WatchRecordingView()) {
                Label("Record Session", systemImage: "record.circle")
            }

            NavigationLink(destination: LocationView()) {
                Label("Location", systemImage: "location")
            }
            .accessibilityIdentifier(UIIdentifiers.ContentView.locationButton)

            NavigationLink(destination: AccelerationView()) {
                Label("Acceleration", systemImage: "bolt.fill")
            }
            .accessibilityIdentifier(UIIdentifiers.ContentView.accelerationButton)

            NavigationLink(destination: GravityView()) {
                Label("Gravity", systemImage: "arrow.down")
            }
            NavigationLink(destination: GyroscopeView()) {
                Label("Gyroscope", systemImage: "gyroscope")
            }
            NavigationLink(destination: MagnetometerView()) {
                Label("Magnetometer", systemImage: "wave.3.right")
            }
            NavigationLink(destination: AttitudeView()) {
                Label("Attitude", systemImage: "dial.medium")
            }
            NavigationLink(destination: AltitudeView()) {
                Label("Altitude", systemImage: "mountain.2")
            }
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gear")
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
