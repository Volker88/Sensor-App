//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct LocationView: View {

    @Environment(LocationManager.self) var locationManager

    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()

    var body: some View {
        List {
            Text("Latitude: \(locationManager.location?.latitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude (watchOS)")
            Text("Longitude: \(locationManager.location?.longitude ?? 0.0, specifier: "%.10f")° ± \(locationManager.location?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude (watchOS)")
            Text("Altitude: \(locationManager.location?.altitude ?? 0.0, specifier: "%.2f") ± \(locationManager.location?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude (watchOS)")
            Text("Direction: \(locationManager.location?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction (watchOS)")
            Text(verbatim: "\(NSLocalizedString("Speed:", comment: "LocationView - Speed (watchOS)")) \(calculationAPI.calculateSpeed(ms: locationManager.location?.speed ?? 0.0, to: "\(settings.fetchUserSettings().GPSSpeedSetting)")) \(settings.fetchUserSettings().GPSSpeedSetting)")
        }
        .navigationTitle(NSLocalizedString("Location", comment: "LocationView - NavigationBar Title (watchOS)"))
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    }

    func onAppear() {
        locationManager.startLocationUpdates()
    }

    func onDisappear() {
        locationManager.stopLocationUpdates()
        locationManager.resetLocationUpdates()
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationView().previewDevice("Apple Watch Series 3 - 38mm")
            LocationView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
