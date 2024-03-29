//
//  ContentView.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 20.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var showSettings = false

    var body: some View {
        List {
            NavigationLink(destination: LocationView()) {
                Text("Location", comment: "ContentView - Location (watchOS)")
            }
            NavigationLink(destination: AccelerationView()) {
                Text("Acceleration", comment: "ContentView - Acceleration (watchOS)")
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
            }
        }
        .navigationTitle(NSLocalizedString("Home", comment: "ContentView - NavigationBar Title (watchOS)"))
        .listStyle(CarouselListStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("Apple Watch Series 3 - 38mm")
            ContentView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
