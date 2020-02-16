//
//  LocationView.swift
//  Sensor-App
//
//  Created by Volker Schmitt on 17.11.19.
//  Copyright © 2019 Volker Schmitt. All rights reserved.
//


// MARK: - Import
import SwiftUI


// MARK: - Struct
struct LocationView: View {
    
    // MARK: - Initialize Classes
    
    
    // MARK: - @State / @ObservedObject
    @ObservedObject var locationVM = CoreLocationViewModel()
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        // Start updating location
        locationVM.locationUpdateStart()
    }
    
    func onDisappear() {
        CoreLocationAPI.shared.stopUpdatingGPS()
        locationVM.coreLocationArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return List {
            Text("Latitude: \(self.locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.10f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
            Text("Longitude: \(self.locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.10f")° ± \(self.locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m")
            Text("Altitude: \(self.locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(self.locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m")
            Text("Direction: \(self.locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°")
            Text("Speed: \(CalculationAPI.shared.calculateSpeed(ms: self.locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)"), specifier: "%.2f")\(SettingsAPI.shared.fetchUserSettings().GPSSpeedSetting)")
        }
        .navigationBarTitle("Location")
        .font(.footnote)
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
    
    }
}


// MARK: - Preview
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LocationView().previewDevice("Apple Watch Series 3 - 38mm")
            LocationView().previewDevice("Apple Watch Series 4 - 44mm")
        }
    }
}
