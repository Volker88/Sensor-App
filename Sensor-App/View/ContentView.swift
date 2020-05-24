//
//  ContentView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct ContentView: View {
    
    // MARK: - Initialize Classes
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @State var showSettings = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Return View
        return NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: settings.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                GeometryReader { g in
                    ScrollView {
                        VStack {
                            Spacer()
                            Group {
                                VStack {
                                    Text("Welcome to the", comment: "ContentView - Welcome Label")
                                    Text("Sensor-App", comment: "ContentView - Sensor-App")
                                }
                                .contentViewTitleModifier()
                            }
                            .frame(height: 100, alignment: .center)
                            Group {
                                NavigationLink(destination: LocationView()) {
                                    Text("Location", comment: "ContentView - Location")
                                        .contentViewButtonModifier(accessibility: "Location")
                                }
                                NavigationLink(destination: AccelerationView()) {
                                    Text("Acceleration", comment: "ContentView - Acceleration")
                                        .contentViewButtonModifier(accessibility: "Acceleration")
                                }
                                NavigationLink(destination: GravityView()) {
                                    Text("Gravity", comment: "ContentView - Gravity")
                                        .contentViewButtonModifier(accessibility: "Gravity")
                                }
                                NavigationLink(destination: GyroscopeView()) {
                                    Text("Gyroscope", comment: "ContentView - Gyroscope")
                                        .contentViewButtonModifier(accessibility: "Gyroscope")
                                }
                            }
                            .frame(height: 50, alignment: .center)
                            Group {
                                NavigationLink(destination: MagnetometerView()) {
                                    Text("Magnetometer", comment: "ContentView - Magnetometer")
                                        .contentViewButtonModifier(accessibility: "Magnetometer")
                                }
                                NavigationLink(destination: AttitudeView()) {
                                    Text("Attitude", comment: "ContentView - Attitude")
                                        .contentViewButtonModifier(accessibility: "Attitude")
                                }
                                NavigationLink(destination: AltitudeView()) {
                                    Text("Altitude", comment: "ContentView - Altitude")
                                        .contentViewButtonModifier(accessibility: "Altitude")
                                }
                                Button(action: { self.showSettings.toggle() }) {
                                    Text("Settings", comment: "ContentView - Settings")
                                        .contentViewButtonModifier(accessibility: "Settings")
                                }
                            }
                            .frame(height: 50, alignment: .center)
                        }
                        .navigationBarTitle("\(NSLocalizedString("Home", comment: "ContentView - NavigationBar Title"))", displayMode: .inline)
                        Spacer()
                    }
                    .offset(x: 5)
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ContentView()
                .colorScheme(scheme)
        }
    }
}
