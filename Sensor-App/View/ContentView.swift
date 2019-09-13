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
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - Body
    var body: some View {
        
        return NavigationView {
            GeometryReader { g in
                ScrollView {
                    VStack {
                        Spacer()
                        Group {
                            Text("Welcome to the \n Sensor-App")
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .multilineTextAlignment(.center)
                                .frame(width: g.size.width - 10, height: CGFloat(100), alignment: .center)
                                .background(Color("HeaderBackgroundColor"))
                                .foregroundColor(Color("HeaderTextColor"))
                                .cornerRadius(10)
                            Spacer()
                            NavigationLink(destination: LocationView()) {
                                Text("Location")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            Spacer()
                            NavigationLink(destination: AccelerationView()) {
                                Text("Acceleration")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            
                            Spacer()
                            NavigationLink(destination: GravityView()) {
                                Text("Gravity")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            Spacer()
                            NavigationLink(destination: GyroscopeView()) {
                                Text("Gyroscope")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                        }
                        .font(.title)
                        .foregroundColor(Color("StandardTextColor"))
                        .background(Color("StandardBackgroundColor"))
                        .cornerRadius(10)
                        
                        Spacer()
                        Group {
                            NavigationLink(destination: MagnetometerView()) {
                                Text("Magnetometer")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            Spacer()
                            NavigationLink(destination: AttitudeView()) {
                                Text("Attitude")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            Spacer()
                            NavigationLink(destination: AltitudeView()) {
                                Text("Altitude")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                            Spacer()
                            NavigationLink(destination: SettingsView()) {
                                Text("Settings")
                                    .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .center)
                            }
                        }
                        .font(.title)
                        .foregroundColor(Color("StandardTextColor"))
                        .background(Color("StandardBackgroundColor"))
                        .cornerRadius(10)
                        
                        Spacer()
                    }.navigationBarTitle("Home", displayMode: .inline)
                }
            }.background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}


// MARK: - Preview
#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().previewDevice("iPhone Xs")
            ContentView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //ContentView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //ContentView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
