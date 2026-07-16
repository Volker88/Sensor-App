//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import Sensor_App_Framework
import SwiftUI

struct LocationView: View {

    @Environment(LocationManager.self) private var locationManager
    @Environment(SettingsManager.self) private var settingsManager

    @State private var frequency = 1.0  // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Group {
                Text(
                    "Latitude: \(locationManager.location?.latitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.calculatedHorizontalAccuracy ?? 0.0, specifier: "%.2f") \(locationManager.location?.horizontalAccuracyUnit ?? "m")"
                )

                Text(
                    "Longitude: \(locationManager.location?.longitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.calculatedHorizontalAccuracy ?? 0.0, specifier: "%.2f") \(locationManager.location?.horizontalAccuracyUnit ?? "m")"
                )

                Text(
                    "Altitude: \(locationManager.location?.calculatedAltitude ?? 0.0, specifier: "%.2f") \(locationManager.location?.heightUnit ?? "m") ± \(locationManager.location?.calculatedVerticalAccuracy ?? 0.0, specifier: "%.2f") \(locationManager.location?.heightUnit ?? "m")"
                )

                Text("Direction: \(locationManager.location?.course ?? 0.0, specifier: "%.2f")°")

                Text(
                    "Speed: \(locationManager.location?.calculatedSpeed ?? 0.0, specifier: "%.1f") \(locationManager.location?.speedUnit ?? "")"
                )
            }
            .accessibilityAddTraits(.updatesFrequently)
            .accessibilityRemoveTraits(.isStaticText)
        }
        .navigationTitle("Location")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    // MARK: - Methods
    func onAppear() {
        locationManager.startLocationUpdates()
    }

    func onDisappear() {
        locationManager.stopLocationUpdates()
        locationManager.resetLocationUpdates()
    }
}

// MARK: - Preview
#Preview("LocationView - English") {
    LocationView()
}

#Preview("LocationView - German") {
    LocationView()
        .previewLocalization(.german)
}
