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
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Home", comment: "ContentView - Home"), systemImage: "house")// TODO: Remove
                        .accessibility(identifier: "Home")
                }
                NavigationLink(destination: Location().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Location", comment: "ContentView - Location"), systemImage: "location")
                        .accessibility(identifier: "Location")
                }
                NavigationLink(destination: Acceleration().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Acceleration", comment: "ContentView - Acceleration"), systemImage: "globe")
                        .accessibility(identifier: "Acceleration")
                }
                NavigationLink(destination: Gravity().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gravity", comment: "ContentView - Gravity"), systemImage: "globe")
                        .accessibility(identifier: "Gravity")
                }
                NavigationLink(destination: Gyroscope().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Gyroscope", comment: "ContentView - Gyroscope"), systemImage: "globe")
                        .accessibility(identifier: "Gyroscope")
                }
            }
            
            Group {
                NavigationLink(destination: Magnetometer().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Magnetometer", comment: "ContentView - Magnetometer"), systemImage: "globe")
                        .accessibility(identifier: "Magnetometer")
                }
                NavigationLink(destination: Attitude().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Attitude", comment: "ContentView - Attitude"), systemImage: "globe")
                        .accessibility(identifier: "Attitude")
                }
                NavigationLink(destination: Altitude().navigationBarBackButtonHidden(true)) {
                    Label(NSLocalizedString("Altitude", comment: "ContentView - Altitude"), systemImage: "globe")
                        .accessibility(identifier: "Altitude")
                }
                if UIDevice.current.userInterfaceIdiom == .phone {
                    NavigationLink(destination: SettingsView().navigationBarBackButtonHidden(true)) {
                        Label(NSLocalizedString("Settings", comment: "ContentView - Settings"), systemImage: "gear")
                            .accessibility(identifier: "Settings")
                    }
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
