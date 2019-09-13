//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 13.09.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI
import Combine


// MARK: - Struct
struct LocationView: View {
    
    // MARK: - Initialize Classes
    

    // MARK: - @State Variables
    @State var GPSLatitude: String = "0.0"
    @State var GPSLongitude: String = "0.0"
    @State var GPSHorizontalAccuracy = "0.0"
    @State var GPSAltitude = "0.0"
    @State var GPSVerticalAccuracy = "0.0"
    @State var GPSSpeed = "0.0"
    @State var GPSCourse = "0.0"
    @State var GPSTimestamp = "0.0"
    @State var GPSDesiredAccuracy = "0.0"
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    func locationStart() {
        CoreLocationAPI.shared.startGPS()
        CoreLocationAPI.shared.locationCompletionHandler = { GPS in
            
            // Timestamp into String
            let date = DateFormatter()
            date.timeZone = NSTimeZone(abbreviation: "CET") as TimeZone?
            date.dateFormat = "dd-MM-yyyy - HH:mm:ss.SSS"
            let datestring = date.string(from: GPS.timestamp)
            
            // Get GPS Variables from GPSModel
            self.GPSLatitude = String(format: "%.10f", GPS.latitude) // Latitude - Breitengrad
            self.GPSLongitude = String(format: "%.10f", GPS.longitude) // Longitude - Längengrad
            self.GPSHorizontalAccuracy = String(format: "%.2f", GPS.horizontalAccuracy) // Horizontal Accuracy
            self.GPSAltitude = String(format: "%.2f", GPS.altitude) // Altitude - Höhe
            self.GPSVerticalAccuracy = String(format: "%.2f", GPS.verticalAccuracy) // Vertcal Accuracy
            self.GPSSpeed = String(format: "%.2f", CalculationAPI.shared.calculateSpeed(ms: GPS.speed, to: "\(SettingsForUserDefaults.GPSSpeedSetting)")) // Calculate Speed
            self.GPSCourse = String(format: "%.5f", GPS.course) // Direction of Movement
            self.GPSTimestamp = datestring // Timestamp
            self.GPSDesiredAccuracy = SettingsAPI.shared.readGPSAccuracySetting() // GPS Accuracy
            
            // Print all GPS Variables for Debug
            print("Latitude: \(self.GPSLatitude)")
            print("Longitude: \(self.GPSLongitude)")
            print("Horizontal Accuracy: \(self.GPSHorizontalAccuracy)")
            print("Altitude: \(self.GPSAltitude)")
            print("VerticalAccuracy: \(self.GPSVerticalAccuracy)")
            print("Speed in \(SettingsAPI.shared.readSpeedSetting()): \(self.GPSSpeed)")
            print("Direction: \(self.GPSCourse)")
            print("Timestamp: \(self.GPSTimestamp)")
            print("Desired Accuracy: \(self.GPSDesiredAccuracy)")
        }
    }
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        CoreMotionAPI.shared.clearMotionArray {
        }
    }
    
    func onDisappear() {
        CoreLocationAPI.shared.stopGPS()
        CoreMotionAPI.shared.motionStopMethod()
        CoreMotionAPI.shared.clearMotionArray {
        }
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        // Start Location update
        locationStart()
        
        
        // MARK: - Return View
        return NavigationView {
            GeometryReader { g in
                VStack {
                    ScrollView {
                        Spacer()
                        Group{
                            Text("Latitude: \(self.GPSLatitude) ±\(self.GPSHorizontalAccuracy)m")
                                .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                            Spacer()
                            Text("Longitude: \(self.GPSLongitude) ° ±\(self.GPSHorizontalAccuracy)m")
                                .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                            Spacer()
                            Text("Altitude: \(self.GPSAltitude) ±\(self.GPSVerticalAccuracy)m")
                                .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                            Spacer()
                            Text("Direction: \(self.GPSCourse) °")
                                .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                            Spacer()
                            Text("Speed: \(self.GPSSpeed) \(SettingsAPI.shared.readSpeedSetting())")
                                .frame(width: g.size.width - 10, height: CGFloat(50), alignment: .leading)
                        }
                        .font(.body)
                        .foregroundColor(Color("StandardTextColor"))
                        .background(Color("StandardBackgroundColor"))
                        .cornerRadius(10)
                        
                        Spacer()
                        MapKitViewModel(latitude: Double(self.GPSLatitude)!, longitude: Double(self.GPSLongitude)!)
                            .frame(width: g.size.width - 10, height: g.size.width - 10, alignment: .center)
                    }
                    .frame(width: g.size.width, height: g.size.height - 50 + g.safeAreaInsets.bottom)
                    
                    
                    // MARK: - LocationToolBarViewModel()
                    LocationToolBarViewModel()
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle("Location", displayMode: .inline)
            .navigationBarHidden(true)
            .background(Color("ViewBackgroundColor").edgesIgnoringSafeArea(.all))
        }
        .navigationBarTitle("Location", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear { self.onAppear() }
        .onDisappear { self.onDisappear() }
    }
}


// MARK: - Preview
#if DEBUG
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationView().previewDevice("iPhone Xs")
            LocationView().previewDevice("iPhone Xs")
                .environment(\.colorScheme, .dark)
            //LocationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //LocationView().previewDevice("iPad Pro (12.9-inch) (3rd generation)")
            //.environment(\.colorScheme, .dark)
        }
    }
}
#endif
