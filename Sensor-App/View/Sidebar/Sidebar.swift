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
    @State private var showSettings = false
    
    
    // MARK: - Methods
    
    // MARK: - Content
    var list: some View {
        List {
            Group {
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Home", comment: "Sidebbar - Location"), systemImage: "house")
                        .accessibility(identifier: "Home")
                }
                
                NavigationLink(destination: LocationScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Location", comment: "Sidebbar - Location"), systemImage: "location")
                        .accessibility(identifier: "Location")
                }
                NavigationLink(destination: AccelerationScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Acceleration", comment: "Sidebbar - Acceleration"), systemImage: "globe")
                        .accessibility(identifier: "Acceleration")
                }
                NavigationLink(destination: GravityScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gravity", comment: "Sidebbar - Gravity"), systemImage: "globe")
                        .accessibility(identifier: "Gravity")
                }
                NavigationLink(destination: GyroscopeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gyroscope", comment: "Sidebbar - Gyroscope"), systemImage: "globe")
                        .accessibility(identifier: "Gyroscope")
                }
            }
            
            Group {
                NavigationLink(destination: MagnetometerScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Magnetometer", comment: "Sidebbar - Magnetometer"), systemImage: "globe")
                        .accessibility(identifier: "Magnetometer")
                }
                NavigationLink(destination: AttitudeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Attitude", comment: "Sidebbar - Attitude"), systemImage: "globe")
                        .accessibility(identifier: "Attitude")
                }
                NavigationLink(destination: AltitudeScreen().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Altitude", comment: "Sidebbar - Altitude"), systemImage: "globe")
                        .accessibility(identifier: "Altitude")
                }
                if UIDevice.current.userInterfaceIdiom == .phone {
                    Button(action: {
                        showSettings.toggle()
                    }) {
                        Label(NSLocalizedString("Settings", comment: "Sidebbar - Settings"), systemImage: "gear")
                            .accessibility(identifier: "Settings")
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .sheet(isPresented: $showSettings) {
            SettingsScreen()
        }
    }
    
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Return View
        VStack(spacing: 0) {
            list
            if UIDevice.current.userInterfaceIdiom == .pad {
                SettingsOverlay()
            }
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
