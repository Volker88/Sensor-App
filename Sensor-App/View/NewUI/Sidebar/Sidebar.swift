//
//  Sidebar.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 16.08.20.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct / Class Definition
struct Sidebar: View {
    
    // MARK: - Initialize Classes
    
    // MARK: - Environment Object

    
    // MARK: - @State / @ObservedObject / @Binding

    
    // MARK: - Methods
    
    
    // MARK: - Content
    var list: some View {
        List {
            Group {
                NavigationLink(destination: ContentView()) {
                    Text("ContentView", comment: "ContentView - Location") // TODO: Remove
                        .accessibility(identifier: "Location")
                }
                NavigationLink(destination: LocationView()) {
                    Text("Location", comment: "ContentView - Location")
                        .accessibility(identifier: "Location")
                }
                NavigationLink(destination: AccelerationView()) {
                    Text("Acceleration", comment: "ContentView - Acceleration")
                        .accessibility(identifier: "Acceleration")
                }
                NavigationLink(destination: GravityView()) {
                    Text("Gravity", comment: "ContentView - Gravity")
                        .accessibility(identifier: "Gravity")
                }
                NavigationLink(destination: GyroscopeView()) {
                    Text("Gyroscope", comment: "ContentView - Gyroscope")
                        .accessibility(identifier: "Gyroscope")
                }
            }

            Group {
                NavigationLink(destination: MagnetometerView()) {
                    Text("Magnetometer", comment: "ContentView - Magnetometer")
                        .accessibility(identifier: "Magnetometer")
                }
                NavigationLink(destination: AttitudeView()) {
                    Text("Attitude", comment: "ContentView - Attitude")
                        .accessibility(identifier: "Attitude")
                }
                NavigationLink(destination: AltitudeView()) {
                    Text("Altitude", comment: "ContentView - Altitude")
                        .accessibility(identifier: "Altitude")
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    
    // MARK: - Body
    @ViewBuilder
    var body: some View {
        
        // MARK: - Return View
        VStack(spacing: 0) {
            list
            SettingsOverlay()
        }
        .edgesIgnoringSafeArea(.all)
    }
}


// MARK: - Preview
struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            Sidebar()
                .colorScheme(scheme)
        }
    }
}
