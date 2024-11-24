//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct LocationView: View {

    @Environment(LocationManager.self) private var locationManager
    @Environment(SettingsManager.self) private var settingsManager

    @State private var frequency = 1.0 // Default Frequency

    // MARK: - Body
    var body: some View {
        List {
            Text("Latitude: \(locationManager.location?.latitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude (watchOS)")
            Text("Longitude: \(locationManager.location?.longitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude (watchOS)")
            Text("Altitude: \(locationManager.location?.altitude ?? 0.0, specifier: "%.2f") ± \(locationManager.location?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude (watchOS)")
            Text("Direction: \(locationManager.location?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction (watchOS)")
            Text("Speed: \(locationManager.location?.calculatedSpeed ?? 0.0, specifier: "%.1f") \(locationManager.location?.speedUnit ?? "")")
        }
        .navigationTitle(Text("Location", comment: "NavigationBar Title - Location sensor screen"))
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
