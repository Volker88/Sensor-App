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
    let locationAPI = CoreLocationAPI()
    let calculationAPI = CalculationAPI()
    let settings = SettingsAPI()
    
    
    // MARK: - @State / @ObservedObject / @Binding
    @ObservedObject var locationVM = CoreLocationViewModel()
    
    
    // MARK: - Define Constants / Variables
    
    
    // MARK: - Initializer
    
    
    // MARK: - Methods
    
    
    // MARK: - onAppear / onDisappear
    func onAppear() {
        locationVM.startLocationUpdates()
    }
    
    func onDisappear() {
        locationVM.stopLocationUpdates()
        locationVM.coreLocationArray.removeAll()
    }
    
    
    // MARK: - Body - View
    var body: some View {
        
        
        // MARK: - Return View
        return List {
            Text("Latitude: \(locationVM.coreLocationArray.last?.latitude ?? 0.0, specifier: "%.10f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Latitude (watchOS)")
            Text("Longitude: \(locationVM.coreLocationArray.last?.longitude ?? 0.0, specifier: "%.10f")° ± \(locationVM.coreLocationArray.last?.horizontalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Longitude (watchOS)")
            Text("Altitude: \(locationVM.coreLocationArray.last?.altitude ?? 0.0, specifier: "%.2f") ± \(locationVM.coreLocationArray.last?.verticalAccuracy ?? 0.0, specifier: "%.2f")m", comment: "LocationView - Altitude (watchOS)")
            Text("Direction: \(locationVM.coreLocationArray.last?.course ?? 0.0, specifier: "%.2f")°", comment: "LocationView - Direction (watchOS)")
            Text(verbatim: "\(NSLocalizedString("Speed:", comment: "LocationView - Speed (watchOS)")) \(calculationAPI.calculateSpeed(ms: locationVM.coreLocationArray.last?.speed ?? 0.0, to: "\(settings.fetchUserSettings().GPSSpeedSetting)")) \(settings.fetchUserSettings().GPSSpeedSetting)")
        }
        .navigationBarTitle("\(NSLocalizedString("Location", comment: "LocationView - NavigationBar Title (watchOS)"))")
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
