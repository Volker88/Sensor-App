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
    
    
    // MARK: - @State Variables
    @State var showSettings = false
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - Body
    var body: some View {
        
        // MARK: - Return View
        return NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: SettingsAPI.shared.backgroundColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                GeometryReader { g in
                    ScrollView {
                        VStack {
                            Spacer()
                            Group {
                                ContentViewButton(type: .contentViewHeader, text: "Welcome to the \n Sensor-App")
                                    .frame(height: 100, alignment: .center)
                                Spacer()
                                NavigationLink(destination: LocationView()) {
                                    ContentViewButton(type: nil, text: "Location")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                NavigationLink(destination: AccelerationView()) {
                                    ContentViewButton(type: nil, text: "Acceleration")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                NavigationLink(destination: GravityView()) {
                                    ContentViewButton(type: nil, text: "Gravity")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                NavigationLink(destination: GyroscopeView()) {
                                    ContentViewButton(type: nil, text: "Gyroscope")
                                    .frame(height: 50, alignment: .center)
                                }
                            }
                            Spacer()
                            Group {
                                NavigationLink(destination: MagnetometerView()) {
                                    ContentViewButton(type: nil, text: "Magnetometer")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                NavigationLink(destination: AttitudeView()) {
                                    ContentViewButton(type: nil, text: "Attitude")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                NavigationLink(destination: AltitudeView()) {
                                    ContentViewButton(type: nil, text: "Altitude")
                                    .frame(height: 50, alignment: .center)
                                }
                                Spacer()
                                Button(action: { self.showSettings.toggle() }) {
                                    ContentViewButton(type: nil, text: "Settings")
                                    .frame(height: 50, alignment: .center)
                                }
                            }
                            Spacer()
                        }
                        .offset(x: 5)
                        .navigationBarTitle("Home", displayMode: .inline)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}


// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone 11 Pro")
            ContentView().previewDevice("iPhone 11 Pro")
                .environment(\.colorScheme, .dark)
            //ContentView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //ContentView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
