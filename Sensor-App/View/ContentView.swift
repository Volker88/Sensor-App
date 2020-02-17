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
    
    
    // MARK: - @State Variables
    @State var showSettings = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        
    }
    
    func onDisappear() {
        
    }
    
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
                                Text("Welcome to the \n Sensor-App")
                                    .modifier(ContentViewTitleModifier())
                            }
                            .frame(height: 100, alignment: .center)
                            Group {
                                NavigationLink(destination: LocationView()) {
                                    Text("Location")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Location")
                                }
                                NavigationLink(destination: AccelerationView()) {
                                    Text("Acceleration")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Acceleration")
                                }
                                NavigationLink(destination: GravityView()) {
                                    Text("Gravity")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Gravity")
                                }
                                NavigationLink(destination: GyroscopeView()) {
                                    Text("Gyroscope")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Gyroscope")
                                }
                            }
                            .frame(height: 50, alignment: .center)
                            Group {
                                NavigationLink(destination: MagnetometerView()) {
                                    Text("Magnetometer")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Magnetometer")
                                }
                                NavigationLink(destination: AttitudeView()) {
                                    Text("Attitude")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Attitude")
                                }
                                NavigationLink(destination: AltitudeView()) {
                                    Text("Altitude")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Altitude")
                                }
                                Button(action: { self.showSettings.toggle() }) {
                                    Text("Settings")
                                        .modifier(ContentViewButtonModifier())
                                        .accessibility(identifier: "Settings")
                                }
                            }
                            .frame(height: 50, alignment: .center)
                        }
                        .navigationBarTitle("Home", displayMode: .inline)
                        Spacer()
                    }
                    .offset(x: 5)
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
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
