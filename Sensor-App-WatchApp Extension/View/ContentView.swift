//
//  ContentView.swift
//  Sensor-App-WatchApp Extension
//
//  Created by Volker Schmitt on 20.10.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct ContentView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State Variables
    @State var showSettings = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - Body
    var body: some View {
        
        
        // MARK: - Return View
        return
            List {
                NavigationLink(destination: LocationView()) {
                    Text("Location")
                }
                NavigationLink(destination: AccelerationView()) {
                    Text("Acceleration")
                }
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
            }
            .listStyle(CarouselListStyle())
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("Apple Watch Series 3 - 38mm")
            ContentView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
